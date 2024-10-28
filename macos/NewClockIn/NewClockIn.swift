//
//  NewClockIn2.swift
//  NewClockIn2
//
//  Created by 林智彬 on 2024/10/16.
//

import WidgetKit
import SwiftUI
import AppIntents

struct Provider: TimelineProvider {
    @AppStorage("FlomoMissionModel", store: UserDefaults(suiteName: "\(Params.isMACOS == true ? "":"group.")S4CLCWPCGH.com.timespeed.timehello")) var primaryData : Data = Data()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), listMissionModel: [])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), listMissionModel: [])
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        var flomoMissionData:FlomoMissionData?;
        do {
            flomoMissionData = try JSONDecoder().decode(FlomoMissionData.self, from: primaryData)
        } catch {
            print("Could not write to file")
        }
        let list = flomoMissionData?.listFlomoMissionModelList ?? [];
        
        for index in 0...list.count - 1 {
            let flomoMissionModelList:FlomoMissionModelList = list[index]
            let time = flomoMissionModelList.time;
            let entryDate = Date(timeIntervalSince1970: TimeInterval(time) / 1000)
            let calendar = Calendar.current
            let entry: SimpleEntry
            if calendar.isDateInToday(entryDate) {
                let date = Calendar.current.date(byAdding: .minute, value: 1, to: Date())
                entry = SimpleEntry(date: Date(), listMissionModel: flomoMissionModelList.listMissionModel)
                print("entryDate is in today")
            } else {
                entry = SimpleEntry(date: entryDate, listMissionModel: flomoMissionModelList.listMissionModel)
                print("entryDate is not in today")
            }
            entries.append(entry)
        }
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
        //
        //
        
        //
        //        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        //        let currentDate = Date()
        //        for hourOffset in 0 ..< 5 {
        //            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
        //            let entry = SimpleEntry(date: entryDate)
        //            entries.append(entry)
        //        }
        
        //        let timeline = Timeline(entries: entries, policy: .atEnd)
        //        completion(timeline)
    }
}

struct TimerIntent2: AppIntent {
    @AppStorage("FlomoMissionModel", store: UserDefaults(suiteName: "\(Params.isMACOS == true ? "":"group.")S4CLCWPCGH.com.timespeed.timehello")) var primaryData : Data = Data()

    init() {
        
    }
    
    static var title: LocalizedStringResource = "Toggle Mission State"
    
    static func formatTimestampToDateString(timestamp: Int) -> String {
        // 将 timestamp 从毫秒转换为秒
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp) / 1000)
        
        // 设置日期格式
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // 将日期对象格式化为字符串
        return dateFormatter.string(from: date)
    }
    
    @Parameter(title: "Mission ID")
    var missionID: String?
    init(missionID: String) {
        self.missionID = missionID
    }
    
    /**得到当前毫秒时间戳**/
    static  func getCurrentTimeStampByMilliSeconds() -> CLongLong{
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return millisecond;
    }
    
    func perform() async throws -> some IntentResult {
//        NotificationCenter.default.post(name: NSNotification.Name( Params.ACTION_HANDLE_NOTIFICATION_POSTMESSAGE) , object: self, userInfo: ["action": "handleUpdateFlomoMissionModelList"]);
        Task {
            NetworkRequest.shared.console(pairParameters: ["id": self.missionID ?? ""])
            let objectId = self.missionID ?? "";
            let timestamp = TimerIntent2.getCurrentTimeStampByMilliSeconds();
            if let responseData:[String: Any]? = await NetworkRequest.shared.startRequestWithPost(pairParameters: ["objectId":objectId, "timestamp": timestamp], url: Apis.updateFlomoClickInsMissionModel) {
                do {
                    if responseData != nil && (responseData!["success"] as! Bool){
                        let percent: Double = (responseData?["data"] ?? 0) as! Double;
                        var flomoMissionData:FlomoMissionData?;
                        do {
                            flomoMissionData = try JSONDecoder().decode(FlomoMissionData.self, from: primaryData)
                        } catch {
                            print("Could not write to file")
                        }
                        //                                flomoMissionData.
                        let dateString: String = TimerIntent2.formatTimestampToDateString(timestamp: Int(timestamp));
                        var missionModel: MissionModel?;
                        var list:[FlomoMissionModelList] = flomoMissionData?.listFlomoMissionModelList ?? [];
                        for i in 0..<list.count {
                            //                                    print("Index \(i): \(list[i])")
                            var model: FlomoMissionModelList = list[i];
                            let dateString2: String = TimerIntent2.formatTimestampToDateString(timestamp: Int(model.time));
                            
                            for j in 0..<model.listMissionModel.count {
                                var flomoMissionModel: FlomoMissionModel = model.listMissionModel[j];
                                if(flomoMissionModel.objectId == objectId && dateString2 == dateString) {
                                    flomoMissionModel.percent = percent;
                                    model.listMissionModel[j] = flomoMissionModel;
                                    break;
                                }
                                print("\(flomoMissionModel)");
                            }
                            list[i] = model;
                        }
                        flomoMissionData?.listFlomoMissionModelList  = list;
                        guard let data = try? JSONEncoder().encode(flomoMissionData) else {
                            return
                        }
   
                        let missionData = try?
                        JSONDecoder().decode(FlomoMissionData.self, from: data)
                        primaryData = data //类似存储在 shareprefrerence
                        WidgetCenter.shared.reloadAllTimelines()
                        print("请求成功")
                    } else {
                        print("请求失败")
                    }
                    //                            // 将 responseData 转换为 JSON 数据
                    //                            let jsonData = try JSONSerialization.data(withJSONObject: responseData, options: .prettyPrinted)
                    //
                    //                            // 使用 JSONDecoder 将数据解析为 BaseResponse 类型
                    //                            let decoder = JSONDecoder()
                    //                            decoder.keyDecodingStrategy = .convertFromSnakeCase // 自动将下划线命名转换为驼峰命名
                    //                            let baseResponse = try decoder.decode(BaseResponse.self, from: jsonData)
                    //
                    //                            // 打印解析结果
                    //                            if baseResponse.success {
                    //                                print("请求成功，数据为: \(baseResponse)")
                    ////                                return baseResponse;
                    //                            } else {
                    //                                print("请求失败，错误信息: \(baseResponse.message)")
                    //                                //                                return nil;
                    //                            }
                } catch {
                    print("JSON 解析失败: \(error)")
                    //                            return nil;
                }
            }
        }
        return .result()
    }
    
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    var listMissionModel: [FlomoMissionModel]
}


struct NewClockIn2EntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        VStack{
            HStack {
                Color.yellow.frame(width: 4, height: 10).padding(.trailing, 0)
                Text("clockInToday".localizable())
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))
                Spacer()
            }
            if family == .systemSmall {
                ItemView(listMissionModel: entry.listMissionModel)
            } else {
                GridView(listMissionModel: entry.listMissionModel)
            }
            
        }.padding(EdgeInsets(top: 6, leading: 4, bottom: 0, trailing: 0))
    }
}

struct NewClockIn2: Widget {
    let kind: String = "NewClockIn2"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(macOS 14.0, *) {
                NewClockIn2EntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                NewClockIn2EntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .contentMarginsDisabled()
        .configurationDisplayName("clockInToday".localizable())
        .description("2222222211111111111111")
    }
}


struct GridView: View {
    var listMissionModel: [FlomoMissionModel]
    let radius:Double = 15;
    var percent:Double = 0.3;
    var isChecked: Bool = true;
    @Environment(\.widgetFamily) var family
    
    init(listMissionModel: [FlomoMissionModel]) {
        self.listMissionModel = listMissionModel
    }
    
    var body: some View {
        HStack {
            VStack {
                ForEach(listMissionModel.prefix(getMaxItems()).indices.filter { $0 % 2 == 0 }, id: \.self) { index in
                    ItemRow(item: listMissionModel[index])
                }
                Spacer()
            }
            VStack {
                ForEach(listMissionModel.prefix(getMaxItems()).indices.filter { $0 % 2 != 0 }, id: \.self) { index in
                    ItemRow(item: listMissionModel[index])
                }
                Spacer()
            }
        }
    }
    
    func ItemRow(item: FlomoMissionModel) -> some View {
            ZStack {
                GeometryReader { geometry in
                    Rectangle()
                        .fill(Color(hex:(item.color ?? 0xff8800)))
                        .frame(width: geometry.size.width * CGFloat((item.percent ?? 0) < 1 ? (item.percent ?? 0) : 1))
                        .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
                    Button(intent: TimerIntent2(missionID: item.objectId ?? "")) {

                    Rectangle()
                        .fill(Color(hex:(item.color ?? 0xff8800)))
                        .frame(width: geometry.size.width)
                        .opacity(0.2)
                        .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
                    } .buttonStyle(PlainButtonStyle())
//                        .background(Color.clear)
                }
                HStack {
                    Text("\(item.title ?? "") \(item.percent)")
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))
                    Spacer()
                    Image((item.percent ?? 0) < 1 ? "ic_uncheck" : "ic_check")
                        .resizable().aspectRatio(contentMode: .fit).frame(width: 14, height: 14)
                }.padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing:4))
            }
            .frame(height: 25)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 4))

    }
    
    func getMaxItems() -> Int {
        switch family {
        case .systemSmall:
            return 4
        case .systemMedium:
            return 8
        case .systemLarge:
            return 18
        @unknown default:
            return 6
        }
    }
}

struct ItemView: View {
    
    var listMissionModel: [FlomoMissionModel]
    let radius:Double = 15;
    var percent:Double = 0.3;
    var isChecked: Bool = true;
    @Environment(\.widgetFamily) var family
    
    init(listMissionModel: [FlomoMissionModel]) {
        self.listMissionModel = listMissionModel
    }
    
    func getMaxItems() -> Int {
        switch family {
        case .systemSmall:
            return 4
        case .systemMedium:
            return 5
        case .systemLarge:
            return 13
        @unknown default:
            return 6
        }
    }
    
    var body: some View {
        VStack {
            ForEach(listMissionModel.prefix(getMaxItems()), id: \.self) {item in

                    ZStack {
                        GeometryReader { geometry in
                            Rectangle()
                                .fill(Color(hex:(item.color ?? 0xff8800)))
                                .frame(width: geometry.size.width * CGFloat((item.percent ?? 0) < 1 ? (item.percent ?? 0) : 1))
                                .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
                            Button(intent: TimerIntent2(missionID: item.objectId ?? "")) {
                            Rectangle()
                                .fill(Color(hex:(item.color ?? 0xff8800)))
                                .frame(width: geometry.size.width)
                                .opacity(0.2)
                                .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
                            } .buttonStyle(PlainButtonStyle())
//                                .background(Color.clear)
                        }
                        HStack {
                            Text("\(item.title ?? "") \(item.percent)")
                                .font(.system(size: 12))
                                .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))
                            Spacer()
                            Image((item.percent ?? 0) < 1 ? "ic_uncheck" : "ic_check")
                                .resizable().aspectRatio(contentMode: .fit).frame(width: 14, height: 14)
                            
                            
                        }.padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing:4))
                    }
                    .frame(height: 25)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 4))

            }
            if listMissionModel.count == 0 && listMissionModel.count > getMaxItems() {
                HStack {
                    Text("......")
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))
                }.padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing:4))
            }
            Spacer()
        }
    }
}
