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
import Flutter
import UIKit
import ActivityKit

@available(iOS 16.1, *)
class LiveActivityManager {
    static let instance:LiveActivityManager = LiveActivityManager()
    var activity: Activity<IslandAttributes>?;
    var isLaunching: Bool = false;
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
                       bgUrl: String,title: String, text: String, time: Int, counterStatusEnum: CounterStatusEnum, isCountDown: Bool) {
        //async要用await方法
//        Task {
//             await observeActivity()
//        }
        if Utility.isIpad() == false {
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
                        title:title, text: text, value: 3, startTime: Date().addingTimeInterval(TimeInterval(time / 1000)), deliveryTimer: Date.now...(Calendar.current.date(byAdding: Calendar.Component.second, value: (time / 1000 ?? 0), to: Date()) ?? Date.now), counterStatusEnum: counterStatusEnum.rawValue ?? 6, isCountDown: isCountDown);
                    //            Task {
                    //                await self.activity?.update(using: state)
                    //            }
                    
                    let attr = IslandAttributes(currentTimeStamp: currentTimeStamp, time: time, objectId: objectId, name: "test", counterStatusEnum: counterStatusEnum.rawValue ?? 6)
                    
                    do {
                        self.activity = try Activity.request(attributes: attr, contentState: state, pushType: nil)
                    } catch { // 加入一个空的catch，用于关闭catch。否则会报错：Errors thrown from here are not handled because the enclosing catch is not exhaustive
                        print("err \(error)")
                    }
                    
                } else {
                    stopActivity();
                }
            }
        }
        //        }
    }
    
    @objc func stopActivity() {
        if Utility.isIpad() == false {
            
            if ActivityAuthorizationInfo().areActivitiesEnabled {
                
                
                if let activity = self.activity {
                    
                    let state = IslandAttributes.ContentState(statusString: "",
                                                              totalTomatees: 0,
                                                              numTomatees: 0,
                                                              focusedDuration: "0mins",
                                                              bgUrl: "", title:"", text: "", value: 3, startTime: Date().addingTimeInterval(60 * 5), deliveryTimer: Date.now...(Calendar.current.date(byAdding: Calendar.Component.second, value: (Int(1000) ?? 0), to: Date()) ?? Date.now), counterStatusEnum: 0, isCountDown: true);
                    
                    
                    Task {
                        await self.activity?.end(using:state, dismissalPolicy: .immediate)
                        self.activity = nil
                    }
                }
            }
        }
    }
    
    func requestLiveActivity(statusString: String,
                             totalTomatees: Int,
                             numTomatees: Int,
                             focusedDuration: String,
                             bgUrl: String,title: String, text: String, time: Int, counterStatusEnum: CounterStatusEnum, isCountDown: Bool) {
        if Utility.isIpad() == false {
            
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
                                                          bgUrl: bgUrl,title:title, text:text, value: 3, startTime: Date().addingTimeInterval(TimeInterval(time / 1000)), deliveryTimer: Date.now...(Calendar.current.date(byAdding: Calendar.Component.second, value: (time / 1000 ?? 0), to: Date()) ?? Date.now), counterStatusEnum: counterStatusEnum.rawValue ?? 6, isCountDown: countDown);
                Task {
                    await self.activity?.update(using: state)
                }
            } else {
                print("~~~~~~~~~~~~~~~~~~time \(time) and \(counterStatusEnum.rawValue) \(counterStatusEnum)")
                let state = IslandAttributes.ContentState(statusString: statusString,
                                                          totalTomatees: totalTomatees,
                                                          numTomatees: numTomatees,
                                                          focusedDuration: focusedDuration,
                                                          bgUrl: bgUrl,title:title, text:text, value: 3, startTime: Date().addingTimeInterval(TimeInterval(time / 1000)), deliveryTimer: (Calendar.current.date(byAdding: Calendar.Component.second, value: -(time / 1000 ?? 0), to: Date()) ?? Date.now)...(Calendar.current.date(byAdding: Calendar.Component.second, value: 1000 * 1000 * 1000 + (time / 1000 ?? 0), to: Date()) ?? Date.now), counterStatusEnum: counterStatusEnum.rawValue ?? 6, isCountDown: countDown);
                Task {
                    await self.activity?.update(using: state)
                }
            }
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
        title: String,text: String, isCountDown: Bool ,time: Int, counterStatusEnum: CounterStatusEnum) {
            //        print("~~~~~~~~~~~~~~~~~~time \(time) and \(counterStatusEnum.rawValue) ")
            if Utility.isIpad() == false {
                if ActivityAuthorizationInfo().areActivitiesEnabled {
                    if self.activity != nil {
                        switch counterStatusEnum {
                        case .focusing:
                            if(self.isLaunching == true) {
                                return;
                            }
                            self.isLaunching = true;
                            requestLiveActivity(statusString: statusString,
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
                            stopActivity();
                            break
                        case .relaxing:
                            if(self.isLaunching == true) {
                                return;
                            }
                            self.isLaunching = true;
                            requestLiveActivity(statusString: statusString,
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
                            stopActivity()
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
                            stopActivity()
                            self.isLaunching = false;
                            break
                        case .pausingRelaixing:
                            //                        requestLiveActivity(statusString: statusString,
                            //                                            totalTomatees: totalTomatees,
                            //                                            numTomatees: numTomatees,
                            //                                            focusedDuration: focusedDuration,
                            //                                            bgUrl: bgUrl,title:title, text: text, time: time, counterStatusEnum: counterStatusEnum, isCountDown: isCountDown);
                            stopActivity()
                            break
                        case .none:
                            requestLiveActivity(statusString: statusString,
                                                totalTomatees: totalTomatees,
                                                numTomatees: numTomatees,
                                                focusedDuration: focusedDuration,
                                                bgUrl: bgUrl,title:title, text: text, time: time, counterStatusEnum: counterStatusEnum, isCountDown: isCountDown);
                            break
                        }
                        
                        
                    }else {
                        startActivity(objectId: objectId, currentTimeStamp: currentTimeStamp, statusString: statusString,
                                      totalTomatees: totalTomatees,
                                      numTomatees: numTomatees,
                                      focusedDuration: focusedDuration,
                                      bgUrl: bgUrl,title:title, text: text, time: time, counterStatusEnum: counterStatusEnum, isCountDown: isCountDown)
                    }
                }
            }
        }
    
    // 更新 Activity
    func observeActivity() async {
        if Utility.isIpad() == false {
            if ActivityAuthorizationInfo().areActivitiesEnabled {
                
                // Observe updates for ongoing pizza delivery Live Activities.
                for await activity in Activity<IslandAttributes>.activityUpdates {
                    print("Pizza delivery details: \(activity.attributes)")
                }
            }
        }
    }
}

