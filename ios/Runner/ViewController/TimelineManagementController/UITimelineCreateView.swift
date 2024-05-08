//
//  SwiftUIView.swift
//  Runner
//
//  Created by 林智彬 on 2023/8/21.
//

import SwiftUI
import FamilyControls
import ManagedSettings
import ManagedSettingsUI


//用于创建
@available(iOS 16.0, *)
struct UITimelineCreateView: View {
    //    @ObservedObject var settings = UserSettings()
    @Binding var createEditEnum:CreateEditEnum
    @ObservedObject var timelineItem:TimelineItem
    @State var selection = FamilyActivitySelection()
    @State var applicationTokens = Array<ApplicationToken>()
    @State var categoriesToken = Array<ActivityCategoryToken>()
    //    @ObservedObject var screenTimeSelectAppsModel: ScreenTimeSelectAppsModel
//    @ObservedObject var model: MyModel
    @State private var pickerIsPresented = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    //    @State private var startTime = Date()
    //    @State private var endTime = Date()
    //    @State private var selectedDays = Array(repeating: false, count: 7)
    @State var isPresented = false
    @State var isVisibleError = false
    //    @State var value = ScreenTimeVM.shared.value
    //    @State var value2 = ScreenTimeVM.shared.value2
    
    // MARK: 存储要限制的应用信息的变量
    @AppStorage("value")
    var value:Int = 1;
    
    // MARK: 存储要限制的应用信息的变量
    @AppStorage("value")
    var value2:Int = 2;
    
    var body: some View {
        VStack {
            // 第一个组件
            VStack(alignment: .leading) {
                Text("time".localizable())
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.white)
                    .frame(height: 100)
                    .overlay(
                        VStack {
                            TimeSelectionView(title: "from".localizable(), selectedTime: Binding(
                                get: { Utility.dateFromComponents(self.timelineItem.startTime) },
                                set: { newValue in
                                    let (startHour, startMinute) = Utility.getHourAndMinute(from: newValue)
                                    self.timelineItem.startTime = DateComponents(hour: startHour, minute: startMinute)
                                }
                            ))
                            TimeSelectionView(title: "to".localizable(), selectedTime: Binding(
                                get: { Utility.dateFromComponents(self.timelineItem.endTime) },
                                set: { newValue in
                                    let (endHour, endMinute) = Utility.getHourAndMinute(from: newValue)
                                    self.timelineItem.endTime = DateComponents(hour: endHour, minute: endMinute)
                                }
                            ))
                        }
                    )
            }
            
            // 第二个组件
            VStack(alignment: .leading) {
                HStack() {
                    Text("repeat".localizable())
                    Spacer()
                }
                HStack {
                    Spacer()
                    ForEach(0..<7) { index in
                        DaySelectionView(day: ["Sun".localizable(), "Mon".localizable(), "Tue".localizable(), "Wed".localizable(), "Thu".localizable(), "Fri".localizable(), "Sat".localizable()][index], isSelected: $timelineItem.weekend[index])
                    }
                    Spacer()
                }
            }
            
            // 第三个组件
            VStack(alignment: .leading) {
                HStack() {
                    Text("disableApp".localizable())
                    Spacer()
                    Button("selectApp".localizable()) {
                        isPresented = true
                    }
                    .familyActivityPicker(isPresented: $isPresented, selection: Binding(
                        get: {
                            var item = FamilyActivitySelection()
                            item.applicationTokens = Set(self.timelineItem.applicationTokens)
                            item.categoryTokens = Set(self.timelineItem.activityCategoryTokens)
                            item.webDomainTokens = Set(self.timelineItem.webDomainTokens)
                            return item
                        },
                        set: { newValue in
                            self.timelineItem.applicationTokens = Array(newValue.applicationTokens)
                            self.timelineItem.activityCategoryTokens = Array(newValue.categoryTokens)
                            self.timelineItem.webDomainTokens = Array(newValue.webDomainTokens)
                        }
                    ))
                }
                
            }
            
            VStack {
                VStack {
                    HStack{
                        Text("app".localizable())
                            .font(.headline)
                            .padding(.bottom, 10)
                        Spacer()
                        
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 5) {
                            ForEach(timelineItem.applicationTokens ?? Array([]), id: \.self) { applicationTokenTmp in
                                VStack {
                                    Label(applicationTokenTmp)
//                                    Text("10mins")
//                                        .font(.footnote)
//                                        .foregroundColor(.gray)
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
                        Text("category".localizable())
                            .font(.headline)
                            .padding(.bottom, 10)
                        Spacer()
                        
                        
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 5) {
                            ForEach(timelineItem.activityCategoryTokens ?? Array([]), id: \.self) { categoryTokenTmp in
                                VStack {
                                    Label(categoryTokenTmp)
//                                    Text("10mins")
//                                        .font(.footnote)
//                                        .foregroundColor(.gray)
                                }
                                
                            }
                        }
                    }
                }
                .padding(EdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12))
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 1)
                Spacer(minLength: 10)
                if isVisibleError == true {
                    Text("该时间段已经创建")
                    .font(.system(size: 12))
                    .foregroundColor(isVisibleError ? .red : .clear)
                }
                Spacer()
            }
            
        }.padding(.leading, 10)
            .padding(.trailing, 10)
        if self.createEditEnum == CreateEditEnum.create {
            Button(action: {
                self.timelineItem.id = "\(timelineItem.startTime.hour):\(timelineItem.startTime.minute)-\(timelineItem.endTime.hour):\(timelineItem.endTime.minute)";
                if(SharepreferenceManager.shareInstance().timelineItemIdExists(id:self.timelineItem.id,forKey:SharePreferenceKey.TimelineKey) == false) {
                    // 完成按钮点击事件
                    SharepreferenceManager.shareInstance().addTimelineItem(TimelineItem: timelineItem, forKey: SharePreferenceKey.TimelineKey)
                    DispatchQueue.global().async {
                        MyModel.shared.startMonitoring(activityName: timelineItem.id ?? "", intervalStart: timelineItem.startTime, intervalEnd: timelineItem.endTime, applicationTokens: Set(timelineItem.applicationTokens ?? []), categoryTokens: Set(timelineItem.activityCategoryTokens ?? []), webDomainTokens: Set(timelineItem.webDomainTokens ?? []));
                    }
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    self.isVisibleError = true
                    // Show a toast message
//                    let toast = Text("ID already exists")
//                    toast.toast(isPresenting: true, duration: 2, tapToDismiss: true, alert: { }, completion: { })
                    
                }
            }) {
                
                Text("create".localizable())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                
            }
        }
        // 底部按钮
        if self.createEditEnum == CreateEditEnum.edit {
            HStack {
                Button(action: {
                    // 删除按钮点击事件
                    //                self.value = 4;
                    //                    print("value1:\(self.value) value2:\(self.value2)")
                    //                MyModel.shared.stopMonitoring(activityName: timelineItem.id!);
                    SharepreferenceManager.shareInstance().removeTimelineItem(id: timelineItem.id, forKey: SharePreferenceKey.TimelineKey)
                    let list = SharepreferenceManager.shareInstance().getTimelineItems(forKey: SharePreferenceKey.TimelineKey)
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("delete".localizable())
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                }
                Button(action: {
                    //                    self.value = self.value + 2;
                    SharepreferenceManager.shareInstance().updateTimelineItem(id: timelineItem.id, newTimelineItem: timelineItem, forKey: SharePreferenceKey.TimelineKey)

                    MyModel.shared.stopMonitoring(activityName: timelineItem.id);
                    MyModel.shared.startMonitoring(activityName: timelineItem.id ?? "", intervalStart: timelineItem.startTime, intervalEnd: timelineItem.endTime, applicationTokens: Set(timelineItem.applicationTokens ?? []), categoryTokens: Set(timelineItem.activityCategoryTokens ?? []), webDomainTokens: Set(timelineItem.webDomainTokens ?? []));
                    //
                    //                // 完成按钮点击事件
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("update".localizable())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
        }
    }
}

//@available(iOS 15.0, *)
//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        SwiftUIView()
//    }
//}

@available(iOS 14.0, *)
struct TimeSelectionView: View {
    var title: String
    @Binding var selectedTime: Date
    
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            //                .foregroundColor(Color(hex: 0x404040))
            DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .datePickerStyle(CompactDatePickerStyle())
            //            Button(action: {
            //                // 时间选择器弹出事件
            //
            //            }) {
            //
            //                Text(timeFormatter.string(from: selectedTime))
            //                    .padding()
            //                    .background(Color.gray.opacity(0.2))
            //                    .cornerRadius(2)
            //            }
        }
    }
    
    //    var timeFormatter: DateFormatter {
    //        let formatter = DateFormatter()
    //        formatter.dateFormat = "HH:mm"
    //        return formatter
    //    }
}

struct DaySelectionView: View {
    var day: String
    @Binding var isSelected: Bool
    
    var body: some View {
        Button(action: {
            isSelected.toggle()
        }) {
            Text(day)
                .font(.system(size: 11))
                .foregroundColor(isSelected ? .white : .black)
                .frame(width: 36, height: 36)
                .background(isSelected ? Color.blue : Color.white)
                .clipShape(Circle())
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
