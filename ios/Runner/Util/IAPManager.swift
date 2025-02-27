import StoreKit

@available(iOS 15.0, *)
class IAPManager: NSObject, SKRequestDelegate {
    static let shared = IAPManager()
    private var products: [Product] = [] // 存储从 App Store 获取的产品
    private var purchaseCompletion: ((Int, Error?) -> Void)? // -1 失败 0 未开始 1 请求中 2 请求成功 3 恢复成功
    private var completionHandler: (([Product]) -> Void)?
    private var completionPurchaseHandler: ((Int, Int, String, Error?) -> Void)? // -1 失败 0 未开始 1 请求中 2 请求成功 3 restore成功 第二个参数时间戳
    private var onSuccess: (() -> Void)?
    private var onFailure: ((Error?) -> Void)?
    
    /// 获取订阅的到期时间戳和 originalID（秒级时间戳）
    /// 返回格式: ["expireDate": 时间戳, "originalID": originalID]
    func getSubscriptionDetails() async -> [String: Any]? {
        do {
            // 遍历当前有效的订阅交易
            for await result in Transaction.currentEntitlements {
                switch result {
                case .verified(let transaction):
                    if let expirationDate = transaction.expirationDate {
                        let originalID = transaction.originalID
                        let expireDateTimestamp = expirationDate.timeIntervalSince1970 * 1000
                        print("订阅有效期到: \(expirationDate), 原始交易ID: \(originalID)")
                        
                        // 返回包含时间戳和 originalID 的字典
                        return [
                            "expireDate": expireDateTimestamp,
                            "originalID": originalID
                        ]
                    } else {
                        print("无法获取订阅的到期时间")
                    }
                case .unverified(_, let error):
                    print("交易验证失败: \(error.localizedDescription)")
                }
            }
        } catch {
            print("检查订阅状态时出错: \(error.localizedDescription)")
        }
        return nil
    }
    /// 获取订阅的到期时间戳（秒级时间戳）
    //    func getSubscriptionExpireDateTimestamp() async -> TimeInterval? {
    //        do {
    //            // 遍历当前有效的订阅交易
    //            for await result in Transaction.currentEntitlements {
    //                switch result {
    //                case .verified(let transaction):
    //
    //                    if let expirationDate = transaction.expirationDate {
    //                        print("订阅有效期到: \(expirationDate)")
    //                        // 返回到期时间的时间戳
    //                        return expirationDate.timeIntervalSince1970 * 1000
    //                    } else {
    //                        print("无法获取订阅的到期时间")
    //                    }
    //                case .unverified(_, let error):
    //                    print("交易验证失败: \(error.localizedDescription)")
    //                }
    //            }
    //        } catch {
    //            print("检查订阅状态时出错: \(error.localizedDescription)")
    //        }
    //        return nil
    //    }
    
    /// 获取产品信息
    func fetchProducts(productIDs: [String], completion: @escaping ([Product]) -> Void) async -> Void {
        do {
            let fetchedProducts = try await Product.products(for: productIDs)
            self.products = fetchedProducts
            print("Fetched products successfully.")
            self.completionHandler = completion
            self.completionHandler!(self.products)
        } catch {
            print("Failed to fetch products: \(error.localizedDescription)")
        }
    }
    
    /// 显示产品信息
    func displayProducts(products: [Product]) {
        for product in products {
            print("Product Name: \(product.displayName)")
            print("Description: \(product.description)")
            print("Price: \(product.price)")
            print("ID: \(product.id)")
        }
    }
    
    /// 发起购买
    func purchase(productID: String, completion: @escaping (Int, Int, String, Error?) -> Void) async -> Void {
        guard let product = products.first(where: { $0.id == productID }) else {
            print("Product not found for ID: \(productID)")
            completion(-1, 0, "", NSError(domain: "EventNotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "Event not found in customEvents"]))
            return
        }

        self.completionPurchaseHandler = completion

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    print("Purchase verified successfully for \(transaction.productID).")
                    let expirationTime = Int(transaction.expirationDate?.timeIntervalSince1970 ?? 0) * 1000
                    completion(2, expirationTime, String(transaction.originalID), nil)
                    await transaction.finish()
                case .unverified(_, let error):
                    print("Purchase failed verification: \(error.localizedDescription)")
                    completion(-1, 0, "", error)
                }
            case .pending:
                print("Purchase pending.")
                completion(1, 0, "", nil)
            case .userCancelled:
                print("User cancelled the purchase.")
                completion(4, 0, "", nil)
            @unknown default:
                print("Unknown purchase result.")
                completion(-1, 0, "", NSError(domain: "UnknownResult", code: 500, userInfo: [NSLocalizedDescriptionKey: "Unknown purchase result."]))
            }
        } catch {
            print("Failed to purchase product: \(error.localizedDescription)")
            completion(-1, 0, "", error)
        }
    }
    
    /// 恢复购买
    func restorePurchases(completion: @escaping (String, Int, String, Error?) -> Void) async -> Void {
        do {
            for await result in Transaction.currentEntitlements {
                if case .verified(let transaction) = result {
                    print("Restored transaction for product ID: \(transaction.productID)")
                    completion(transaction.productID, Int(transaction.expirationDate?.timeIntervalSince1970 ?? 0) * 1000, String(transaction.originalID), nil)
                    print("Purchase verified successfully for \(transaction.productID).")
                    await transaction.finish()
                    
//                    return /*transaction.productID*/
                } else {
                    print("Failed to verify restored transaction.")
                    completion("-1", 0, "", nil)
                }
            }
        } catch {
            print("Failed to restore purchases: \(error.localizedDescription)")
            completion("-1", 0, "", nil)
        }
        completion("-1", 0, "", nil)
    }
    
    /// 检查订阅状态
    func checkSubscriptionState(productID: String) async -> Int {
        guard let product = products.first(where: { $0.id == productID }),
              let subscription = product.subscription else {
            print("Product does not have subscription information.")
            return -1
        }
        
        guard let status = try? await subscription.status else {
            return  -1;
        }
        
        // 遍历用户的订阅状态列表
        for state in status {
            // 根据用户的订阅状态（state.state）进行处理
            switch state.state {
            case .subscribed:
                // 用户处于已订阅状态
                print("User is subscribed.")
                return 2 // 返回状态码 2，表示已订阅
                
            case .inBillingRetryPeriod:
                // 用户的订阅处于账单重试期（例如信用卡扣款失败）
                debugPrint("getSubscriptionStatus user subscription is in billing retry period.")
                return 3 // 返回状态码 3，表示账单重试期
                
            case .inGracePeriod:
                // 用户的订阅处于宽限期（例如扣款失败但仍给予访问权限）
                debugPrint("getSubscriptionStatus user subscription is in grace period.")
                return 4 // 返回状态码 4，表示宽限期
                
            case .expired:
                // 用户的订阅已过期
                print("Subscription has expired.")
                return 1 // 返回状态码 1，表示订阅已过期
                
            case .revoked:
                // 用户的订阅被撤销（可能由于退款或政策原因）
                print("Subscription was revoked.")
                return 0 // 返回状态码 0，表示订阅被撤销
                
            default:
                // 无法识别的订阅状态
                print("Subscription state is unknown.")
                return -1 // 返回状态码 -1，表示未知状态
            }
        }
        return -1;
    }
    
    //Fetch App Receipt Data

    public func getReceipt() -> String {

        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
            FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {

            do {
                let receiptData = try Data(contentsOf: appStoreReceiptURL,
                                              options: .alwaysMapped)
                print(receiptData)
                
                let receiptString = receiptData.base64EncodedString(options: [])
                
                print("receipt send it to your server: \(receiptString)")
                return receiptString;
                // Read receiptData
            }
            catch {
                print("Couldn't read receipt data with error: " + error.localizedDescription)
            }
        }
        return "";
    }
    
    func restoreTransaction(
        productIDsToRestore: [String],
        transaction: SKPaymentTransaction,
        onSuccess: (() -> Void)? = nil,
        onFailure: ((Error?) -> Void)? = nil
    ) {
        guard let identifier = transaction.transactionIdentifier else {
            onFailure?(NSError(domain: "RestoreError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Transaction identifier is missing."]))
            return
        }
        
        if productIDsToRestore.contains(identifier) {
            // Re-download Apple-hosted content
            reDownloadContent(for: identifier) { success in
                if success {
                    onSuccess?()
                } else {
                    onFailure?(NSError(domain: "RestoreError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to re-download content."]))
                }
            }
        } else {
            onFailure?(NSError(domain: "RestoreError", code: 3, userInfo: [NSLocalizedDescriptionKey: "Transaction not found in the provided product IDs."]))
        }
        
        // Finish the transaction
        SKPaymentQueue.default().finishTransaction(transaction)
    }

    func reDownloadContent(for identifier: String, completion: @escaping (Bool) -> Void) {
        // Simulate content re-download process
        print("Re-downloading content for product: \(identifier)")
        
        // Simulate a success or failure
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            let success = true // Change to `false` to simulate a failure
            completion(success)
        }
    }
    
    /// Refresh the app receipt
    func refreshReceipt(onSuccess: @escaping () -> Void, onFailure: @escaping (Error?) -> Void) {
        self.onSuccess = onSuccess
        self.onFailure = onFailure
        
        let refreshRequest = SKReceiptRefreshRequest()
        refreshRequest.delegate = self
        refreshRequest.start()
    }
    
    // MARK: - SKRequestDelegate
    
    func requestDidFinish(_ request: SKRequest) {
        // Request completed successfully
        print("Receipt refresh completed successfully.")
        onSuccess?()
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        // Request failed
        print("Receipt refresh failed: \(error.localizedDescription)")
        onFailure?(error)
    }
}
