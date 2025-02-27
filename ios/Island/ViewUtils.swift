//
//  ViewUtils.swift
//  LiveActivityDemo
//
//  Created by ak on 2022/11/15.
//

import Foundation
import SwiftUI

@available(iOS 15.0, *)
class MyViews {
    @available(iOS 16.0, *)
    @ViewBuilder
    static func CirclrIcon(_ name: String, color: Color = .red) -> some View {
        Circle()
            .foregroundColor(color)
            .overlay {
                Image(systemName: name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .padding(5)
                    .bold()
            }
    }
}

