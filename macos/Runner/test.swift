//
//  test.swift
//  Runner
//
//  Created by 林智彬 on 2023/9/11.
//

import SwiftUI

struct test: View {
    var body: some View {
        VStack {
            ZStack{
                VStack {
                    HStack {
                        Text("2017")
                            .bold()
                            .padding(.horizontal, 8)
                        Spacer()
                    }
                    .padding(2)
                }
                ZStack {
                    Image("ic_calendar")
                        .resizable()
                        .frame(width: 30, height: 30)
                    VStack(alignment: .trailing) {
                        Spacer()
                        HStack(alignment: .center){
                            Text("1")
                                .bold()
                                .foregroundColor(Color.gray).padding(EdgeInsets(top: 0, leading: 0, bottom: 4, trailing: 0))
                        }
                    }.frame(width: 30, height: 30)
                    
                    //                               .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                }
                // Rest of your layout
            }.frame(height: 60)
                .background(Color.white)
                .edgesIgnoringSafeArea(.all)
            HStack {
                Spacer()
                VStack {
                    Text("星期一").font(.system(size: 8))
                }
                Spacer()
                VStack {
                    Text("星期二").font(.system(size: 8))
                }
                Spacer()
                VStack {
                    Text("星期三").font(.system(size: 8))
                }
                Spacer()
                VStack {
                    Text("星期四").font(.system(size: 8))
                }
                Spacer()
//                VStack {
//                    Text("星期五")
//                }
//                Spacer()
//                VStack {
//                    Text("星期六")
//                }
//                Spacer()
//                VStack {
//                    Text("星期日")
//                }
//                Spacer()
            }
        }
    }
}

struct test_Previews: PreviewProvider {
    static var previews: some View {
        test()
    }
}
