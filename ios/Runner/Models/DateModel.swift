////
////  DateData.swift
////  sunghoyazaza
////
////  Created by 077tech on 2023/05/07.
////
//
////MARK: Data for Date
//import SwiftUI
//
//
//
//struct Record{
//    var type:RecordType
//    
//    
//    enum RecordType{
//        case success
//        case fail
//    }
//}
//
//
//
////例如，如果在前一天的12点到今天的12点范围内限制失败，前一天的记录将被处理为失败。
//// 20230510 23点失败 -> 20230510 失败
//// 20230511 1点失败 -> 20230510 失败
//// 20230511 10点失败 -> 20230510 失败，
//
//
////var dummyData:[String] = [
//////    "20230508",
//////    "20230509",
//////    "20230510",
//////    "20230502"
//////    "20230511":false
////   //  "20230510",
////    "20230509",
////     "20230510"
////]
//
//
//
//@available(iOS 16.0, *)
//class DateModel:ObservableObject{
//    
//    private init(){}
//    
//    static let shared = DateModel()
//    
//    @AppStorage("failList", store: UserDefaults(suiteName: APP_GROUP_NAME))
//    var failList: String = "{\"strings\":[]}"
//    
//    @AppStorage("startDate", store: UserDefaults(suiteName: APP_GROUP_NAME))
//    var startDate: String = "00000000"
//    
//    @Published
//    var records:[String:Record] = [:]
//    
//    func reloadData(){
//        guard startDate != "00000000" else {return}
//        guard let failList = self.failList.decode else { return }
//        var failDic:[String:Bool] = [:]
//        failList.forEach{
//            failDic[$0] = true
//        }
//        var current = startDate.toDate()!
//        let calendar = Calendar.current
//        let components = calendar.dateComponents([.day], from: startDate.toDate()!, to: Date.now.toDate()!)
//        let days = (components.day ?? 0)
//        var tempRecords:[String:Record] = [:]
//        
//        
//        var now = Date()
//        let hour = calendar.component(.hour, from: now)
//        let minute = calendar.component(.minute, from: now)
//        
//        let sleepEndDateComponent = ScreenTimeVM.shared.sleepEndDateComponent
//        
//        if (hour < sleepEndDateComponent.hour!) || (hour == sleepEndDateComponent.hour! && minute <= sleepEndDateComponent.minute!){
//            for day in 0..<days{
//                let dateString = current.toString()
//                if failDic[dateString] == nil {
//                    if day < days - 1{
//                        tempRecords[dateString] = Record(type: .success)
//                    }
//                }else{
//                    tempRecords[dateString] = Record(type: .fail)
//                }
//                current = calendar.date(byAdding: .day, value: 1, to: current)!
//            }
//        }else{
//            for day in 0...days{
//                let dateString = current.toString()
//                if failDic[dateString] == nil {
//                    if day < days{
//                        tempRecords[dateString] = Record(type: .success)
//                    }
//                }else{
//                    tempRecords[dateString] = Record(type: .fail)
//                }
//                current = calendar.date(byAdding: .day, value: 1, to: current)!
//            }
//        }
//
//
//
//        self.records = tempRecords
//    }
//    
//    var totalSuccessCount:Int{
//        self.records.filter{$0.value.type == .success}.count
//    }
//    var recentSuccessCount:Int{
//        getCount(.fail)
//    }
//    
//    var recentFailCount:Int{
//        getCount(.success)
//    }
//
//    var grade:UsageType{
//        let totalSuccessCount = totalSuccessCount
//        let recentSuccessCount = recentSuccessCount
//        let recentFailCount = recentFailCount
//        
//
//        if recentSuccessCount > 1{
//            return .successContinue
//        }else if recentSuccessCount == 1{
//            if totalSuccessCount == 1{
//                return .firstSuccess
//            }else if totalSuccessCount > 1{
//                return .successFailSuccess
//            }
//        }
//        
//        if recentFailCount == 1{
//            if totalSuccessCount == 0{
//                return .onlyFail
//            }else{
//                return .failAfterSuccess
//            }
//        }else if recentFailCount > 1{
//            if totalSuccessCount == 0{
//                return .onlyFail
//            }else{
//                return .failContinueAfterSuccess
//            }
//        }
//
//        return .noRecord //recentSuccess == 0 , recentFail == 0
//    }
//    
//    
//    
//    func getCount(_ type:Record.RecordType)->Int{
//        var count = 0
//        let recordList = self.records.map{(date:$0.key,record:$0.value)}.sorted{$0.date > $1.date}
//        for list in recordList {
//            if list.record.type == type{
//                break
//            }else{
//                count += 1
//            }
//        }
//        return count
//    }
//    enum UsageType{
//        case noRecord
//        case onlyFail
//        case failAfterSuccess
//        case failContinueAfterSuccess
//        case firstSuccess
//        case successFailSuccess
//        case successContinue
//    }
//}
