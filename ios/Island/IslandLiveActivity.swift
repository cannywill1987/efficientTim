//
//  IslandLiveActivity.swift
//  Island
//
//  Created by 林智彬 on 2023/4/12.
//

import ActivityKit
import WidgetKit
import SwiftUI

//case focusing=0 //专注中 红色计时中
//case pausingFucusing=1 //专注暂停中
//case relaxing=2 //休息中 蓝色计时中
//case waitingToFocus=3 //等待专注中
//case waitingToStartRelaxing=4 //等待休息启动
//case pausingRelaixing=5 //暂停休息中
//case none=6 //没任何选择
@available(iOS 16.1, *)
struct TimerActivityView: View {
    let context: ActivityViewContext<IslandAttributes>
    @State private var isRunning = false // Add boolean variable
    @Environment(\.colorScheme) var colorScheme
    var btnWidth:CGFloat = 77;
    var fontSize:CGFloat = 13;
    var body: some View {
        ZStack {
            // Left section
            VStack(alignment: .leading, spacing: 5) {
                Text(context.state.title)
                    .font(.system(size: 14)) // Set title font size to 12
                if(context.state.counterStatusEnum == 0 || context.state.counterStatusEnum == 2) {
                    if(context.state.isCountDown) {
                        Text(timerInterval: context.state.deliveryTimer!, countsDown: context.state.isCountDown)
                            .font(.system(size: 25)).fontWeight(.bold) // Set time
                            .font(.caption2)
                    } else {
                        Text(timerInterval: context.state.deliveryTimer!, countsDown: context.state.isCountDown)
                            .font(.system(size: 30)).fontWeight(.bold) // Set time
                            .font(.caption2)
                    }
                } else {
                    Text(context.state.text)
                        .font(.system(size: 30)).fontWeight(.bold) // Set time
                        .font(.caption2)
                }
                Divider()
                HStack {
                    Image("focusing")
                        .resizable().aspectRatio(contentMode: .fit).frame(width: 20, height: 20)
                        .aspectRatio(contentMode: ContentMode.fit)
                    Text("\(context.state.numTomatees)")
                        .font(.system(size: 14)).padding(.trailing, 5)
                    Divider().background(colorScheme == .dark ? Color.white : Color(#colorLiteral(red: 0.56, green: 0.51, blue: 0.45, alpha: 1)) )
                    Image("resting")
                        .resizable().aspectRatio(contentMode: .fit).frame(width: 20, height: 20)
                    
                        .aspectRatio(contentMode: ContentMode.fit)
                    //                        .clipShape(Circle())
                    Text("\(context.state.totalTomatees)")
                        .font(.system(size: 14)).padding(.trailing, 5)
                    Divider().background(colorScheme == .dark ? Color.white : Color(#colorLiteral(red: 0.56, green: 0.51, blue: 0.45, alpha: 1)) )
                    Text(context.state.focusedDuration)
                        .font(.system(size: 14))
                }
            }
            // Right section
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    if(context.state.counterStatusEnum == 0) { //focusing
                        ZStack {
                            Color(.sRGB,red: 220/255.0, green: 204/255.0, blue: 182/255.0, opacity: 0.3)
                                .frame(width: btnWidth, height: 40)
                                .cornerRadius(30)
                                .blur(radius: 1, opaque: false)
                            Button(action: {
                                NotificationCenter.default.post(name: NSNotification.Name( "ACTION_BTN_CLICK") , object: self, userInfo: ["action": "handleStatusBarPauseBtn"]);
                            }) {
                                Text("Pause")
                                    .foregroundColor(colorScheme == .dark ? Color.white : Color(#colorLiteral(red: 0.56, green: 0.51, blue: 0.45, alpha: 1)) )
                                //                        .background()
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 0)
                                    .font(.system(size: fontSize, weight: .bold))
                                    .cornerRadius(10)
                            }
                            .widgetURL(URL(string: "http://www.apple.com"))
                            .disabled(false)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .frame(width: 60)
                        }.padding(.trailing, 5)
                    } else  if(context.state.counterStatusEnum == 1) { //pausingFucusing
                        ZStack {
                            Color(.sRGB,red: 220/255.0, green: 204/255.0, blue: 182/255.0, opacity: 0.3)
                                .frame(width: btnWidth, height: 40)
                                .cornerRadius(30)
                                .blur(radius: 1, opaque: false)
                            Button(action: {
                                NotificationCenter.default.post(name: NSNotification.Name( "ACTION_BTN_CLICK") , object: self, userInfo: ["action": "handleStatusBarStartBtn"]);
                            }) {
                                Text("Continue")
                                    .foregroundColor(colorScheme == .dark ? Color.white : Color(#colorLiteral(red: 0.56, green: 0.51, blue: 0.45, alpha: 1)) )
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 0)
                                    .font(.system(size: fontSize, weight: .bold))
                                    .cornerRadius(10)
                            }
                            .widgetURL(URL(string: "http://www.apple.com"))
                            .disabled(false)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .frame(width: 60)
                        }.padding(.trailing, 5)
                        ZStack {
                            Color(.sRGB,red: 220/255.0, green: 204/255.0, blue: 182/255.0, opacity: 0.3)
                                .frame(width: btnWidth, height: 40)
                                .cornerRadius(30)
                                .blur(radius: 1, opaque: false)
                            Button(action: {
                                NotificationCenter.default.post(name: NSNotification.Name( "ACTION_BTN_CLICK") , object: self, userInfo: ["action": "handleStatusBarStopBtn"]);
                            }) {
                                Text("Stop")
                                    .foregroundColor(colorScheme == .dark ? Color.white : Color(#colorLiteral(red: 0.56, green: 0.51, blue: 0.45, alpha: 1)) )
                                
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 0)
                                    .font(.system(size: fontSize, weight: .bold))
                                    .cornerRadius(10)
                            }
                            .widgetURL(URL(string: "http://www.apple.com"))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .frame(width: 60)
                        }.padding(.trailing, 5)
                        
                    } else  if(context.state.counterStatusEnum == 2) { //relaxing
                        ZStack {
                            Color(.sRGB,red: 220/255.0, green: 204/255.0, blue: 182/255.0, opacity: 0.3)
                                .frame(width: btnWidth, height: 40)
                                .cornerRadius(30)
                                .blur(radius: 1, opaque: false)
                            Button(action: {
                                NotificationCenter.default.post(name: NSNotification.Name( "ACTION_BTN_CLICK") , object: self, userInfo: ["action": "handleStatusBarDoneBtn"]);
                            }) {
                                Text("Done")
                                    .foregroundColor(colorScheme == .dark ? Color.white : Color(#colorLiteral(red: 0.56, green: 0.51, blue: 0.45, alpha: 1)) )
                                //                        .background()
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 0)
                                    .font(.system(size: fontSize, weight: .bold))
                                    .cornerRadius(10)
                            }
                            .widgetURL(URL(string: "http://www.apple.com"))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .frame(width: 60)
                        }.padding(.trailing, 5)
                    } else  if(context.state.counterStatusEnum == 3) { //waitingToFocus
                        ZStack {
                            Color(.sRGB,red: 220/255.0, green: 204/255.0, blue: 182/255.0, opacity: 0.3)
                                .frame(width: btnWidth, height: 40)
                                .cornerRadius(30)
                                .blur(radius: 1, opaque: false)
                            Button(action: {
                                NotificationCenter.default.post(name: NSNotification.Name( "ACTION_BTN_CLICK") , object: self, userInfo: ["action": "handleStatusBarStartBtn"]);
                            }) {
                                Text("Start")
                                    .foregroundColor(colorScheme == .dark ? Color.white : Color(#colorLiteral(red: 0.56, green: 0.51, blue: 0.45, alpha: 1)) )
                                //                        .background()
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 0)
                                    .font(.system(size: fontSize, weight: .bold))
                                    .cornerRadius(10)
                            }
                            .widgetURL(URL(string: "http://www.apple.com"))
                            .disabled(false)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .frame(width: 60)
                        }.padding(.trailing, 5)
                    } else  if(context.state.counterStatusEnum == 4) { // waitingToStartRelaxing
                        ZStack {
                            Color(.sRGB,red: 220/255.0, green: 204/255.0, blue: 182/255.0, opacity: 0.3)
                                .frame(width: btnWidth, height: 40)
                                .cornerRadius(30)
                                .blur(radius: 1, opaque: false)
                            Button(action: {
                                NotificationCenter.default.post(name: NSNotification.Name( "ACTION_BTN_CLICK") , object: self, userInfo: ["action": "handleStatusBarStartBtn"]);

                            }) {
                                Text("Start")
                                    .foregroundColor(colorScheme == .dark ? Color.white : Color(#colorLiteral(red: 0.56, green: 0.51, blue: 0.45, alpha: 1)) )
                                //                        .background()
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 0)
                                    .font(.system(size: fontSize, weight: .bold))
                                    .cornerRadius(10)
                            }
                            .widgetURL(URL(string: "http://www.apple.com"))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .frame(width: 60)
                        }.padding(.trailing, 5)
                    } else  if(context.state.counterStatusEnum == 5) { //pausingRelaixing
                    }
                    
                }.frame(height: 60)
                    .padding(.vertical, 10)
                    .padding(.bottom, 35)
            }
            .frame(height: 50)
            .padding(.vertical, 10)
            .padding(.horizontal, 0)
        }.padding(.vertical, 16)
            .padding(.leading, 10).padding(.trailing,5)
        
    }
}

/**
 参考
 http://swiftcafe.io/post/dy-island
 */
struct IslandAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var statusString: String
        var  totalTomatees: Int
        var numTomatees: Int
        var focusedDuration: String
        var bgUrl: String
        var title: String
        var text: String
        var value: Int
        var startTime: Date
        var deliveryTimer: ClosedRange<Date>?
        var counterStatusEnum: Int
        var isCountDown: Bool
        
        
    }
    var numberOfPizzas: Int?
    var currentTimeStamp: Int?
    var time: Int?
    var objectId: String?
    // Fixed non-changing properties about your activity go here!
    var name: String
    var counterStatusEnum: Int?

}

@available(iOS 16.1, *)
struct IslandLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: IslandAttributes.self) { context in
            // Lock screen/banner UI goes here
            //锁屏界面
            TimerActivityView(context: context)
            //            VStack {
            //                Text("Hello")
            //            }
            //            .activityBackgroundTint(Color.cyan)
            //            .activitySystemActionForegroundColor(Color.black)
            
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Label {
                        Text(context.state.title).lineLimit(1)
                    } icon: {
                        if(context.state.counterStatusEnum == 0 || context.state.counterStatusEnum == 1 || context.state.counterStatusEnum == 3) {
                            Image("focusing")
                                .resizable().aspectRatio(contentMode: .fit).frame(width: 20, height: 20)
                        } else {
                            Image("resting")
                                .resizable().aspectRatio(contentMode: .fit).frame(width: 20, height: 20)
                        }
                        
                    }
                    .font(.caption2)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.startTime, style: .timer)
                        .multilineTextAlignment(.center)
                        .frame(width: 40)
                        .foregroundColor(Color(#colorLiteral(red: 0.56, green: 0.51, blue: 0.45, alpha: 1)))
                        .font(.caption2)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    TimerActivityView(context: context)
                    //                    Text("Bottom")
                    // more content
                }
            } compactLeading: { //灵动岛 左边 右边
                if(context.state.counterStatusEnum == 0 || context.state.counterStatusEnum == 1 || context.state.counterStatusEnum == 3) {
                    Image("focusing")
                        .resizable().aspectRatio(contentMode: .fit).frame(width: 20, height: 20)
                } else {
                    Image("resting")
                        .resizable().aspectRatio(contentMode: .fit).frame(width: 20, height: 20)
                }
            } compactTrailing: {
                //                var countdown: Bool = false; //开始计时
                //case focusing=0 //专注中 红色计时中
                //case pausingFucusing=1 //专注暂停中
                //case relaxing=2 //休息中 蓝色计时中
                //case waitingToFocus=3 //等待专注中
                //case waitingToStartRelaxing=4 //等待休息启动
                //case pausingRelaixing=5 //暂停休息中
                //case none=6 //没任何选择
                
                if(context.state.counterStatusEnum == 0 || context.state.counterStatusEnum == 2) {
                    if(context.state.isCountDown) {
                        Text(timerInterval: context.state.deliveryTimer!, countsDown: context.state.isCountDown)
                            .multilineTextAlignment(.center)
                            .frame(width: 40)
                            .font(.caption2)
                    } else {
                        Text(timerInterval: context.state.deliveryTimer!, countsDown: context.state.isCountDown)
                            .multilineTextAlignment(.center)
                            .frame(width: 40)
                            .font(.caption2)
                    }
                } else {
                    Text(context.state.text)
                        .multilineTextAlignment(.center)
                        .frame(width: 40)
                        .font(.caption2)
                }
            } minimal: {
                //                Text("Min") //最最小状态
                
                if(context.state.counterStatusEnum == 0 || context.state.counterStatusEnum == 2) {
                    if(context.state.isCountDown) {
                        
                        VStack(alignment: .center) {
                            Image(systemName: "timer")
                            Text(timerInterval: context.state.deliveryTimer!, countsDown: context.state.isCountDown)
                                .multilineTextAlignment(.center)
                                .monospacedDigit()
                                .font(.caption2)
                        }
                    } else {
                        VStack(alignment: .center) {
                            Image(systemName: "timer")
                            Text(timerInterval: context.state.deliveryTimer!, countsDown: context.state.isCountDown)
                                .multilineTextAlignment(.center)
                                .monospacedDigit()
                                .font(.caption2)
                        }
                    }
                } else {
                    VStack(alignment: .center) {
                        Image(systemName: "timer")
                        Text(timerInterval: context.state.deliveryTimer!, countsDown: context.state.isCountDown)
                            .multilineTextAlignment(.center)
                            .monospacedDigit()
                            .font(.caption2)
                    }
                }
//                VStack(alignment: .center) {
////                    Image(systemName: "timer")
//                    Text(timerInterval: context.state.deliveryTimer!, countsDown: true)
//                        .multilineTextAlignment(.center)
//                        .monospacedDigit()
//                        .font(.caption2)
//                }
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

@available(iOS 16.2, *)
struct IslandLiveActivity_Previews: PreviewProvider {
    static let attributes = IslandAttributes(numberOfPizzas:123, name: "Me")
    
    static let contentState = IslandAttributes.ContentState(statusString: "",
                                                            totalTomatees: 0,
                                                            numTomatees: 0,
                                                            focusedDuration: "0mins",
                                                            bgUrl: "", title: "", text: "", value: 3, startTime: Date().addingTimeInterval(60 * 5), deliveryTimer: Date.now...(Calendar.current.date(byAdding: Calendar.Component.second, value: (Int(1000) ?? 0), to: Date()) ?? Date.now), counterStatusEnum: 6, isCountDown: true)
    
    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
    }
}
