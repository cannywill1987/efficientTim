//
//  MyCalendarWidget.swift
//  MyCalendarWidget
//
//  Created by 林智彬 on 2023/9/24.
//

import WidgetKit
import SwiftUI

func getArrayListThisWeek2(time: TimeInterval, list: [MissionModelList]) -> [MissionModelList] {
    // 根据time得到 time这周日 的 yymmdd 00:00:00的 startOfWeek
    //根据time得到今天星期几 返回整形
    let weekday = Calendar.current.component(.weekday, from: Date(timeIntervalSince1970: time))
    
    let date = Date(timeIntervalSince1970: time)
    
    // date 小时 分钟 秒 转成 00:00:00
    let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
    let normalizedDate:Date = Calendar.current.date(from: components) ?? Date()
    let startOfWeek = Calendar.current.date(byAdding: .day, value: -weekday + 1, to: normalizedDate)
    let calendar = Calendar.current
    // 根据time得到周六的 的 yymmdd 23:59:59的 endOfWeek
    let endOfWeekComponents = DateComponents(day: 7, hour: 0, minute: 0, second: 0)
    guard let endOfWeek = calendar.date(byAdding: endOfWeekComponents, to: startOfWeek ?? Date()) else {
        return []
    }
    print("\(startOfWeek)-\(endOfWeek)");
    print("~~~~~~~~~~~~~~~~~");
//    let resList = []

    // startWeek 到endWeek遍历list

    //
    let resList =  list.filter { missionModelList in
        let missionDate = Date(timeIntervalSince1970: TimeInterval(missionModelList.time / 1000))
        if missionDate >= startOfWeek ?? Date() && missionDate < endOfWeek {
            return true
        }
        else {
            return false
        }
    }
    // startOfWeek 到 endOfWeek遍历 打印 time
    var dayList:[MissionModelList] = []
    for day in stride(from: startOfWeek ?? Date(), to: endOfWeek, by: 86400) {
        print("\(day)")
           let dayTimestamp = day.timeIntervalSince1970 * 1000
        let res: MissionModelList? = getItemFromTime(time:dayTimestamp, list: resList)
           if res != nil {
                dayList.append(res!)
           } else {
               dayList.append(MissionModelList(time: Int(dayTimestamp), lunar: "", listMissionModel: []))
           }
           print("\(dayTimestamp)")
    }
    
    // for item in resList {
    //     let missionDate = Date(timeIntervalSince1970: TimeInterval(item.time / 1000))
    //     print("\(missionDate)");
    //     if missionDate >= startOfWeek ?? Date() && missionDate < endOfWeek {
    //         resList.append(item)
    //     }
    // }


    return dayList;
}

func getItemFromTime(time: TimeInterval, list:[MissionModelList]) -> MissionModelList? {
    for item in list {
        if Double(item.time) == time {
            return item
        }
    }
    return nil
}

struct Provider: TimelineProvider {
    @AppStorage("CalendarMissionModel", store: UserDefaults(suiteName: Params.groupName)) var primaryData : Data = Data()
    
    
    func placeholder(in context: Context) -> SimpleEntry {
        var myCalendarMissionStoreData:MyCalendarMissionData?;
        do {
            myCalendarMissionStoreData = try JSONDecoder().decode(MyCalendarMissionData.self, from: primaryData)
        } catch {
            print("Could not write to file")
        }
        var listMissionModel = myCalendarMissionStoreData?.listMissionModelList ?? [];
        var list = getArrayListThisWeek2(time: Date().timeIntervalSince1970, list: listMissionModel)
        let entry:SimpleEntry;
        if list.count > 6 {
            entry = SimpleEntry(date: Date(timeIntervalSince1970: TimeInterval(list[0].time) / 1000), firstDate: Date(),listMissionModelSun: list[0], listMissionModelMon: list[1], listMissionModelTue: list[2], listMissionModelWed: list[3], listMissionModelThu: list[4], listMissionModelFri: list[5], listMissionModelSat: list[6])
        } else {
            entry = SimpleEntry(date: Date(timeIntervalSince1970: TimeInterval(list[0].time) / 1000), firstDate: Date(),listMissionModelSun: MissionModelList(time: 0, lunar: "", listMissionModel: []), listMissionModelMon: MissionModelList(time: 0, lunar: "", listMissionModel: []), listMissionModelTue: MissionModelList(time: 0, lunar: "", listMissionModel: []), listMissionModelWed: MissionModelList(time: 0, lunar: "", listMissionModel: []), listMissionModelThu: MissionModelList(time: 0, lunar: "", listMissionModel: []), listMissionModelFri: MissionModelList(time: 0, lunar: "", listMissionModel: []), listMissionModelSat: MissionModelList(time: 0, lunar: "", listMissionModel: []))
        }
        return entry
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        var myCalendarMissionStoreData:MyCalendarMissionData?;
        do {
            myCalendarMissionStoreData = try JSONDecoder().decode(MyCalendarMissionData.self, from: primaryData)
        } catch {
            print("Could not write to file")
        }
        var listMissionModel = myCalendarMissionStoreData?.listMissionModelList ?? [];
        var list = getArrayListThisWeek2(time: Date().timeIntervalSince1970, list: listMissionModel)
        let entry = SimpleEntry(date: Date(timeIntervalSince1970: TimeInterval(list[0].time) / 1000), firstDate: Date(),listMissionModelSun: list[0], listMissionModelMon: list[1], listMissionModelTue: list[2], listMissionModelWed: list[3], listMissionModelThu: list[4], listMissionModelFri: list[5], listMissionModelSat: list[6])
        completion(entry)
        
        
//        var myCalendarMissionStoreData:MyCalendarMissionData?;
//        do {
//            myCalendarMissionStoreData = try JSONDecoder().decode(MyCalendarMissionData.self, from: primaryData)
//        } catch {
//            print("Could not write to file")
//        }
//        var listMissionModel = myCalendarMissionStoreData?.listMissionModelList ?? [];
//        var list = getArrayListThisWeek2(time: Date().timeIntervalSince1970, list: listMissionModel)
//        let entry = SimpleEntry(date: Date(timeIntervalSince1970: TimeInterval(list[0].time) / 1000), firstDate: Date(),listMissionModelSun: MissionModelList(time: 0, lunar: "", listMissionModel: []), listMissionModelMon: MissionModelList(time: 0, lunar: "", listMissionModel: []), listMissionModelTue: MissionModelList(time: 0, lunar: "", listMissionModel: []), listMissionModelWed: MissionModelList(time: 0, lunar: "", listMissionModel: []), listMissionModelThu: MissionModelList(time: 0, lunar: "", listMissionModel: []), listMissionModelFri: MissionModelList(time: 0, lunar: "", listMissionModel: []), listMissionModelSat: MissionModelList(time: 0, lunar: "", listMissionModel: []))
//        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        var myCalendarMissionStoreData:MyCalendarMissionData?;
        do {
            myCalendarMissionStoreData = try JSONDecoder().decode(MyCalendarMissionData.self, from: primaryData)
        } catch {
            print("Could not write to file")
        }
        
        var listMissionModel = myCalendarMissionStoreData?.listMissionModelList ?? [];
        
        var curDate:TimeInterval = Date().timeIntervalSince1970
        //        var timeDecalage: TimeInterval = 0;
        for index in 0...6 {
            do {
                var list = getArrayListThisWeek2(time: curDate, list: listMissionModel)
                curDate = curDate + 7 * 24 * 60 * 60;
                //            timeDecalage = timeDecalage + 7 * 24 * 60 * 60
                //            let missionModelList:MissionModelList = list[index]
                if index < list.count {
                    let time = list[index].time;
                    let entryDate = Date(timeIntervalSince1970: TimeInterval(time) / 1000)
                    let calendar = Calendar.current
                    let entry: SimpleEntry
                    //如果在time这周日之后
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyyMMdd"
                    let entryDateString = dateFormatter.string(from: entryDate)
                    let entryDateTimestamp = dateFormatter.date(from: entryDateString)?.timeIntervalSince1970
                    print("entryDate is in today")
                    //            } else {
                    //                entry = SimpleEntry(date: entryDate, firstDate: Date(),listMissionModelSun: list[0].listMissionModel, listMissionModelMon: list[1].listMissionModel, listMissionModelTue: list[2].listMissionModel, listMissionModelWed: list[3].listMissionModel, listMissionModelThu: list[4].listMissionModel, listMissionModelFri: list[5].listMissionModel, listMissionModelSat: list[6].listMissionModel)
                    //                print("entryDate is not in today")
                    //            }
                    if list.count > 6 {
                        entries.append(SimpleEntry(date: Date(timeIntervalSince1970: TimeInterval(list[0].time) / 1000), firstDate: Date(),listMissionModelSun: list[0], listMissionModelMon: list[1], listMissionModelTue: list[2], listMissionModelWed: list[3], listMissionModelThu: list[4], listMissionModelFri: list[5], listMissionModelSat: list[6]))
                        
                        entries.append(SimpleEntry(date: Date(timeIntervalSince1970: TimeInterval(list[1].time) / 1000), firstDate: Date(),listMissionModelSun: list[0], listMissionModelMon: list[1], listMissionModelTue: list[2], listMissionModelWed: list[3], listMissionModelThu: list[4], listMissionModelFri: list[5], listMissionModelSat: list[6]))
                        
                        entries.append(SimpleEntry(date: Date(timeIntervalSince1970: TimeInterval(list[2].time) / 1000), firstDate: Date(),listMissionModelSun: list[0], listMissionModelMon: list[1], listMissionModelTue: list[2], listMissionModelWed: list[3], listMissionModelThu: list[4], listMissionModelFri: list[5], listMissionModelSat: list[6]))
                        
                        
                        entries.append(SimpleEntry(date: Date(timeIntervalSince1970: TimeInterval(list[3].time) / 1000), firstDate: Date(),listMissionModelSun: list[0], listMissionModelMon: list[1], listMissionModelTue: list[2], listMissionModelWed: list[3], listMissionModelThu: list[4], listMissionModelFri: list[5], listMissionModelSat: list[6]))
                        
                        entries.append(SimpleEntry(date: Date(timeIntervalSince1970: TimeInterval(list[4].time) / 1000), firstDate: Date(),listMissionModelSun: list[0], listMissionModelMon: list[1], listMissionModelTue: list[2], listMissionModelWed: list[3], listMissionModelThu: list[4], listMissionModelFri: list[5], listMissionModelSat: list[6]))
                        
                        entries.append(SimpleEntry(date: Date(timeIntervalSince1970: TimeInterval(list[5].time) / 1000), firstDate: Date(),listMissionModelSun: list[0], listMissionModelMon: list[1], listMissionModelTue: list[2], listMissionModelWed: list[3], listMissionModelThu: list[4], listMissionModelFri: list[5], listMissionModelSat: list[6]))
                        
                        entries.append(SimpleEntry(date: Date(timeIntervalSince1970: TimeInterval(list[6].time) / 1000), firstDate: Date(),listMissionModelSun: list[0], listMissionModelMon: list[1], listMissionModelTue: list[2], listMissionModelWed: list[3], listMissionModelThu: list[4], listMissionModelFri: list[5], listMissionModelSat: list[6]))
                    }
                }
                } catch {
                    print("error: \(error)")
                }
            }
            print("entryDate is after today")
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    //        var entries: [SimpleEntry] = []
    //
    //        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    //        let currentDate = Date()
    //        for hourOffset in 0 ..< 5 {
    //            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
    //            let entry = SimpleEntry(date: entryDate)
    //            entries.append(entry)
    //        }
    //
    //        let timeline = Timeline(entries: entries, policy: .atEnd)
    //        completion(timeline)
    //    }
    //   }
    
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let firstDate: Date
    var listMissionModelSun: MissionModelList
    var listMissionModelMon: MissionModelList
    var listMissionModelTue: MissionModelList
    var listMissionModelWed: MissionModelList
    var listMissionModelThu: MissionModelList
    var listMissionModelFri: MissionModelList
    var listMissionModelSat: MissionModelList
    
}

struct MyCalendarWidgetEntryView : View {
    var entry: Provider.Entry
    var scale:Double = 7;
//    var date: Date
//    var listMissionModel: [MissionModel]
    var radius:Double = 15;
    var fontSize:CGFloat = 8;
    var itemHeight:CGFloat = 20;
    var padding:EdgeInsets = EdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 2);
    @Environment(\.widgetFamily) var family
    func getMaxItems() -> Int {
        switch family {
        case .systemSmall:
            return 4
        case .systemMedium:
            return 3
        case .systemLarge:
            return 9
        @unknown default:
            return 6
        }
    }
    
    func getMonth(month:Int) -> String {
//        let calendar = Calendar.current
//        let month = calendar.component(.month, from: date)
        switch month {
        case 1:
            return "january".localizable()
        case 2:
            return "february".localizable()
        case 3:
            return "march".localizable()
        case 4:
            return "april".localizable()
        case 5:
            return "may".localizable()
        case 6:
            return "june".localizable()
        case 7:
            return "july".localizable()
        case 8:
            return "august".localizable()
        case 9:
            return "september".localizable()
        case 10:
            return "october".localizable()
        case 11:
            return "november".localizable()
        default:
            return "december".localizable()
        }
    }
    
    @available(macOS 13.0, *)
    var body: some View {
        VStack {
            VStack {
                ZStack{
                    VStack {
                        HStack {
                            Text("\(Calendar.current.component(.year, from: Date(timeIntervalSince1970: TimeInterval(entry.listMissionModelWed.time / 1000))))")
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
                                Text("\(getMonth(month: (Calendar.current.component(.month, from: Date(timeIntervalSince1970: TimeInterval(entry.listMissionModelWed.time / 1000))))))")
                                    .padding(padding)
                                    .font(.system(size: 8))
                                    .bold()
                                    .foregroundColor(Color.gray).padding(EdgeInsets(top: 0, leading: 0, bottom: 7, trailing: 0))
                            }
                        }
                        
                        //                               .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                    }
                    // Rest of your layout
                }.frame(height: 32)
                    .background(Color.white)
                    .edgesIgnoringSafeArea(.all)
                GeometryReader { geometry in
                    HStack(alignment: .center, spacing: 0) {
                        VStack {
                            Text("\(Calendar.current.component(.day, from: Date(timeIntervalSince1970: TimeInterval(entry.listMissionModelSun.time / 1000))))").font(.system(size: 10)).foregroundColor(Calendar.current.isDate(entry.date, inSameDayAs: Date(timeIntervalSince1970: TimeInterval(entry.listMissionModelSun.time / 1000))) ? Color(hex:(0x4976f7)) : Color(hex: 0x404040))
                            if !entry.listMissionModelSun.lunar.isEmpty {
                                Text(entry.listMissionModelSun.lunar).font(.system(size: 8)).foregroundColor(Calendar.current.isDate(entry.date, inSameDayAs: Date(timeIntervalSince1970: TimeInterval(entry.listMissionModelSun.time / 1000))) ? Color(hex:(0x4976f7)) : Color(hex: 0x404040))
                            }
                            Text("sunday".localizable()).font(.system(size: 8)).foregroundColor(Calendar.current.isDate(entry.date, inSameDayAs: Date(timeIntervalSince1970: TimeInterval(entry.listMissionModelSun.time / 1000))) ? Color(hex:(0x4976f7)) : Color(hex: 0x404040))
                            
                            ForEach(entry.listMissionModelSun.listMissionModel.prefix(getMaxItems()), id: \.self) {item in
                                ZStack {
                                    GeometryReader { geometry in
                                        Rectangle()
                                            .fill(Color(hex:UInt((item.color ?? 0xff8800))))
                                            .frame(width: geometry.size.width)
                                            .opacity(0.2)
                                            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
                                    }
                                    Text(item.title ?? "")
                                        .lineLimit(1)
                                        .font(.system(size: fontSize))
                                        .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))
                                    
                                    
                                }
                                .frame(height: itemHeight)
                                .padding(padding)
                                
                            }
                            Spacer()
                        }.frame(width: geometry.size.width/scale)
                        VStack {
                            Text("\(Calendar.current.component(.day, from: Date(timeIntervalSince1970: TimeInterval(entry.listMissionModelMon.time / 1000))))").font(.system(size: 10)).foregroundColor(Calendar.current.isDate(entry.date, inSameDayAs: Date(timeIntervalSince1970: TimeInterval(entry.listMissionModelMon.time / 1000))) ? Color(hex:(0x4976f7)) : Color(hex: 0x404040))
                            if !entry.listMissionModelMon.lunar.isEmpty {
                                Text(entry.listMissionModelMon.lunar).font(.system(size: 8)).foregroundColor(Calendar.current.isDate(entry.date, inSameDayAs: Date(timeIntervalSince1970: TimeInterval(entry.listMissionModelMon.time / 1000))) ? Color(hex:(0x4976f7)) : Color(hex: 0x404040))
                            }
                            Text("monday".localizable()).font(.system(size: 8)).font(.system(size: 10)).foregroundColor(Calendar.current.isDate(entry.date, inSameDayAs: Date(timeIntervalSince1970: TimeInterval(entry.listMissionModelMon.time / 1000))) ? Color(hex:(0x4976f7)) : Color(hex: 0x404040))
                            
                            ForEach(entry.listMissionModelMon.listMissionModel.prefix(getMaxItems()), id: \.self) {item in
                                ZStack {
                                    GeometryReader { geometry in
                                        Rectangle()
                                            .fill(Color(hex:UInt((item.color ?? 0xff8800))))
                                            .opacity(0.2)
                                            .frame(width: geometry.size.width)
                                            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
                                    }
                                    Text(item.title ?? "")
                                        .lineLimit(1)
                                        .font(.system(size: fontSize))
                                        .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))
                                    
                                    
                                }
                                .frame(height: itemHeight)
                                .padding(padding)
                                
                            }
                            Spacer()
                        }.frame(width: geometry.size.width/scale)
                        
                        VStack {
                            Text("\(Calendar.current.component(.day, from: Date(timeIntervalSince1970: TimeInterval(entry.listMissionModelTue.time / 1000))))").font(.system(size: 10)).foregroundColor(Calendar.current.isDate(entry.date, inSameDayAs: Date(timeIntervalSince1970: TimeInterval(entry.listMissionModelTue.time / 1000))) ? Color(hex:(0x4976f7)) : Color(hex: 0x404040))
                            if !entry.listMissionModelTue.lunar.isEmpty {
                                Text(entry.listMissionModelTue.lunar).font(.system(size: 8)).foregroundColor(Calendar.current.isDate(entry.date, inSameDayAs: Date(timeIntervalSince1970: TimeInterval(entry.listMissionModelTue.time / 1000))) ? Color(hex:(0x4976f7)) : Color(hex: 0x404040))
                            }
                            Text("tuesday".localizable()).font(.system(size: 8)).foregroundColor(Calendar.current.isDate(entry.date, inSameDayAs: Date(timeIntervalSince1970: TimeInterval(entry.listMissionModelTue.time / 1000))) ? Color(hex:(0x4976f7)) : Color(hex: 0x404040))
                            
                            ForEach(entry.listMissionModelTue.listMissionModel.prefix(getMaxItems()), id: \.self) {item in
                                ZStack {
                                    GeometryReader { geometry in
                                        Rectangle()
                                            .fill(Color(hex:UInt((item.color ?? 0xff8800))))
                                            .opacity(0.2)
                                            .frame(width: geometry.size.width)
                                            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
                                    }
                                    Text(item.title ?? "")
                                        .lineLimit(1)
                                        .font(.system(size: fontSize))
                                        .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))
                                    
                                    
                                }
                                .frame(height: itemHeight)
                                .padding(padding)
                                
                            }
                            Spacer()
                        }.frame(width: geometry.size.width/scale)
                        
                        VStack {
                            Text("\(Calendar.current.component(.day, from: Date(timeIntervalSince1970: TimeInterval(entry.listMissionModelWed.time / 1000))))").font(.system(size: 10)).foregroundColor(Calendar.current.isDate(entry.date, inSameDayAs: Date(timeIntervalSince1970: TimeInterval(entry.listMissionModelWed.time / 1000))) ? Color(hex:(0x4976f7)) : Color(hex: 0x404040))
                            if !entry.listMissionModelWed.lunar.isEmpty {
                                Text(entry.listMissionModelWed.lunar).font(.system(size: 8)).foregroundColor(Calendar.current.isDate(entry.date, inSameDayAs: Date(timeIntervalSince1970: TimeInterval(entry.listMissionModelWed.time / 1000))) ? Color(hex:(0x4976f7)) : Color(hex: 0x404040))
                            }
                            Text("wednesday".localizable()).font(.system(size: 8)).font(.system(size: 10)).foregroundColor(Calendar.current.isDate(entry.date, inSameDayAs: Date(timeIntervalSince1970: TimeInterval(entry.listMissionModelWed.time / 1000))) ? Color(hex:(0x4976f7)) : Color(hex: 0x404040))
                            
                            ForEach(entry.listMissionModelWed.listMissionModel.prefix(getMaxItems()), id: \.self) {item in
                                ZStack {
                                    GeometryReader { geometry in
                                        Rectangle()
                                            .fill(Color(hex:UInt((item.color ?? 0xff8800))))
                                            .opacity(0.2)
                                            .frame(width: geometry.size.width)
                                            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
                                    }
                                    Text(item.title ?? "")
                                        .lineLimit(1)
                                        .font(.system(size: fontSize))
                                        .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))
                                    
                                    
                                }
                                .frame(height: itemHeight)
                                .padding(padding)
                                
                            }
                            Spacer()
                        }.frame(width: geometry.size.width/scale)
                        
                        VStack {
                            Text("\(Calendar.current.component(.day, from: Date(timeIntervalSince1970: TimeInterval(entry.listMissionModelThu.time / 1000))))").font(.system(size: 10)).foregroundColor(Calendar.current.isDate(entry.date, inSameDayAs: Date(timeIntervalSince1970: TimeInterval(entry.listMissionModelThu.time / 1000))) ? Color(hex:(0x4976f7)) : Color(hex: 0x404040))
                            if !entry.listMissionModelThu.lunar.isEmpty {
                                Text(entry.listMissionModelThu.lunar).font(.system(size: 8)).foregroundColor(Calendar.current.isDate(entry.date, inSameDayAs: Date(timeIntervalSince1970: TimeInterval(entry.listMissionModelThu.time / 1000))) ? Color(hex:(0x4976f7)) : Color(hex: 0x404040))
                            }
                            
                            Text("thursday".localizable()).font(.system(size: 8)).font(.system(size: 10)).foregroundColor(Calendar.current.isDate(entry.date, inSameDayAs: Date(timeIntervalSince1970: TimeInterval(entry.listMissionModelThu.time / 1000))) ? Color(hex:(0x4976f7)) : Color(hex: 0x404040))
                            
                            ForEach(entry.listMissionModelThu.listMissionModel.prefix(getMaxItems()), id: \.self) {item in
                                ZStack {
                                    GeometryReader { geometry in
                                        Rectangle()
                                            .fill(Color(hex:UInt((item.color ?? 0xff8800))))
                                            .opacity(0.2)
                                            .frame(width: geometry.size.width)
                                            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
                                    }
                                    Text(item.title ?? "")
                                        .lineLimit(1)
                                        .font(.system(size: fontSize))
                                        .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))
                                    
                                    
                                }
                                .frame(height: itemHeight)
                                .padding(padding)
                                
                            }
                            Spacer()
                        }.frame(width: geometry.size.width/scale)
                        
                        VStack {
                            Text("\(Calendar.current.component(.day, from: Date(timeIntervalSince1970: TimeInterval(entry.listMissionModelFri.time / 1000))))").font(.system(size: 10)).foregroundColor(Calendar.current.isDate(entry.date, inSameDayAs: Date(timeIntervalSince1970: TimeInterval(entry.listMissionModelFri.time / 1000))) ? Color(hex:(0x4976f7)) : Color(hex: 0x404040))
                            if !entry.listMissionModelFri.lunar.isEmpty {
                                Text(entry.listMissionModelFri.lunar).font(.system(size: 8)).foregroundColor(Calendar.current.isDate(entry.date, inSameDayAs: Date(timeIntervalSince1970: TimeInterval(entry.listMissionModelFri.time / 1000))) ? Color(hex:(0x4976f7)) : Color(hex: 0x404040))
                            }
                            
                            Text("friday".localizable()).font(.system(size: 8)).font(.system(size: 10)).foregroundColor(Calendar.current.isDate(entry.date, inSameDayAs: Date(timeIntervalSince1970: TimeInterval(entry.listMissionModelFri.time / 1000))) ? Color(hex:(0x4976f7)) : Color(hex: 0x404040))
                            
                            ForEach(entry.listMissionModelFri.listMissionModel.prefix(getMaxItems()), id: \.self) {item in
                                ZStack {
                                    GeometryReader { geometry in
                                        Rectangle()
                                            .fill(Color(hex:UInt((item.color ?? 0xff8800))))
                                            .frame(width: geometry.size.width)
                                            .opacity(0.2)
                                            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
                                    }
                                    Text(item.title ?? "")
                                        .lineLimit(1)
                                        .font(.system(size: fontSize))
                                        .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))
                                    
                                    
                                }
                                .frame(height: itemHeight)
                                .padding(padding)
                                
                            }
                            Spacer()
                        }.frame(width: geometry.size.width/scale)
                        
                        VStack {
                            Text("\(Calendar.current.component(.day, from: Date(timeIntervalSince1970: TimeInterval(entry.listMissionModelSat.time / 1000))))").font(.system(size: 10)).foregroundColor(Calendar.current.isDate(entry.date, inSameDayAs: Date(timeIntervalSince1970: TimeInterval(entry.listMissionModelSat.time / 1000))) ? Color(hex:(0x4976f7)) : Color(hex: 0x404040))
                            if !entry.listMissionModelSat.lunar.isEmpty {
                                Text(entry.listMissionModelSat.lunar).font(.system(size: 8)).foregroundColor(Calendar.current.isDate(entry.date, inSameDayAs: Date(timeIntervalSince1970: TimeInterval(entry.listMissionModelSat.time / 1000))) ? Color(hex:(0x4976f7)) : Color(hex: 0x404040))
                            }
                            
                            Text("saturday".localizable()).font(.system(size: 8)).font(.system(size: 10)).foregroundColor(Calendar.current.isDate(entry.date, inSameDayAs: Date(timeIntervalSince1970: TimeInterval(entry.listMissionModelSat.time / 1000))) ? Color(hex:(0x4976f7)) : Color(hex: 0x404040))
                            
                            ForEach(entry.listMissionModelSat.listMissionModel.prefix(getMaxItems()), id: \.self) {item in
                                ZStack {
                                    GeometryReader { geometry in
                                        Rectangle()
                                            .fill(Color(hex:UInt((item.color ?? 0xff8800))))
                                            .opacity(0.2)
                                            .frame(width: geometry.size.width)
                                            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
                                    }
                                    Text(item.title ?? "")
                                        .lineLimit(1)
                                        .font(.system(size: fontSize))
                                        .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))
                                    
                                    
                                }
                                .frame(height: itemHeight)
                                .padding(padding)
                                
                            }
                            Spacer()
                        }.frame(width: geometry.size.width/scale)
                        
                    }
                }
            }
        }.background(Color.white)
    }
}

@main
struct MyCalendarWidget: Widget {
    let kind: String = "MyCalendarWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MyCalendarWidgetEntryView(entry: entry)
        }
        .contentMarginsDisabled()
        .configurationDisplayName("calendar_this_week".localizable())
        .description("")
        .supportedFamilies([ .systemLarge, .systemMedium])
    }
}



