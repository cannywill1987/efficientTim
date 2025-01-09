import StoreKit

@available(macOS 12.0, *)
class IAPManager {
    static let shared = IAPManager()
    private var products: [Product] = [] // 存储从 App Store 获取的产品
    private var purchaseCompletion: ((Int, Error?) -> Void)? // -1 失败 0 未开始 1 请求中 2 请求成功 3 恢复成功
    private var completionHandler: (([Product]) -> Void)?
    private var completionPurchaseHandler: ((Int, Error?) -> Void)? // -1 失败 0 未开始 1 请求中 2 请求成功 3 restore成功

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
    func purchase(productID: String, completion: @escaping (Int, Error?) -> Void) async -> Bool {
        guard let product = products.first(where: { $0.id == productID }) else {
            print("Product not found for ID: \(productID)")
            completion(-1, NSError(domain: "EventNotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "Event not found in customEvents"]))
            return false
        }
        // -1 失败 0 未开始 1 请求中 2 请求成功 3 restore成功 4 用户取消购买
        self.completionPurchaseHandler = completion;

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    self.completionPurchaseHandler!(2, nil)
                    print("Purchase verified successfully for \(transaction.productID).")
                    await transaction.finish()
                    return true
                case .unverified(_, let error):
                    self.completionPurchaseHandler!(-1, error)
                    print("Purchase failed verification: \(error.localizedDescription)")
                    return false
                }
            case .pending:
                self.completionPurchaseHandler!(1, nil)
                print("Purchase pending.")
                return false
            case .userCancelled:
                self.completionPurchaseHandler!(4, nil)
                print("User cancelled the purchase.")
                return false
            @unknown default:
                self.completionPurchaseHandler!(-1, nil)
                print("Unknown purchase result.")
                return false
            }
        } catch {
            self.completionPurchaseHandler!(-1, nil)
            print("Failed to purchase product: \(error.localizedDescription)")
            return false
        }
    }

    /// 恢复购买
    func restorePurchases() async {
        do {
            for await result in Transaction.currentEntitlements {
                if case .verified(let transaction) = result {
                    print("Restored transaction for product ID: \(transaction.productID)")
                } else {
                    print("Failed to verify restored transaction.")
                }
            }
        } catch {
            print("Failed to restore purchases: \(error.localizedDescription)")
        }
    }

    /// 检查订阅状态
    func checkSubscriptionState(productID: String) async {
        guard let product = products.first(where: { $0.id == productID }),
              let subscription = product.subscription else {
            print("Product does not have subscription information.")
            return
        }
        
        guard let status = try? await subscription.status else {
            return;
        }
        for state in status {
            switch state.state {
            case .subscribed:
                print("User is subscribed.")
            case .expired:
                print("Subscription has expired.")
            case .revoked:
                print("Subscription was revoked.")
            default:
                print("Subscription state is unknown.")
            }
        }
    }
}
