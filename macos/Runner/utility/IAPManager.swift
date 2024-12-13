//
//  IAPManager.swift
//  Runner
//
//  Created by 林智彬 on 2024/12/3.
//
import StoreKit

class IAPManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver, SKPaymentQueueDelegate {
    static let shared = IAPManager()
    var products: [SKProduct] = [] // 存储从 App Store 获取的产品
    private var completionHandler: (([SKProduct]) -> Void)?

//    3. 验证订阅状态
    func fetchReceipt() -> Data? {
        guard let appStoreReceiptURL = Bundle.main.appStoreReceiptURL else { return nil }
        return try? Data(contentsOf: appStoreReceiptURL)
    }
    
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

    // 购买产品
    func purchase(product: SKProduct) {
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        } else {
            print("User cannot make payments")
        }
    }

    // 处理交易
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                print("Purchase successful for \(transaction.payment.productIdentifier)")
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                print("Purchase failed")
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                print("Restored: \(transaction.payment.productIdentifier)")
                SKPaymentQueue.default().finishTransaction(transaction)
            case .purchasing:
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
