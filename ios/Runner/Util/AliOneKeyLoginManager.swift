//
//  AliOneKeyLoginManager.swift
//  Runner
//
//  Created by 林智彬 on 2022/12/28.
//

import Foundation
//import MOBFoundation
//import SecVerify
import Flutter
import 
import "PNSMainController.h"
import "PNSBaseNavigationController.h"
import "ATAU"

class AliOneKeyLoginManager{
    static let instance:AliOneKeyLoginManager = AliOneKeyLoginManager()
    var flutterViewController: FlutterViewController?;
    static func shareInstance(flutterViewController: FlutterViewController) -> AliOneKeyLoginManager {
        if (instance.flutterViewController == nil) {
            instance.flutterViewController = flutterViewController;
        }
        return instance;
    }
    
    init () {}
    
    //MAKR: 一键登录
        func toLoginAction() {
            let model = createLoginModel()
            TXCommonHandler.sharedInstance().getLoginToken(withTimeout: 3.0, controller: self, model: model) { resultDic in
                if let dict = resultDic as? Dictionary<String, Any> {
                    var resultCode = ""
                    if let code = dict["resultCode"] as? String {
                        resultCode = code
                    }
                    
                    if resultCode == PNSCodeLoginControllerPresentSuccess {
                        print("授权页拉起成功回调：\(dict)")
                    } else if resultCode == PNSCodeLoginControllerClickCancel {
                        print("用户取消一键登录：\(dict)")
                        TXCommonHandler.sharedInstance().cancelLoginVC(animated: true, complete: nil)
                    } else if resultCode == PNSCodeLoginControllerClickLoginBtn {
                        print("用户点击一键登录:\(dict)")
                        
                        var isChecked : Int = 0
                        if let checked = dict["isChecked"] as? Int {
                            isChecked = checked
                        }
                        if isChecked == 0 {
                            HBAlertUtils.hb_showFailMessage("请先同意相关开发协议", in: UIApplication.topViewController()?.view)
                            return
                        }
                    } else if resultCode == PNSCodeLoginControllerClickCheckBoxBtn {
                        print("用户点击是否同意协议:\(dict)")
                        
                    } else if resultCode == PNSCodeLoginControllerClickChangeBtn {
                        print("用户点击切换其他登录")
                        
                        TXCommonHandler.sharedInstance().cancelLoginVC(animated: true) {
                            let telLogin = LoginTelphoneController()
                            self.navigationController!.pushViewController(telLogin, animated: true)
                        }
                        
                    } else if resultCode == PNSCodeSuccess {
                        print("获取LoginToken成功回调：\(dict)")
                        print("接下来可以拿着Token去服务端换取手机号，有了手机号就可以登录，SDK提供服务到此结束")
                        var tokenText = ""
                        if let token = dict["token"] as? String {
                            tokenText = token
                        }
                        TXCommonHandler.sharedInstance().cancelLoginVC(animated: true) {
    //                        self.userLoginByAli(token: tokenText)
                        }
                    } else {
                        print("获取LoginToken或拉起授权页失败回调：\(dict)")
                        let telLogin = LoginTelphoneController()
                        self.navigationController!.pushViewController(telLogin, animated: true)
                    }
                }
            }
        }

    //MARK: 创建一键登录model
    func createLoginModel() -> TXCustomModel {
        let model = TXCustomModel()
        model.supportedInterfaceOrientations = .portrait
        model.navColor = UIColor.white
        model.navTitle = NSAttributedString(string: "")
        model.navBackImage = UIImage.init(named: "icn_dismiss_24")!
        model.hideNavBackItem = false
        model.logoImage = UIImage.init(named: "login_app_logo")!
    
        model.numberColor = UIColor.init(hexString: "#333333")
        model.numberFont = UIFont.init(name: PF_Regular, size: Font_24)!
        
        model.sloganIsHidden = true
        
        //一键登录
        var imgArr = [UIImage]()
        imgArr.append(UIImage.init(named: "login_ali_bg")!)
        imgArr.append(UIImage.init(named: "login_ali_bg")!)
        imgArr.append(UIImage.init(named: "login_ali_bg")!)
        model.loginBtnBgImgs = imgArr
        let loginTitle = "本机号码一键登录"
        let loginAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font:UIFont.init(name: PF_Regular, size: Font_17)]
        let loginAttri = NSAttributedString(string: loginTitle, attributes: loginAttribute as [NSAttributedString.Key : Any])
        model.loginBtnText = loginAttri
        
        model.changeBtnIsHidden = false
        let otherLoginTitle = "切换其他手机号"
        let otherLoginAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "#F9A51C"),NSAttributedString.Key.font:UIFont.init(name: PF_Regular, size: Font_15)]
        let otherLoginAttri = NSAttributedString(string: otherLoginTitle, attributes: otherLoginAttribute as [NSAttributedString.Key : Any])
        model.changeBtnTitle = otherLoginAttri
 
        var checkArr = [UIImage]()
        checkArr.append(UIImage.init(named: "icn_agree_normal")!)
        checkArr.append(UIImage.init(named: "icn_agree_selected")!)
        model.checkBoxImages = checkArr
        model.checkBoxIsChecked = false
        model.checkBoxIsHidden = false
        model.checkBoxImageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        model.checkBoxWH = 24
        
        model.privacyOne = ["《使用协议》","http://******"]
        model.privacyTwo = ["《隐私协议》","http://******"]
        model.privacyConectTexts = ["和","和"]
        model.privacyOperatorPreText = "《"
        model.privacyOperatorSufText = "》"
        model.privacyPreText = "已同意"
        model.privacyColors = [UIColor.init(hexString: "#757575"),UIColor.init(hexString: "#F4A30E")]
        model.privacyFont = UIFont.init(name: PF_Regular, size: Font_16)!
        model.privacyNavBackImage = UIImage.init(named: "icn_back_black_24")!
        
        //logo的位置
        model.logoFrameBlock = { (screenSize, superViewSize,frame) -> CGRect in
            return CGRect(x:kScreen_Width / 2 - 80, y: 21, width: 160, height: 136)
        }
        
        //手机号码的位置
        model.numberFrameBlock = { (screenSize, superViewSize,frame) -> CGRect in
            return CGRect(x: kScreen_Width / 2 - 72, y: 165, width: 144, height: 32)
        }
        
        model.privacyFrameBlock = {(screenSize, superViewSize,frame) -> CGRect in
            return CGRect(x: kScreen_Width / 2 - 148, y: KDeviceX ? 500 : 381, width: 296, height: 48)
        }
 
        //一键登录
        model.loginBtnFrameBlock = {(screenSize, superViewSize,frame) -> CGRect in
            return CGRect(x: kScreen_Width / 2 - 148, y: KDeviceX ? 558 : 439, width: 296, height: 48)
        }
        
        //其他登录
        model.changeBtnFrameBlock = {(screenSize, superViewSize,frame) -> CGRect in
            return CGRect(x: kScreen_Width / 2 - 75, y: KDeviceX ? 645 : 526, width: 150, height: 38)
        }
        
        
 
        return model
    }


}

