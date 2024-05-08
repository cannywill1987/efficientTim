//
//  FlutterViewControllerRoot.swift
//  test
//
//  Created by 林智彬 on 2022/2/27.
//

import UIKit
import Flutter
import ActivityKit
class FlutterViewControllerRoot: FlutterViewController, TencentSessionDelegate  {
    func tencentDidLogin() {
        print("1111111111")
    }
    
    func tencentDidNotLogin(_ cancelled: Bool) {
        print("222222222")
    }
    
    func tencentDidNotNetWork() {
        print("333333333")

    }
    
    func getUserInfoResponse(_ response: APIResponse!) {
           // 获取个人信息
           if response.retCode == 0 {
               
               if let res = response.jsonResponse {
                                
//                   if let uid = self.tencentAuth.getUserOpenID() {
//                      // 获取uid
//                   }
//                   
//                   if let name = res["nickname"] {
//                       // 获取nickname
//                   }
//                   
//                   if let sex = res["gender"] {
//                       // 获取性别
//                   }
//                   
//                   if let img = res["figureurl_qq_2"] {
//                       // 获取头像
//                   }
                  
               }
           } else {
              // 获取授权信息异常
           }
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TencentOAuth.setIsUserAgreedAuthorization(true);
        let tencentOAuth:TencentOAuth = TencentOAuth(appId: "1112263382", andDelegate: self)

//        let tencentOAuth:TencentOAuth = TencentOAuth(appId: "1112263382", andDelegate: self)
//        tencentOAuth.authorize(["get_user_info", "get_simple_userinfo"]);
//        let state = IslandAttributes.ContentState(value: 2);
//        let attr = IslandAttributes(name: "test")
//        print("11111111111111111111111111122222222222222222");
//        do {
//            if #available(iOS 16.1, *) {
//                self.activity = try Activity.request(attributes: attr, contentState: state)
//            } else {
//                // Fallback on earlier versions
//            }
//        } catch {
//            print("err \(error)")
//        }
    }
    
    //
    //     @objc func showFlutter() {
    //       let flutterEngine = (UIApplication.shared.delegate as! AppDelegate).flutterEngine
    //       let flutterViewController =
    //           FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
    //       present(flutterViewController, animated: true, completion: nil)
    //     }
    //
    //    override showFlutter() {
    //        let flutterEngine = (UIApplication.shared.delegate as! AppDelegate).flutterEngine
    //        let flutterViewController =
    //            FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
    //        present(flutterViewController, animated: true, completion: nil)
    //    }
    
    // Returns the key window's rootViewController, if it's a FlutterViewController.
    // Otherwise, returns nil.
    //    - (FlutterViewController*)rootFlutterViewController {
    //        UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    //        if ([viewController isKindOfClass:[FlutterViewController class]]) {
    //            return (FlutterViewController*)viewController;
    //        }
    //        return nil;
    //    }
    //
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
