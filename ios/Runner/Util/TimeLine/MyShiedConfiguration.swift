//
//  MyShiedConfiguration.swift
//  Runner
//
//  Created by 林智彬 on 2023/8/24.
//
import Foundation
import ManagedSettings
import ManagedSettingsUI
import SwiftUI
@available(iOS 15.0, *)
class MyShieldConfiguration: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        return ShieldConfiguration(
//            backgroundEffect:UIBlurEffect.Style.light,
            backgroundColor: UIColor.lightGray,
//            icon: Icon(image: UIImage(named: "AppIcon")),
            title: ShieldConfiguration.Label(text: "时间管理局", color: UIColor.orange),
            subtitle: ShieldConfiguration.Label(text: "123", color: UIColor.orange)
        )
    }
}
//override func configuration(for application: Application) -> ShieldConfiguration {
//return ShieldConfiguration( backgroundEffect: backgroundColor:
//icon: a
//title: ShieldConfiguration. Label (
//text:
//color:
//).
//subtitle:
