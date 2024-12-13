//
//  NewCountdownWidget.swift
//  NewCountdownWidget
//
//  Created by 林智彬 on 2024/11/23.
//

import WidgetKit
import SwiftUI

//struct EndTimeMissionData : Codable, Hashable {
//    var title: String?
//    var listMissionModel: [EndTimeMissionModel]
//}
//
//struct EndTimeMissionModel: Codable, Hashable {
//    let objectId: String?
//    let title: String?
//    let lunar: String?
//    var end_time: Int?
//    var remainTime: Int?
//    let background_url: String?
//    let color: Int
//    var isFinished, isDelayed: Bool?
//    let priorityStatus: Int?
//
//
//    init(
//        objectId: String?,
//        title: String?,
//        lunar: String?,
//        background_url: String?,
//        remainTime: Int?,
//        end_time: Int?,
//        priorityStatus: Int?,
//        isFinished: Bool?,
//        isDelayed: Bool?,
//        color: Int?
//    ) {
//        self.remainTime = remainTime
//        self.objectId = objectId
//        self.lunar = lunar
//        self.title = title
//        self.background_url = background_url
//        self.end_time = end_time
//        self.priorityStatus = priorityStatus
//        self.isFinished = isFinished
//        self.isDelayed = isDelayed
//        self.color = color ?? 0xffff8800
//    }
//
//    func clone(
//           objectId: String? = nil,
//           title: String? = nil,
//           lunar: String? = nil,
//           background_url: String? = nil,
//           remainTime: Int? = nil,
//           end_time: Int? = nil,
//           priorityStatus: Int? = nil,
//           isFinished: Bool? = nil,
//           isDelayed: Bool? = nil,
//           color: Int? = nil
//       ) -> EndTimeMissionModel {
//           return EndTimeMissionModel(
//               objectId: objectId ?? self.objectId,
//               title: title ?? self.title,
//               lunar: lunar ?? self.lunar,
//               background_url: background_url ?? self.background_url,
//               remainTime: remainTime ?? self.remainTime,
//               end_time: end_time ?? self.end_time,
//               priorityStatus: priorityStatus ?? self.priorityStatus,
//               isFinished: isFinished ?? self.isFinished,
//               isDelayed: isDelayed ?? self.isDelayed,
//               color: color ?? self.color
//           )
//       }
//}

func cloneList(datas: [EndTimeMissionModel]) -> [EndTimeMissionModel]{
    var list: [EndTimeMissionModel] = []
    for index in 0..<datas.count {
        list.append(datas[index].clone())
    }
    return list
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀", missionModels: [
            EndTimeMissionModel(
                objectId: "1",
                title: "Project Alpha",
                lunar: "2024-11-01",
                background_url: "https://example.com/bg1.png",
                end_time: Int(Date().addingTimeInterval(5 * 86400).timeIntervalSince1970 * 1000),
                priorityStatus: 1,
                isFinished: false,
                isDelayed: false,
                color: 0xff123456, remainTime: 0
            ),
//            EndTimeMissionModel(
//                objectId: "2",
//                title: "Beta Milestone",
//                lunar: "2024-11-05",
//                background_url: "https://example.com/bg2.png", remainTime: 0,
//                end_time: Int(Date().addingTimeInterval(10 * 86400).timeIntervalSince1970 * 1000),
//                priorityStatus: 2,
//                isFinished: false,
//                isDelayed: false,
//                color: 0xff654321
//            ),
//            EndTimeMissionModel(
//                objectId: "3",
//                title: "Gamma Release",
//                lunar: "2024-11-10",
//                background_url: "https://example.com/bg3.png", remainTime: 0,
//                end_time: Int(Date().addingTimeInterval(15 * 86400).timeIntervalSince1970 * 1000),
//                priorityStatus: 3,
//                isFinished: false,
//                isDelayed: true,
//                color: 0xffabcdef
//            )
        ], remainTime: 100)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀", missionModels: [
            EndTimeMissionModel(
                objectId: "1",
                title: "Project Alpha",
                lunar: "2024-11-01",
                background_url: "https://example.com/bg1.png",
                end_time: Int(Date().addingTimeInterval(5 * 86400 + 1).timeIntervalSince1970 * 1000) ,
                priorityStatus: 1,
                isFinished: false,
                isDelayed: false,
                color: 0xff123456, remainTime: 0
            ),
            EndTimeMissionModel(
                objectId: "2",
                title: "Beta Milestone",
                lunar: "2024-11-05",
                background_url: "https://example.com/bg2.png",
                end_time: Int(Date().addingTimeInterval(10 * 86400).timeIntervalSince1970 * 1000),
                priorityStatus: 2,
                isFinished: false,
                isDelayed: false,
                color: 0xff654321, remainTime: 0
            ),
            EndTimeMissionModel(
                objectId: "3",
                title: "Gamma Release",
                lunar: "2024-11-10",
                background_url: "https://example.com/bg3.png",
                end_time: Int(Date().addingTimeInterval(15 * 86400).timeIntervalSince1970 * 1000),
                priorityStatus: 3,
                isFinished: false,
                isDelayed: true,
                color: 0xffabcdef, remainTime: 00
            ),
            EndTimeMissionModel(
                objectId: "1",
                title: "Project Alpha",
                lunar: "2024-11-01",
                background_url: "https://example.com/bg1.png",
                end_time: Int(Date().addingTimeInterval(5 * 86400 + 1).timeIntervalSince1970 * 1000) ,
                priorityStatus: 1,
                isFinished: false,
                isDelayed: false,
                color: 0xff123456, remainTime: 0
            ),
            EndTimeMissionModel(
                objectId: "2",
                title: "Beta Milestone",
                lunar: "2024-11-05",
                background_url: "https://example.com/bg2.png",
                end_time: Int(Date().addingTimeInterval(10 * 86400).timeIntervalSince1970 * 1000),
                priorityStatus: 2,
                isFinished: false,
                isDelayed: false,
                color: 0xff654321, remainTime: 0
            ),
            EndTimeMissionModel(
                objectId: "3",
                title: "Gamma Release",
                lunar: "2024-11-10",
                background_url: "https://example.com/bg3.png",
                end_time: Int(Date().addingTimeInterval(15 * 86400).timeIntervalSince1970 * 1000),
                priorityStatus: 3,
                isFinished: false,
                isDelayed: true,
                color: 0xffabcdef, remainTime: 00
            )
        ], remainTime: 100)
        completion(entry)
    }
    
    func getMissionModelList(list: inout [SimpleEntry], date: Date) -> [EndTimeMissionModel]? {
        for i in 0..<list.count {
            if list[i].date == date {
                return list[i].missionModels
            }
        }
        return nil
//        return list
    }

    func replaceEntries(list: inout [SimpleEntry], entry: SimpleEntry) -> [SimpleEntry] {
        for i in 0..<list.count {
            // 找到匹配的 SimpleEntry
            if entry.date == list[i].date {
                // 用 entry 替换现有 SimpleEntry
                list[i] = entry
                
                // 替换对应的 missionModels
                list[i].missionModels = replaceMissionModels(
                    list1: &list[i].missionModels,
                    list2: entry.missionModels
                )
                return list
            }
        }
        
        // 如果没有匹配项，直接添加新的 entry
        list.append(entry)
        return list
    }
    func replaceMissionModels(list1: inout [EndTimeMissionModel], list2: [EndTimeMissionModel]) -> [EndTimeMissionModel] {
        // 遍历 list2，查找并替换 list1 中相同 objectId 的元素
        for model2 in list2 {
            if let index = list1.firstIndex(where: { $0.objectId == model2.objectId }) {
                list1[index] = model2 // 替换相同 objectId 的元素
            } else {
                list1.append(model2) // 如果没有匹配，添加到 list1 中
            }
        }
        return list1
    }
    
    @AppStorage("EndTimeMissionStoreData", store: UserDefaults(suiteName: Params.groupName)) var primaryData : Data = Data()

    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let calendar = Calendar.current

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        guard var endTimeMissionData = try?
                JSONDecoder().decode(EndTimeMissionData.self, from: primaryData) else {
            return
        }
        
        
//        Date().addingTimeInterval(Double((30 - index) * 86400)).timeIntervalSince1970 * 1000
        var datas:[EndTimeMissionModel] = endTimeMissionData.listMissionModel;
        var listMap:[Date:[EndTimeMissionModel]] = [:]
        var listDates:[Date] = []
        
        let currentTime = Date()
        
        for index in 0..<datas.count {
            var datasTmp1 = getMissionModelList(list: &entries, date: currentDate) ?? cloneList(datas: datas)
            var model: EndTimeMissionModel = datasTmp1[index].clone()
            var remainTime:Int = Int((Int(model.end_time ?? Int(currentTime.timeIntervalSince1970 * 1000)) - Int(currentTime.timeIntervalSince1970 * 1000)) / 1000)
            var days: Int = (remainTime / 86400 <= 0) ? 0 :(remainTime / 86400)
            print("days:\(days)")
//            model.remainTime = remainTime
//            datasTmp1[index] = model
//            var entryDate =  SimpleEntry(
//                date: currentTime,
//                emoji: "😀", missionModels: datasTmp1, remainTime: remainTime
//            )
            if !listDates.contains(currentDate) {
                listDates.append(currentDate)
            }
//            model.remainTime = remainTime ?? 0
//            replaceEntries(list: &entries, entry: entryDate)
            
            for day in 0 ..< days {
                var dateTmp:Date = calendar.date(byAdding: .day, value: day, to: currentTime ?? Date()) ?? Date()
                var dateTmp2:Date = calendar.date(byAdding: .second, value: remainTime % 86400 + 1, to: dateTmp) ?? Date()
//                print("\(dateTmp)-\(dateTmp2)-\(remainTime)")
//                var datasTmp2 = getMissionModelList(list: &entries, date: dateTmp2) ?? cloneList(datas: datas)
//                model = datasTmp2[index].clone()
//                model.remainTime = (days - day) * 86400 - 1 ?? 0
//                datas[index] = model
//                datasTmp2[index] = model
                print("days1:\(remainTime % 86400)")

                if !listDates.contains(dateTmp2) {
                    listDates.append(dateTmp2)
                }
                
//                var entryDate =  SimpleEntry(
//                    date: dateTmp2,
//                    emoji: "😀", missionModels: datasTmp2, remainTime: (days - day) * 86400 - 1
//                )
//                replaceEntries(list: &entries, entry: entryDate)
            }
            
            var dateTmp3:Date = calendar.date(byAdding: .second, value: remainTime, to: currentTime) ?? Date()
            var datasTmp3 = getMissionModelList(list: &entries, date: dateTmp3) ?? cloneList(datas: datas)
            
//            model.remainTime = 0
//            datasTmp3[index] = model
            
            if !listDates.contains(dateTmp3) && dateTmp3.timeIntervalSince1970 >= currentDate.timeIntervalSince1970 {
                listDates.append(dateTmp3)
            }

//            entryDate =  SimpleEntry(
//                date: dateTmp3,
//                emoji: "😀", missionModels: datasTmp3, remainTime: 0
//            )
//            replaceEntries(list: &entries, entry: entryDate)
        }
        for index in 0..<listDates.count {
            var date: Date = listDates[index]
            var listModels: [EndTimeMissionModel] = cloneList(datas: datas)
            
            for j in 0..<listModels.count {
                var remainTime = (listModels[j].end_time ?? 0) - Int(date.timeIntervalSince1970 * 1000)
                remainTime = remainTime < 0 ? 0 : (remainTime / 1000)
                
                listModels[j].remainTime = remainTime
                print("days4:\(getDays(missionModel:listModels[j]))")

            }
            var entryDate:SimpleEntry =  SimpleEntry(
                date: date,
                emoji: "😀", missionModels: listModels, remainTime: 0
            )
            entries.append(entryDate)
            
            var offsetTime = 1;
            date = listDates[index]
            listModels = cloneList(datas: datas)
            
            for j in 0..<listModels.count {
                var remainTime = (listModels[j].end_time ?? 0) - Int(date.timeIntervalSince1970 * 1000)
                remainTime = (remainTime < 0 ? 0 : (remainTime / 1000 - offsetTime))
//                print("days4:\(remainTime % 86400)")
                listModels[j].remainTime = remainTime
//                getDays(missionModel: listModels[j])
                print("days4:\(getDays(missionModel:listModels[j]))")
            }
             entryDate =  SimpleEntry(
                date: calendar.date(byAdding: .second, value: offsetTime, to: date) ?? Date(),
                emoji: "😀", missionModels: listModels, remainTime: 0
            )
            
            offsetTime = 1;
            date = listDates[index]
            listModels = cloneList(datas: datas)
            
            for j in 0..<listModels.count {
                var remainTime = (listModels[j].end_time ?? 0) - Int(date.timeIntervalSince1970 * 1000)
                remainTime = (remainTime < 0 ? 0 : (remainTime / 1000 - offsetTime))
//                print("days4:\(remainTime % 86400)")
                listModels[j].remainTime = remainTime
//                getDays(missionModel: listModels[j])
                print("days4:\(getDays(missionModel:listModels[j]))")
            }
             entryDate =  SimpleEntry(
                date: calendar.date(byAdding: .second, value: offsetTime, to: date) ?? Date(),
                emoji: "😀", missionModels: listModels, remainTime: 0
            )
            
            offsetTime = 10;
            date = listDates[index]
            listModels = cloneList(datas: datas)
            
            for j in 0..<listModels.count {
                var remainTime = (listModels[j].end_time ?? 0) - Int(date.timeIntervalSince1970 * 1000)
                remainTime = (remainTime < 0 ? 0 : (remainTime / 1000 - offsetTime))
//                print("days4:\(remainTime % 86400)")
                listModels[j].remainTime = remainTime
//                getDays(missionModel: listModels[j])
                print("days4:\(getDays(missionModel:listModels[j]))")
            }
             entryDate =  SimpleEntry(
                date: calendar.date(byAdding: .second, value: offsetTime, to: date) ?? Date(),
                emoji: "😀", missionModels: listModels, remainTime: 0
            )
            
            entries.append(entryDate)
            
        }
        
//        for index in 0 ..< datas.count {
//            let model: EndTimeMissionModel = datas[index];
////            var endTime: Int = model.end_time ?? 0
//            var entryDate = Calendar.current.date(byAdding: .second, value: (model.end_time ?? 0) % 86400, to: currentDate)!
//
////            let currentTime = Date().timeIntervalSince1970 * 1000
//
////            var currentTimeTmp = currentTime
//            remainTime = Int((Int(datas[0].end_time ?? Int(currentTime)) - Int(Date().timeIntervalSince1970 * 1000)) / 1000)
//
//            print("remainTime-\(remainTime)")
//            var entry = SimpleEntry(date: entryDate, emoji: "😀", missionModels: datas, remainTime: remainTime)
//            entries.append(entry)
////            datas[index].end_time = (model.end_time ?? 0) - (10 * 1000);
////            datas[index] = model
////            entryDate = Calendar.current.date(byAdding: .second, value: (endTime) % 86400 + 2, to: currentDate)!
////            entry = SimpleEntry(date: entryDate, emoji: "😀", missionModels: datas, remainTime: 100)
////            entries.append(entry)
//        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
    var missionModels: [EndTimeMissionModel]
    let remainTime: Int
}

struct NewCountdownWidgetEntryView : View {
    var entry: Provider.Entry

    @Environment(\.widgetFamily) var family
    @State var largeFontSize: CGFloat = 20

    var body: some View {
        VStack {
            if family == .systemExtraLarge {
                // 两列五行布局
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(0..<min(entry.missionModels.count, 10)) { index in
                        HStack {
                            Text("\("event".localizable()) \(index + 1)")
                                .font(.system(size: largeFontSize, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 100, alignment: .leading)
                            Spacer()
                            CountdownView(entry: entry,
                                          endTime: Double(entry.missionModels[index].end_time ?? 0),
                                          fontSize: largeFontSize,
                                          missionModel: entry.missionModels[index],
                                          completed: (entry.missionModels[index].remainTime ?? 0) <= 0)
                                .frame(height: 50)
                        }
                        .padding(.vertical, 5)
                    }
                }
                .padding()
                .cornerRadius(15)
                Spacer()
            } else if family == .systemLarge {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(0..<entry.missionModels.prefix(5).count) { index in
                        HStack {
                            Text("Event \(index + 1)")
                                .font(.system(size: largeFontSize, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 100, alignment: .leading)
                            Spacer()
                            CountdownView(entry: entry,endTime: Double(entry.missionModels[index].end_time ?? 0), fontSize: largeFontSize, missionModel: entry.missionModels[index], completed: (entry.missionModels[index].remainTime ?? 0) <= 0)
                                .frame(height: 50)
                        }
                        .padding(.vertical, 5)
                    }
                }
                .padding()
                .cornerRadius(15)
                Spacer()
            } else {
                CountdownView(entry: entry,endTime: Date().addingTimeInterval(30 * 86400).timeIntervalSince1970 * 1000, fontSize: 22, missionModel: entry.missionModels[0], completed: entry.missionModels[0].remainTime == 0)
            }
        }.frame(height: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [.purple, .blue]),
                                       startPoint: .leading,
                                       endPoint: .trailing))
    }
}

func getDays(missionModel: EndTimeMissionModel) -> Int {
    print("remainTime:\(missionModel.remainTime ?? 0)")
    print("remainDays:\((missionModel.remainTime ?? 0) / 86400)")
    return ((missionModel.remainTime ?? 0) / 86400)
}


struct CountdownView: View {
    var entry: Provider.Entry
//    @State var remainTime: Int = 0 // Remaining time in seconds
//    @State var currentTimeTmp: Double = 0 // Remaining time in seconds
    var completed: Bool = false // Completion flag
    let endTime: Double // End time in milliseconds timestamp
    let fontSize: CGFloat // Font size parameter
    let missionModel: EndTimeMissionModel // Font size parameter
    
    init(entry: Provider.Entry,endTime: Double, fontSize: CGFloat, missionModel: EndTimeMissionModel, completed: Bool) {
        self.endTime = endTime
        self.fontSize = fontSize
        self.missionModel = missionModel
        self.entry = entry
        self.completed = completed
    }
    

    var body: some View {
        VStack(alignment: .leading){
            if completed {
                HStack() {
                    Text("completed".localizable())
                        .font(.system(size: fontSize, weight: .bold))
                    .foregroundColor(.green)
                    Spacer()
                }
                HStack() {
                Text("\(self.missionModel.title ?? "Unknown")")
                    .font(.system(size: fontSize, weight: .bold))
                    .foregroundColor(.yellow)
                    Spacer()
                }
            } else {
                HStack(alignment: .bottom) {
//                    Text("\(entry.date)")
                    Text("\(getDays(missionModel: missionModel))")
                        .font(.system(size: fontSize, weight: .bold))
                        .foregroundColor(.white)
                    Text("days".localizable())
                        .font(.system(size: fontSize, weight: .bold))
                        .foregroundColor(.white)
                    Text(timerInterval: Date()...((missionModel.remainTime ?? 0) <= 0 ? Date() :Date().addingTimeInterval(TimeInterval((missionModel.remainTime ?? 0) % 86400))), countsDown: true)
                        .font(.system(size: fontSize - 6, weight: .bold))
                        .foregroundColor(.white)
                }
                .onReceive(timer) { _ in
                }
                .onAppear {
                }
                Text("\(self.missionModel.title ?? "Unknown")")
                    .font(.system(size: fontSize, weight: .bold))
                    .foregroundColor(.yellow)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 200)
//        .background(LinearGradient(gradient: Gradient(colors: [.purple, .blue]),
//                                   startPoint: .leading,
//                                   endPoint: .trailing))
        .cornerRadius(15)
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func currentHourMinuteSecond() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: Date())
    }
}

struct NewCountdownWidget: Widget {
    let kind: String = "NewCountdownWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(macOS 14.0, *) {
                NewCountdownWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                NewCountdownWidgetEntryView(entry: entry)
                    .padding()
            }
        }
        .configurationDisplayName("countdown_widget_name".localizable())
        .description("countdown_widget_description".localizable())
        .contentMarginsDisabled()
        .supportedFamilies([.systemMedium, .systemLarge, .systemExtraLarge])
    }
}

//#Preview(as: .systemSmall) {
//    NewCountdownWidget()
//} timeline: {
//    SimpleEntry(date: .now, emoji: "😀")
//    SimpleEntry(date: .now, emoji: "🤩")
//}
