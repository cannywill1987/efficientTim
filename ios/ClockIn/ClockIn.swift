//
//  ClockInExtension.swift
//  ClockInExtension
//
//  Created by 林智彬 on 2023/8/31.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    @AppStorage("FlomoMissionModel", store: UserDefaults(suiteName: "group.com.timespeed.timehello")) var primaryData : Data = Data()

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

struct SimpleEntry: TimelineEntry {
    let date: Date
    var listMissionModel: [FlomoMissionModel]
}

struct ClockInExtensionEntryView : View {
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

        }.padding(EdgeInsets(top: 6, leading: 4, bottom: 0, trailing: 0)).background(Color.white)
    }
}

@main
struct ClockInExtension: Widget {
    let kind: String = "ClockInExtension"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ClockInExtensionEntryView(entry: entry)
        }
        .contentMarginsDisabled() 
        .configurationDisplayName("clockInToday".localizable())
        .description("")
    }
}

struct ClockInExtension_Previews: PreviewProvider {
    static var previews: some View {
        ClockInExtensionEntryView(entry: SimpleEntry(date: Date(), listMissionModel: []))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

struct GridView: View {
    var listMissionModel: [FlomoMissionModel]
        let radius:Double = 15;
        var percent:Double = 0.3;
        var isChecked: Bool = true;
        @Environment(\.widgetFamily) var family
        @Environment(\.colorScheme) var colorScheme

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
                        .fill(Color(hex:UInt((item.color ?? 0xff8800))))
                        .frame(width: geometry.size.width * CGFloat(item.percent ?? 0))
                        .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
                    Rectangle()
                        .fill(Color(hex:UInt((item.color ?? 0xff8800))))
                        .frame(width: geometry.size.width)
                        .opacity(0.2)
                        .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
                }
                HStack {
                    Text(item.title ?? "")
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
    @Environment(\.colorScheme) var colorScheme

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
                            .fill(Color(hex:UInt((item.color ?? 0xff8800))))
                            .frame(width: geometry.size.width * CGFloat(item.percent ?? 0))
                            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
                        Rectangle()
                            .fill(Color(hex:UInt((item.color ?? 0xff8800))))
                            .frame(width: geometry.size.width)
                            .opacity(0.2)
                            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
                    }
                    HStack {
                        Text(item.title ?? "")
                            .font(.system(size: 12))
                            .foregroundColor(colorScheme == .dark ? Color.white : Color(red: 64/255, green: 64/255, blue: 64/255))
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
                        .foregroundColor(colorScheme == .dark ? Color.white : Color(red: 64/255, green: 64/255, blue: 64/255))
                }.padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing:4))
            }
            Spacer()
        }
    }
}
