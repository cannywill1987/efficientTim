//
//  SwiftUIView.swift
//  Runner
//
//  Created by 林智彬 on 2023/10/18.
//
import WidgetKit
import SwiftUI

import SwiftUI
//struct SwiftUIView: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        SwiftUIView()
//    }
//}

struct NoteViewWidget : View {
//    var entry: Provider.Entry
    var missionData:WQBMissionModel?
    var subTitle: String?
    var body: some View {
           ZStack {
               // 设置背景色为黄色
               Color(hex:(missionData?.color ?? 0xfff2b1)).edgesIgnoringSafeArea(.all)
               
               VStack(alignment: .leading) {
                   // 设置Text的属性
                   Text(missionData?.content ?? "")
                       .lineLimit(15) // 最多15行
                       .lineSpacing(8) // 行间距8
                       .font(.system(size: 12))
                       .foregroundColor(Color(hex:(0x404040))) // 文字颜色
                       .padding(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10)) // 设置边距
                   
                   Spacer()
                   
                   HStack {
                       Spacer()
                       // 右下角的“便签1” Text
                       Text(subTitle ?? missionData?.subtitle ?? "")
                           .font(.system(size: 12))
                           .foregroundColor(.gray)
                           .padding(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
                   }
               }
           }
       }
}
