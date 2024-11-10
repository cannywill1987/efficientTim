//
//  TimelineListView.swift
//  Runner
//
//  Created by 林智彬 on 2023/8/21.
//

import SwiftUI
import FamilyControls
import ManagedSettings
import ManagedSettingsUI


@available(iOS 16.0, *)
struct UITimelineListView: View {
    //    @ObservedObject var settings = UserSettings()
    @ObservedObject var settings = UserSettings()
    @State var isOn:Bool = false
    @State var selection = FamilyActivitySelection()
    @State var applicationTokens = Array<ApplicationToken>()
    @State var categoriesToken = Array<ActivityCategoryToken>()
    @State var tmpState:Bool = false //临时状态
    var viewController: TimelineListViewController

    //    @Binding var datas = [TimelineItem]
    @ObservedObject var model: ScreenTimeSelectAppsModel
    @State private var pickerIsPresented = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init(viewController: TimelineListViewController, model: ScreenTimeSelectAppsModel) {
        self.viewController = viewController
        self.model = model
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                HStack {
                    Button(action: {
                        Utility.dismissViewController(controller: self.viewController, animated: false)
                        self.presentationMode.wrappedValue.dismiss()
//                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left") // 使用系统的返回图标
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.blue)
                            Text("back".localizable())
                        }
                    }
                    .padding()
                    .navigationBarBackButtonHidden(false)
                    .zIndex(2)
                    Spacer()
                }
                VStack {
                    ForEach(self.settings.datasTimelineItem, id: \.id) { item in
                        VStack {
                            VStack {
                                HStack {
                                    HStack{
                                        VStack {
                                            HStack {
                                                Text("\(Utility.getHourAndMinuteString(from: item.startTime))-\(Utility.getHourAndMinuteString(from: item.endTime))")
                                                    .font(.headline)
                                                    .padding(.bottom, 10)
                                                Spacer()
                                            }
                                            HStack {
                                                Text("\(Utility.getWeekdaysFromBooleans(item.weekend ?? [false,false,false,false,false,false,false]))")
                                                    .font(.headline)
                                                    .padding(.bottom, 10)
                                                    .font(.system(size: 12, weight: .bold))
                                                    .foregroundColor(.gray)
                                                Spacer()
                                            }
                                        }
                                    }.padding(.top, 4)
                                    Spacer()
//                                alignment: .trailing
                                    VStack(alignment: .trailing) {
                                        Toggle(isOn: Binding(get: {
                                            item.isOn ?? false
                                        }, set: {
                                            item.isOn = $0
                                            SharepreferenceManager.shareInstance().updateTimelineItem(id: item.id ?? "", newTimelineItem: item, forKey: SharePreferenceKey.TimelineKey)
                                            if(item.isOn == true) {
                                                if(item.id != nil && item.startTime != nil && item.endTime != nil) {
                                                    //                                                    MyModel.shared.startMonitoring(activityName: item.id ?? "",intervalStart: item.startTime!, intervalEnd: item.endTime!, applicationTokens: item.applicationTokens, categoriesToken: item.categoriesToken, WebDomainToken: item.we)
                                                    MyModel.shared.startMonitoring(activityName: item.id ?? "", intervalStart: item.startTime, intervalEnd: item.endTime, applicationTokens: Set(item.applicationTokens ?? []), categoryTokens: Set(item.activityCategoryTokens ?? []), webDomainTokens: Set(item.webDomainTokens ?? []));
                                                }
                                            } else {
                                                MyModel.shared.stopMonitoring(activityName: item.id ?? "")
                                            }
                                        })) {
                                            Text("")
                                        }
                                        //                                        .simultaneousGesture(TapGesture().onEnded({
                                        //                                            print("isOn \(item.isOn)");
                                        //                                            print("1111111111");
                                        //                                        })
                                        //                                        )
                                        Spacer(minLength: 10)
                                        Text("edit".localizable())
                                            .font(.headline)
                                            .foregroundColor(.blue)
                                            .onTapGesture {
                                                let controller = TimelineViewController(timelineItem: item, createEditEnum:CreateEditEnum.edit);
                                                controller.timelineItem = item;
                                                Utility.navigateToViewController(controller: controller)
                                                print("编辑按钮被点击")
                                            }
                                    }.frame(height: 30)
                                }
                                VStack {
                                    HStack{
                                        Text("app".localizable())
                                            .font(.headline)
                                            .padding(.bottom, 10)
                                        Spacer()
                                        
                                    }
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 5) {
                                            ForEach(item.applicationTokens ?? [], id: \.self) { applicationTokenTmp in
                                                VStack {
                                                    Label(applicationTokenTmp)
                                                    Text("10mins")
                                                        .font(.footnote)
                                                        .foregroundColor(.gray)
                                                }
                                                
                                            }
                                        }
                                    }
                                }
                                .padding(EdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12))
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 1)
                                VStack {
                                    HStack{
                                        Text("分类")
                                            .font(.headline)
                                            .padding(.bottom, 10)
                                        Spacer()
                                        
                                        
                                    }
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 5) {
                                            ForEach(item.activityCategoryTokens ?? [], id: \.self) { categoryTokenTmp in
                                                VStack {
                                                    Label(categoryTokenTmp)
                                                    Text("10mins")
                                                        .font(.footnote)
                                                        .foregroundColor(.gray)
                                                }
                                                
                                            }
                                        }
                                    }
                                }
                                .padding(EdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12))
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 1)
                                
                            }
                        }
                        .padding(EdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12))
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 1)
                    }.padding(EdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12))
                }
            }
            GeometryReader { geometry in
                Button(action: {
                    Utility.navigateToViewController(controller: TimelineViewController(timelineItem: nil, createEditEnum:CreateEditEnum.create))
                    print("Button tapped")
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color.white)
                        .frame(width: 56, height: 56)
                        .background(Color.orange)
                        .cornerRadius(28)
                }.preferredColorScheme(.light) // 强制该视图使用浅色模式
                .padding()
                .position(x: geometry.size.width - 60, y: geometry.size.height - 30)
            }
        }.onAppear {
            // 在这里刷新数据
            settings.datasTimelineItem = SharepreferenceManager.shareInstance().getTimelineItems(forKey: SharePreferenceKey.TimelineKey) ?? []
            
        }
    }
}
