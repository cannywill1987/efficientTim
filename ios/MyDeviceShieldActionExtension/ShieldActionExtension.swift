//
//  ShieldConfigurationExtension.swift
//  ShieldConfiguration
//
//  Created by 林智彬 on 2023/8/24.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit
import SwiftUI

extension String {
    /// 调用本地化
    func localizableString() -> String {
        return Bundle.main.localizedString(forKey: self, value: nil, table: nil)
    }
    
}

class ShieldActionExtension: ShieldActionDelegate {
    
    override func handle(action: ShieldAction, for application: ApplicationToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        switch action {
        case .primaryButtonPressed:
//            NotificationManager.shared.requestNotificationCreate(
//                title: "lock_screen_notification",
//                subtitle: "locascreen_start"
//                )
            completionHandler(.close)
            break;
        case .secondaryButtonPressed:
//            requestSendNoti(seconds: 1, title: "")
            completionHandler(.defer)
            break;
        @unknown default:
            break;
        }
    }
    
    // MARK: WebDomainToken으로 설정 된 웹에서 버튼 클릭 시 동작을 설정합니다.
    override func handle(
        action: ShieldAction,
        for webDomain: WebDomainToken,
        completionHandler: @escaping (ShieldActionResponse) -> Void) {
            // Handle the action as needed.
            switch action {
            case .primaryButtonPressed:
                /// 시스템이 현재 어플리케이션이나 웹 브라우저를 닫도록 합니다.
//                NotificationManager.shared.requestNotificationCreate(
//                    title: "lock_screen_notification",
//                    subtitle: "locascreen_start"
//                    )
                completionHandler(.close)
            case .secondaryButtonPressed:
                /// 액션에 대한 응답을 지연시키며 뷰를 갱신합니다.
//                requestSendNoti(seconds: 1, title: tokenName)
                completionHandler(.defer)
            @unknown default:
                fatalError()
            }
        }
    
}

// Override the functions below to customize the shields used in various situations.
// The system provides a default appearance for any methods that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
@available(iOS 15.0, *)
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    let imageName = "180"

    override func configuration(shielding application: Application) -> ShieldConfiguration {
        // Customize the shield as needed for applications.
        return ShieldConfiguration(
            backgroundBlurStyle: UIBlurEffect.Style.systemMaterialLight,
                   backgroundColor: UIColor(red: 0.71, green: 0.66, blue: 0.98, alpha: 1.00),
//            backgroundEffect:UIBlurEffect.Style.light,
//            backgroundColor: UIColor.lightGray,
            icon: UIImage(named: imageName),
            title: ShieldConfiguration.Label(text: "title".localizableString(), color: UIColor.orange),
            subtitle: ShieldConfiguration.Label(text: "lock_app_desc".localizableString(), color: UIColor.orange),
            primaryButtonLabel: ShieldConfiguration.Label(text: "confirm".localizableString(), color: UIColor.orange),
            secondaryButtonLabel: ShieldConfiguration.Label(text: "cancel".localizableString(), color: UIColor.orange)
        )
    }
    
    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for applications shielded because of their category.
        return ShieldConfiguration(
            backgroundBlurStyle: UIBlurEffect.Style.systemMaterialLight,
                   backgroundColor: UIColor(red: 0.71, green: 0.66, blue: 0.98, alpha: 1.00),
//            backgroundColor: UIColor.lightGray,
            icon: UIImage(named: imageName),
            title: ShieldConfiguration.Label(text: "title".localizableString(), color: UIColor.orange),
            subtitle: ShieldConfiguration.Label(text: "lock_app_desc".localizableString(), color: UIColor.orange),
            primaryButtonLabel: ShieldConfiguration.Label(text: "confirm".localizableString(), color: UIColor.orange),
            secondaryButtonLabel: ShieldConfiguration.Label(text: "cancel".localizableString(), color: UIColor.orange)
        )
    }
    
    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        // Customize the shield as needed for web domains.
        return ShieldConfiguration(
            backgroundBlurStyle: UIBlurEffect.Style.systemMaterialLight,
                   backgroundColor: UIColor(red: 0.71, green: 0.66, blue: 0.98, alpha: 1.00),
            icon: UIImage(named: imageName),
            title: ShieldConfiguration.Label(text: "title".localizableString(), color: UIColor.orange),
            subtitle: ShieldConfiguration.Label(text: "lock_app_desc".localizableString(), color: UIColor.orange),
            primaryButtonLabel: ShieldConfiguration.Label(text: "confirm".localizableString(), color: UIColor.orange),
            secondaryButtonLabel: ShieldConfiguration.Label(text: "cancel".localizableString(), color: UIColor.orange)
        )
    }
    
    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for web domains shielded because of their category.
        return ShieldConfiguration(
//            backgroundEffect:UIBlurEffect.Style.light,
            backgroundBlurStyle: UIBlurEffect.Style.systemMaterialLight,
                   backgroundColor: UIColor(red: 0.71, green: 0.66, blue: 0.98, alpha: 1.00),
            icon: UIImage(named: imageName),
            title: ShieldConfiguration.Label(text: "title".localizableString(), color: UIColor.orange),
            subtitle: ShieldConfiguration.Label(text: "lock_app_desc".localizableString(), color: UIColor.orange),
            primaryButtonLabel: ShieldConfiguration.Label(text: "confirm".localizableString(), color: UIColor.orange),
            secondaryButtonLabel: ShieldConfiguration.Label(text: "cancel".localizableString(), color: UIColor.orange)
            )
    }
}
