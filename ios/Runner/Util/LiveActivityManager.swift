//
//  ActivityManager.swift
//  Runner
//
//  Created by 林智彬 on 2023/4/13.
//

import Foundation
import ActivityKit

////
////  LiveActivityManager.swift
////  Runner
////
////  Created by 林智彬 on 2022/1/29.
////
//
import Foundation
//import Flutter
import UIKit
import ActivityKit

@available(iOS 16.1, *)
class LiveActivityManager {
    static let instance:LiveActivityManager = LiveActivityManager()
    var activity: Activity<IslandAttributes>?;
    var isLaunching: Bool = false;
    var curCounterStatus: Int?
    
    static func shareInstance() -> LiveActivityManager {
        if (instance.activity == nil) {
            
            //            let finalState = IslandAttributes.ContentState(value: 3, startTime: Date().addingTimeInterval(60 * 5), deliveryTimer: Date.now...(Calendar.current.date(byAdding: Calendar.Component.second, value: (Int(1000) ?? 0), to: Date()) ?? Date.now));
            //
            //            Task {
            //                await instance.activity?.end(using:finalState, dismissalPolicy: .default)
            //            }
            
            
        }
        return instance;
    }
    
    
    func startActivity(objectId: String, currentTimeStamp: Int, statusString: String,
                       totalTomatees: Int,
                       numTomatees: Int,
                       focusedDuration: String,
                       bgUrl: String,title: String, text: String, time: Int, counterStatusEnum: CounterStatusEnum, isCountDown: Bool, focusDurationInt: Int, restingDurationInt: Int) {
        //async要用await方法
        //        Task {
        //             await observeActivity()
        //        }
        //        if Utility.isIpad() == false {
        //        if let activity = self.activity {
        if ActivityAuthorizationInfo().areActivitiesEnabled {
            //            let state = IslandAttributes.ContentState(value: 3, startTime: Date().addingTimeInterval(60 * 5), deliveryTimer: Date.now...(Calendar.current.date(byAdding: Calendar.Component.second, value: (Int(1000) ?? 0), to: Date()) ?? Date.now), counterStatusEnum: 0);
            if(!(numTomatees == 0 && totalTomatees == 0) == true) {
                let state = IslandAttributes.ContentState(
                    statusString: statusString,
                    totalTomatees: totalTomatees,
                    numTomatees: numTomatees,
                    focusedDuration: focusedDuration,
                    bgUrl: bgUrl,
                    title:title, text: text, value: 3, startTime: Date(), deliveryTimer: Date.now...(Calendar.current.date(byAdding: Calendar.Component.second, value: (time / 1000 ?? 0), to: Date()) ?? Date.now), counterStatusEnum: counterStatusEnum.rawValue ?? 6, isCountingDown: isCountDown, timerDuration: (time / 1000 ?? 0), objectId: objectId,isPaused: self.isPaused(val: counterStatusEnum.rawValue ?? 6),focusDurationInt: focusDurationInt, restingDurationInt: restingDurationInt);
                //            Task {
                //                await self.activity?.update(using: state)
                //            }
                
                let attr = IslandAttributes(currentTimeStamp: currentTimeStamp, time: time, objectId: objectId, name: "test", counterStatusEnum: counterStatusEnum.rawValue ?? 6)
                
                do {
                    //~~~~~~这里开始计时组件
                    self.activity = try Activity.request(attributes: attr, contentState: state, pushType: nil)
                } catch { // 加入一个空的catch，用于关闭catch。否则会报错：Errors thrown from here are not handled because the enclosing catch is not exhaustive
                    print("err \(error)")
                }
                
            } else {
                Task {
                    await stopAllActivity();
                }
            }
        }
        //        }
        //        }
    }
    /**得到当前秒单位时间戳**/
    func getCurrentTimeStampBySeconds() -> Int{
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return timeStamp * 1000;
    }

    @objc func stopActivity() {
        //        if Utility.isIpad() == false {
        
        if ActivityAuthorizationInfo().areActivitiesEnabled {
            if let activity = self.activity {
                let state = IslandAttributes.ContentState(statusString: "",
                                                          totalTomatees: 0,
                                                          numTomatees: 0,
                                                          focusedDuration: "0mins",
                                                          bgUrl: "", title:"", text: "", value: 3, startTime: Date().addingTimeInterval(60 * 5), deliveryTimer: Date.now...(Calendar.current.date(byAdding: Calendar.Component.second, value: (Int(1000) ?? 0), to: Date()) ?? Date.now), counterStatusEnum: 0, isCountingDown: true, startTimeForElapse: Date() , isPaused: self.isPaused(val: 0));
                
                
                
                Task {
                    await self.activity?.end(dismissalPolicy: .immediate)
                    self.activity = nil
                }
            }
        }
        //        }
    }
    
//    enum CounterStatusEnum:Int {
//        case focusing=0 //专注中 红色计时中
//        case pausingFucusing=1 //专注暂停中
//        case relaxing=2 //休息中 蓝色计时中
//        case waitingToFocus=3 //等待专注中
//        case waitingToStartRelaxing=4 //等待休息启动
//        case pausingRelaixing=5 //暂停休息中
//        case none=6 //没任何选择
//    }
    func isPaused(val: Int) -> Bool {
        // 判断传入的值是否为暂停状态
        return val == 1 || val == 5
    }
    
    func requestLiveActivity(objectId: String, statusString: String,
                             totalTomatees: Int,
                             numTomatees: Int,
                             focusedDuration: String,
                             bgUrl: String,title: String, text: String, time: Int, counterStatusEnum: CounterStatusEnum, isCountDown: Bool) {
        //        if Utility.isIpad() == false {
        do {
        var countDown = isCountDown;
        if(counterStatusEnum != CounterStatusEnum.focusing) {
            countDown = true;
        }
        if(countDown == true) {
            print("~~~~~~~~~~~~~~~~~~time \(time) and \(counterStatusEnum.rawValue) \(counterStatusEnum)")
            let state = IslandAttributes.ContentState(statusString: statusString,
                                                      totalTomatees: totalTomatees,
                                                      numTomatees: numTomatees,
                                                      focusedDuration: focusedDuration,
                                                      bgUrl: bgUrl,title:title, text:text, value: 3, startTime: Date(), deliveryTimer: Date.now...(Calendar.current.date(byAdding: Calendar.Component.second, value: (time / 1000 ?? 0), to: Date()) ?? Date.now), counterStatusEnum: counterStatusEnum.rawValue ?? 6, isCountingDown: countDown, startTimeForElapse: Date() , timerDuration: (time / 1000 ?? 0), objectId: objectId,isPaused: self.isPaused(val: counterStatusEnum.rawValue ?? 6));
            Task {
                if ActivityAuthorizationInfo().areActivitiesEnabled {
                    await self.stopAllActivity()
                    let attr = IslandAttributes(currentTimeStamp: 0, time: time, objectId: "", name: "test", counterStatusEnum: counterStatusEnum.rawValue ?? 6)
                    
                    do {
                        //~~~~~~这里开始计时组件
                        self.activity = try Activity.request(attributes: attr, contentState: state, pushType: nil)
                    } catch { // 加入一个空的catch，用于关闭catch。否则会报错：Errors thrown from here are not handled because the enclosing catch is not exhaustive
                        print("err \(error)")
                    }
                } else {
                    await self.activity?.update(using: state)
                }
            }
        } else {
            print("~~~~~~~~~~~~~~~~~~time \(time) and \(counterStatusEnum.rawValue) \(counterStatusEnum)")
            let state = IslandAttributes.ContentState(statusString: statusString,
                                                      totalTomatees: totalTomatees,
                                                      numTomatees: numTomatees,
                                                      focusedDuration: focusedDuration,
                                                      bgUrl: bgUrl,title:title, text:text, value: 3, startTime: Date(), deliveryTimer: (Calendar.current.date(byAdding: Calendar.Component.second, value: -(time / 1000 ?? 0), to: Date()) ?? Date.now)...(Calendar.current.date(byAdding: Calendar.Component.second, value: 1000 * 1000 * 1000 + (time / 1000 ?? 0), to: Date()) ?? Date.now), counterStatusEnum: counterStatusEnum.rawValue ?? 6, isCountingDown: countDown, startTimeForElapse: Date(), timerDuration: (time / 1000 ?? 0),objectId: objectId, isPaused: self.isPaused(val: counterStatusEnum.rawValue ?? 6));
            Task {
                await self.activity?.update(using: state)
            }
        }
        } catch {
            
        }
        //        }
    }
    
    func stopAllActivity() async {
        let activities = Activity<IslandAttributes>.activities
        for activity in activities {
            // 结束活动并选择消失策略（例如立即消失）
            await activity.end(dismissalPolicy: .immediate)
        }
    }
    
    
    // 更新 Activity
    func updateActivity(
        objectId: String,
        currentTimeStamp: Int,
        statusString: String,
        totalTomatees: Int,
        numTomatees: Int,
        focusedDuration: String,
        bgUrl: String,
        title: String,text: String, isCountDown: Bool ,time: Int, counterStatusEnum: CounterStatusEnum, focusedDurationInt: Int, restingDurationInt: Int)  {
            //        print("~~~~~~~~~~~~~~~~~~time \(time) and \(counterStatusEnum.rawValue) ")
            //            if Utility.isIpad() == false {
            if ActivityAuthorizationInfo().areActivitiesEnabled {
            
            Task {
                
            
                if self.activity != nil {
                    switch counterStatusEnum {
                    case .focusing:
                        if(self.isLaunching == true) {
                            return;
                        }
                        self.isLaunching = true;
                        requestLiveActivity(objectId: objectId,statusString: statusString,
                                            totalTomatees: totalTomatees,
                                            numTomatees: numTomatees,
                                            focusedDuration: focusedDuration,
                                            bgUrl: bgUrl,title:title, text: text, time: time, counterStatusEnum: counterStatusEnum, isCountDown: isCountDown);
                        //                    menu.addItem(NSMenuItem.separator())
                        //                    menu.addItem(getPauseMenuItem())
                        break
                    case .pausingFucusing:
                        self.isLaunching = false;
                        //                    menu.addItem(NSMenuItem.separator())
                        //                    menu.addItem(getStartMenuItem())
                        //                    menu.addItem(NSMenuItem.separator())
                        //                    menu.addItem(getStopMenuItem())
                        //                        requestLiveActivity(statusString: statusString,
                        //                                            totalTomatees: totalTomatees,
                        //                                            numTomatees: numTomatees,
                        //                                            focusedDuration: focusedDuration,
                        //                                            bgUrl: bgUrl,title:title, text: text, time: time, counterStatusEnum: counterStatusEnum, isCountDown: isCountDown);
                        await stopAllActivity()
                        break
                    case .relaxing:
                        if(self.isLaunching == true) {
                            return;
                        }
                        self.isLaunching = true;
                        requestLiveActivity(objectId: objectId,statusString: statusString,
                                            totalTomatees: totalTomatees,
                                            numTomatees: numTomatees,
                                            focusedDuration: focusedDuration,
                                            bgUrl: bgUrl,title:title, text: text, time: time, counterStatusEnum: counterStatusEnum, isCountDown: isCountDown);
                        //                    menu.addItem(NSMenuItem.separator())
                        //                    menu.addItem(getDoneMenuItem())
                        break
                    case .waitingToFocus:
                        //                    menu.addItem(NSMenuItem.separator())
                        //                    menu.addItem(getStartMenuItem())
                        //                        requestLiveActivity(statusString: statusString,
                        //                                            totalTomatees: totalTomatees,
                        //                                            numTomatees: numTomatees,
                        //                                            focusedDuration: focusedDuration,
                        //                                            bgUrl: bgUrl,title:title, text: text, time: time, counterStatusEnum: counterStatusEnum, isCountDown: isCountDown);
                        await stopAllActivity()
                        self.isLaunching = false;
                        break
                    case .waitingToStartRelaxing:
                        //                    menu.addItem(NSMenuItem.separator())
                        //                    menu.addItem(getStartMenuItem())
                        //                        requestLiveActivity(statusString: statusString,
                        //                                            totalTomatees: totalTomatees,
                        //                                            numTomatees: numTomatees,
                        //                                            focusedDuration: focusedDuration,
                        //                                            bgUrl: bgUrl,title:title, text: text, time: time, counterStatusEnum: counterStatusEnum, isCountDown: isCountDown);
                        await stopAllActivity()
                        self.isLaunching = false;
                        break
                    case .pausingRelaixing:
                        //                        requestLiveActivity(statusString: statusString,
                        //                                            totalTomatees: totalTomatees,
                        //                                            numTomatees: numTomatees,
                        //                                            focusedDuration: focusedDuration,
                        //                                            bgUrl: bgUrl,title:title, text: text, time: time, counterStatusEnum: counterStatusEnum, isCountDown: isCountDown);
                        await stopAllActivity()
                        break
                    case .none:
                        requestLiveActivity(objectId: objectId,statusString: statusString,
                                            totalTomatees: totalTomatees,
                                            numTomatees: numTomatees,
                                            focusedDuration: focusedDuration,
                                            bgUrl: bgUrl,title:title, text: text, time: time, counterStatusEnum: counterStatusEnum, isCountDown: isCountDown);
                        break
                    }
                    
                    
                }else {
//                    await stopAllActivity()
                    startActivity(objectId: objectId, currentTimeStamp: currentTimeStamp, statusString: statusString,
                                  totalTomatees: totalTomatees,
                                  numTomatees: numTomatees,
                                  focusedDuration: focusedDuration,
                                  bgUrl: bgUrl,title:title, text: text, time: time, counterStatusEnum: counterStatusEnum, isCountDown: isCountDown, focusDurationInt: focusedDurationInt, restingDurationInt: restingDurationInt)
                }
//                } else {
//                    startActivity(objectId: objectId, currentTimeStamp: currentTimeStamp, statusString: statusString,
//                                  totalTomatees: totalTomatees,
//                                  numTomatees: numTomatees,
//                                  focusedDuration: focusedDuration,
//                                  bgUrl: bgUrl,title:title, text: text, time: time, counterStatusEnum: counterStatusEnum, isCountDown: isCountDown)
//                }
                       }
        }
        }
    
    // 更新 Activity
    func observeActivity() async {
        //        if Utility.isIpad() == false {
        if ActivityAuthorizationInfo().areActivitiesEnabled {
            
            // Observe updates for ongoing pizza delivery Live Activities.
            for await activity in Activity<IslandAttributes>.activityUpdates {
                print("Pizza delivery details: \(activity.attributes)")
            }
        }
        //        }
    }
}

