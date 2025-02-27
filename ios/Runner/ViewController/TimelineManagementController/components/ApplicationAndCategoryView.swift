////
////  ApplicationAndCategoryView.swift
////  Runner
////
////  Created by 林智彬 on 2023/8/23.
////
//
//import SwiftUI
//import ManagedSettings
//import FamilyControls
//
//@available(iOS 15.2, *)
//struct ApplicationAndCategoryView: View {
//    @Binding var title: String
//    @Binding var datasApplicationToken: [ActivityCategoryToken]
////    @Binding var selection = FamilyActivitySelection()
//
//    var body: some View {
//        VStack {
//            Text(title)
//                .font(.headline)
//                .padding(.bottom, 10)
//
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(spacing: 5) {
//                    ForEach(datasApplicationToken, id: \.self) { data in
//                        VStack {
//                            Label(data)
//                            Text("10mins")
//                                .font(.footnote)
//                                .foregroundColor(.gray)
//                        }
//                    }
//                }
//            }
//        }
//        .padding(EdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12))
//        .background(Color.white)
//        .cornerRadius(10)
//        .shadow(radius: 1)
//    }
//}
//
////struct ApplicationAndCategoryView_Previews: PreviewProvider {
////    static var previews: some View {
////        ApplicationAndCategoryView()
////    }
////}
