////
////  MainTextData.swift
////  sunghoyazaza
////
////  Created by 077tech on 2023/05/07.
////
//import Foundation
//import SwiftUI
//
////MARK: 메인 뷰 DB
//@available(iOS 16.0, *)
//class MainModel:ObservableObject{
//    
//    var dateModel = DateModel.shared
//    // 主屏幕顶部文本数据库
//    var mainLabel:String{
//        switch dateModel.grade{
//        case .noRecord:
//            return "实现睡眠计划并\n迈出了第一步 👣"
//        case .successContinue:
//            return "\(dateModel.recentSuccessCount)天连续实现\n睡眠计划 🔥"
//        case .firstSuccess:
//            return "首次实现了睡眠计划 🎉"
//        case .onlyFail:
//            return "实现睡眠计划并\n迈出了第一步 👣"
//        case .failAfterSuccess:
//            return "记录已经破裂，\n但请鼓起勇气重新开始 💪"
//        case .failContinueAfterSuccess:
//            return "睡眠计划已经连续\(dateModel.recentFailCount)天未实现 🥺"
//        case .successFailSuccess:
//            return "你已经找到了初心\n从今天开始再次奔跑 🏃"
//        @unknown default:
//            return "another"
//        }
//    }
//    let subLabelList:[String] = [
//        "美国国家睡眠基金会建议7-9小时的睡眠",
//        "良好睡眠的关键是每天在固定的时间醒来",
//        "90%的合格者强调了规律的睡眠时间",
//        "7小时以上的深度睡眠可以帮助你明天集中注意力",
//        "今天也要努力学习",
//        "我们一直在为你加油",
//        "希望你的努力能有所回报",
//        "虽然会很辛苦，但只要坚持一下，就会有好结果",
//        "想象一下你成为公务员的样子",
//        "你期待成为公务员的样子吗？"
//    ]
//    // 主屏幕顶部鼓励文本数据库
//    var subLabel:String{
//        subLabelList[Int(arc4random_uniform(UInt32(Int32(subLabelList.count))))]
//    }
//    
//    //MARK: 달력 DB는 따로 정리 ==> DateModel()
//    //MARK: 달력 DB는 따로 정리 ==> DateModel()
//    //MARK: 달력 DB는 따로 정리 ==> DateModel()
//    
//    
//    // Sleep plan "Bedtime + Wake up time + Corresponding day" DB
//    var weekDay : String = "Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday"
//    var sleepTime : String = "11:00PM"
//    var wakeupTime : String = "09:00AM"
//    
//    init() {
//        self.weekDay = getWeekDate()
//        self.sleepTime = getBedTime()
//        self.wakeupTime = getWakeupTime()
//    }
//    
//    // 차단된 어플리케이션 목록 DB
//    var blockApplicationData: [String] = [
//        "instagram",
//        "youtube",
//        "toss",
//        "kakaotalk",
//        "line",
//        "discord",
//        "facebook",
//        "tiktok",
//        "facebook",
//        "tiktok",
//        "facebook",
//        "tiktok",
//        "facebook",
//        "tiktok"
//    ]
//}
//
//func fDateTime(time: Date) -> String {
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "a hh:mm"
//    let timeStirng = dateFormatter.string(from: time)
//    
//    return timeStirng
//}
//@available(iOS 16.0, *)
////func getBedTime() -> String {
////    //let startAt = UserDefaults.standard.object(forKey: "startAt") as? Date ?? Date()
////    //MARK: 转换用户设置的时间值（从DateComponenet到Date类型）
////    let userStartAt = ScreenTimeVM.shared.sleepStartDateComponent
////    let startAt = Calendar.current.date(from: userStartAt)!
////    
////    return fDateTime(time: startAt)
////}
////@available(iOS 16.0, *)
////func getWakeupTime() -> String {
////    //let endAt = UserDefaults.standard.object(forKey: "endAt") as? Date ?? Date()
////    //MARK: 加载用户设置的时间值（从DateComponenet转换为Date类型）
////    let userEndAt = ScreenTimeVM.shared.sleepEndDateComponent
////    let endAt = Calendar.current.date(from: userEndAt)!
////    
////    return fDateTime(time: endAt)
////}
//
//func getWeekDate() -> String {
//    let selectedDays:[Bool] = UserDefaults.standard.array(forKey: "selectedDays") as? [Bool] ?? [Bool](repeating: false, count: 7)
//    let daysOfWeek = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
//    var stringArray:[String] = []
//    
//    for index in 0 ..< selectedDays.count {
//        if (selectedDays[index]) {
//            stringArray.append(daysOfWeek[index])
//        }
//    }
//    
//    let weekDate = stringArray.joined(separator: ", ")
//    return weekDate
//}
