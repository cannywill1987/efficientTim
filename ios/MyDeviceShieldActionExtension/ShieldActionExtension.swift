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

// Override the functions below to customize the shields used in various situations.
// The system provides a default appearance for any methods that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
@available(iOS 15.0, *)
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    let imageName = "mustsleep_80.png"

    override func configuration(shielding application: Application) -> ShieldConfiguration {
        // Customize the shield as needed for applications.
        return ShieldConfiguration(
//            backgroundEffect:UIBlurEffect.Style.light,
            backgroundColor: UIColor.lightGray,
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
//            backgroundEffect:UIBlurEffect.Style.light,
            backgroundColor: UIColor.lightGray,
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
//            backgroundEffect:UIBlurEffect.Style.light,
            backgroundColor: UIColor.lightGray,
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
            backgroundColor: UIColor.lightGray,
            icon: UIImage(named: imageName),
            title: ShieldConfiguration.Label(text: "title".localizableString(), color: UIColor.orange),
            subtitle: ShieldConfiguration.Label(text: "lock_app_desc".localizableString(), color: UIColor.orange),
            primaryButtonLabel: ShieldConfiguration.Label(text: "confirm".localizableString(), color: UIColor.orange),
            secondaryButtonLabel: ShieldConfiguration.Label(text: "cancel".localizableString(), color: UIColor.orange)
            )
    }
}
