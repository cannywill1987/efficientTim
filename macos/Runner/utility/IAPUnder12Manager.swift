//
//  IAPManager.swift
//  Runner
//
//  Created by 林智彬 on 2024/12/3.
//
import StoreKit

/// 订阅续订状态枚举
enum SubscriptionRenewalState: String {
    case willRenew = "willRenew" // 自动续订状态
    case canceled = "canceled"  // 已取消续订
    case unknown = "unknown"    // 状态未知
}

class IAPUnder12Manager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver, SKPaymentQueueDelegate {
    static let shared = IAPUnder12Manager()
    var products: [SKProduct] = [] // 存储从 App Store 获取的产品
    private var completionHandler: (([SKProduct]) -> Void)?
    private var completionPurchaseHandler: ((Int, Error?) -> Void)? // -1 失败 0 未开始 1 请求中 2 请求成功 3 restore成功
    
    func checkSubscriptionRenewalState(product: SKProduct) {
        guard let receiptData = fetchReceipt() else {
            print("无法获取收据")
            return
        }

        let receiptString = receiptData.base64EncodedString(options: [])
        validateReceipt(receiptString: receiptString) { renewalState in
            switch renewalState {
            case .willRenew:
                print("订阅成功并处于自动续订状态")
            case .canceled:
                print("订阅已取消或不会续订")
            case .unknown:
                print("订阅状态未知")
            }
        }
    }

    /// 获取收据
    private func fetchReceipt() -> Data? {
        guard let appStoreReceiptURL = Bundle.main.appStoreReceiptURL else {
            return nil
        }
        return try? Data(contentsOf: appStoreReceiptURL)
    }

    /// 验证收据并获取续订状态
    private func validateReceipt(receiptString: String, completion: @escaping (SubscriptionRenewalState) -> Void) {
        // 假设使用的是后端 API 验证收据
        // 后端根据 Apple 的验证接口解析并返回续订状态
        // 这里是一个示例代码
        let fakeServerResponse = ["renewalState": "willRenew"] // 模拟从后端返回的状态
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) { // 模拟异步请求
            if let stateString = fakeServerResponse["renewalState"] {
                let renewalState = SubscriptionRenewalState(rawValue: stateString) ?? .unknown
                DispatchQueue.main.async {
                    completion(renewalState)
                }
            } else {
                DispatchQueue.main.async {
                    completion(.unknown)
                }
            }
        }
    }
    
//    3. 验证订阅状态
//    func fetchReceipt() -> Data? {
//        guard let appStoreReceiptURL = Bundle.main.appStoreReceiptURL else { return nil }
//        return try? Data(contentsOf: appStoreReceiptURL)
//    }
    
    /// 发起购买请求
    func purchaseSubscription(product: SKProduct) {
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        } else {
            print("User cannot make payments")
        }
    }
    
    func requestPayment() {
        let product = SKProduct();
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    // 续费
    func restoreCompletedTransactions() {
        
    }

    func restoreCompletedTransactions(withApplicationUsername username: String?) {
        
    }
    //恢复购买
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    // 获取产品信息
    func fetchProducts(list: [String], completion: @escaping ([SKProduct]) -> Void) {
        // Ensure the product list is not empty
           guard !list.isEmpty else {
               print("Product list is empty. Please provide valid product identifiers.")
               return
           }
           
           // Create a set of product identifiers
           let productIDs: Set<String> = Set(list)
           
           // Initialize a request for the product identifiers
           let request = SKProductsRequest(productIdentifiers: productIDs)
           request.delegate = self // Set the delegate to receive response
           request.start() // Start the request
           
        // 回调处理
        self.completionHandler = completion
           print("Fetching products for identifiers: \(list)")
    }
    
    

    // SKProductsRequestDelegate 这个是回调
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        for product in response.products {
            print("Product: \(product.localizedTitle), Price: \(product.price)")
        }
        // 保存有效的产品
        self.products = response.products

        // 打印无效的产品标识符（用于调试）
        if !response.invalidProductIdentifiers.isEmpty {
            print("Invalid product IDs: \(response.invalidProductIdentifiers)")
        }

        // 回调有效产品
        completionHandler?(response.products)
    }
    
    func displayProducts(products: [SKProduct]) {
        for product in products {
            print("Product Title: \(product.localizedTitle)")
            print("Product Description: \(product.localizedDescription)")
            print("Product Price: \(product.priceLocale.currencySymbol ?? "")\(product.price)")
            print("Product Identifier: \(product.productIdentifier)")
        }
    }
    
    /// 错误处理
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load products: \(error.localizedDescription)")
        completionHandler?([])
    }

    func purchase(productID: String, completion: @escaping (Int, Error?) -> Void) {
        guard let product = products.first(where: { $0.productIdentifier == productID }) else {
            completion(-1, NSError(domain: "EventNotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "Event not found in customEvents"]))
            return
        }
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
            self.completionPurchaseHandler = completion;
        } else {
            completion(-1, NSError(domain: "User cannot make payments", code: 404, userInfo: [NSLocalizedDescriptionKey: "Event not found in customEvents"]))
            print("User cannot make payments")
        }
    }
    
    // 购买产品
//    func purchase(product: SKProduct) {
//        if SKPaymentQueue.canMakePayments() {
//            let payment = SKPayment(product: product)
//            SKPaymentQueue.default().add(payment)
//        } else {
//            print("User cannot make payments")
//        }
//    }

    // 处理交易
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                if self.completionPurchaseHandler != nil {
                    self.completionPurchaseHandler!(2, nil)
                }
                print("Purchase successful for \(transaction.payment.productIdentifier)")
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                if self.completionPurchaseHandler != nil {
                    self.completionPurchaseHandler!(-1, nil)
                }
                print("Purchase failed")
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                if self.completionPurchaseHandler != nil {
                    self.completionPurchaseHandler!(3, nil)
                }
                print("Restored: \(transaction.payment.productIdentifier)")
                SKPaymentQueue.default().finishTransaction(transaction)
            case .purchasing:
//                if self.completionPurchageHandler != nil {
//                    self.completionPurchageHandler!(false, nil)
//                }
                print("purchasing: \(transaction.payment.productIdentifier)")
            case .deferred:
                print("deferred: \(transaction.payment.productIdentifier)")
            default:
                break
            }
        }
    }
    
    // 检查设备是否支持 Apple Pay
//      func isApplePayAvailable() -> Bool {
//          return PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: [.visa, .masterCard, .amex])
//      }
    
    
      
}
