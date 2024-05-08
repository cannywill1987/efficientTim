//
//  CountDownWidget.swift
//  CountDownWidget
//
//  Created by 林智彬 on 2023/8/28.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(offset: 1, date: Date(), remainingTime: Date().timeIntervalSince(Date().endOfYear), timeToNextYear: Date().timeIntervalSince(Date().startOfNextYear))
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(offset: 1, date: Date(), remainingTime: Date().timeIntervalSince(Date().endOfYear), timeToNextYear: Date().timeIntervalSince(Date().startOfNextYear))
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let currentDate = Date()
        for minuteOffset in 0 ..< 60 {
            let offset = minuteOffset
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            let entry = SimpleEntry(offset: offset, date: entryDate, remainingTime: entryDate.timeIntervalSince(entryDate.endOfYear), timeToNextYear: entryDate.timeIntervalSince(entryDate.startOfNextYear))
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let offset: Int;
    let date: Date
    let remainingTime: TimeInterval
    let timeToNextYear: TimeInterval
}

struct CountDownWidgetEntryView : View {
    var entry: Provider.Entry

    
//    func getDateYMD(y:Int,m:Int,d:Int) -> Date {
//        var date = DateComponents()
//        date.year = y
//        date.month = m
//        date.day = d
//
//        let dateObj = Calendar.current.date(from: date)
//
//        print("Given date: \(dateObj!)")
//        return  dateObj!
//    }
    
    var body: some View {
        VStack {
            
            // 显示当前日期
            //            Text(Date(), style: .date)
            //
            //            // 显示当前时间
            //            Text(Date(), style: .time)
            //
            //            // 显示相对于当前时间的日期
            //            Text(Date().addingTimeInterval(60*60*24*3), style: .relative)
            //
            //            // 显示倒计时到指定日期
            //            Text(Date().addingTimeInterval(60*60*24*3), style: .timer)
            //
            //            // 显示日期偏移
            //            Text(Date().addingTimeInterval(60*60*24*3), style: .offset)
            
            //            Text(getDateYMD(y: 2020, m: 7, d: 7),
            //                    style: Text.DateStyle.time)
            //                .padding(.all, 10)
            Spacer(minLength: 100)
            MinWidget()
            SecWidget()
            
            Text(CountDownUtil.getDateYMD(y: 2023, m: 8, d: 30),
                 style: Text.DateStyle.timer)
            .frame(width: 10, height: 30)
            .lineLimit(1)
            .truncationMode(.middle)
            .truncationMode(.tail)
            
            //            Text(getDateYMD(y: 2023, m: 8, d: 30),
            //                 style: Text.DateStyle.timer)
            //                .padding(.all, 10)
            //                .frame(width: 60, alignment:.trailing)
            //                .clipped()
            Text(CountDownUtil.getDateYMD(y: 2023, m: 8, d: 30),
                 style: Text.DateStyle.timer)
            .padding(.all, 10)
            Text(CountDownUtil.getDateYMD(y: 2023, m: 8, d: 30),
                 style: Text.DateStyle.timer)
            .padding(.all, 10)
            .frame(width: 30)
            .truncationMode(.tail)
            .clipped()
            //            Text(timerInterval: Date.now...(Calendar.current.date(byAdding: Calendar.Component.second, value: (172800 * 1000 / 1000 ?? 0), to: Date())!), countsDown: true)
            //                                                                .font(.system(size: 25)).fontWeight(.bold) // Set time
            //                                                                .font(.caption2)
            HStack {
                Text("今年剩余 \(entry.offset)")
                Spacer()
                Text(formatTimeInterval(entry.remainingTime))
            }
            HStack {
                Text("每年1月1日")
                Spacer()
                Text(formatTimeInterval(entry.timeToNextYear))
            }
        }
    }
    
    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        return formatter.string(from: interval)!
    }
}

struct MinWidget: View {
    var offsetX1 = -20;
    var width = 70
    var body: some View {
        ZStack {
            Color.red
                .frame(width: 40, height: 25)
                .offset(x: -100, y: 0)
                .zIndex(3)
            Text(CountDownUtil.getDateYMD(y: 2023, m: 8, d: 30),
                 style: Text.DateStyle.timer)
                 .font(.system(size: 25)).fontWeight(.bold)
                 .zIndex(1).offset(x: CGFloat(offsetX1), y: 0)
            Color.orange
                .frame(width: 100, height: 25)
                .offset(x: -3, y: 0)
                .zIndex(2)
        }
    }
}

struct SecWidget: View {
    var body: some View {
        ZStack {
            Text(CountDownUtil.getDateYMD(y: 2023, m: 8, d: 30),
                 style: Text.DateStyle.timer)
                 .font(.system(size: 25)).fontWeight(.bold)
                 .zIndex(1).offset(x: -59, y: 0)
            Color.orange
                .frame(width: 70, height: 20)
                .offset(x: -116, y: 0)
                .zIndex(2)
        }
    }
}

@main
struct CountDownWidget: Widget {
    let kind: String = "CountDownWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CountDownWidgetEntryView(entry: entry)
        }
        .contentMarginsDisabled() 
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct CountDownWidget_Previews: PreviewProvider {
    static var previews: some View {
        CountDownWidgetEntryView(entry: SimpleEntry(offset: 1,date: Date(), remainingTime: Date().timeIntervalSince(Date().endOfYear), timeToNextYear: Date().timeIntervalSince(Date().startOfNextYear)))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

extension Date {
    var endOfYear: Date {
        let calendar = Calendar.current
        let components = DateComponents(year: calendar.component(.year, from: self), month: 12, day: 31, hour: 23, minute: 59, second: 59)
        return calendar.date(from: components)!
    }
    
    var startOfNextYear: Date {
        let calendar = Calendar.current
        let components = DateComponents(year: calendar.component(.year, from: self) + 1, month: 1, day: 1, hour: 0, minute: 0, second: 0)
        return calendar.date(from: components)!
    }
}
