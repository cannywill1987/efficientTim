//
//  Onboarding0VM.swift
//  sunghoyazaza
//
//  Created by Yun Dongbeom on 2023/05/13.
//

import SwiftUI

class Onboarding0VM: ObservableObject {
    
    init() {
        self.carouselItems = [
            /// 0
            CarouselItemInfo(
                idx: 0,
                labelTitle: "与Must Sleep一起\n在该睡觉的时间入睡\n并坚持明天的计划",
                labelBody: "",
                src: "mustSleep_onboarding_0"
            ),
            /// 1
            CarouselItemInfo(
                idx: 1,
                labelTitle: "⚙️ 设置睡眠计划",
                labelBody: "⏰ 睡眠例程：选择睡眠时间和日期\n⚠️ 限制应用：选择可能会打扰你的应用",
                src: "mustSleep_onboarding_1"
            ),
            /// 2
            CarouselItemInfo(
                idx: 2,
                labelTitle: "😴 执行睡眠计划",
                labelBody: "当到达‘睡眠例程’的时间时，\n‘限制应用’的应用将被限制",
                src: "mustSleep_onboarding_2"
            ),
            /// 3
            CarouselItemInfo(
                idx: 3,
                labelTitle: "🔥 查看连续达成记录",
                labelBody: "你可以查看你连续几次在该睡觉的时间入睡，\n以及当前正在达成的记录",
                src: "mustSleep_onboarding_3"
            ),
            /// 4
            CarouselItemInfo(
                idx: 4,
                labelTitle: "⏳ 只有15分钟！",
                labelBody: "如果你觉得忍受不使用限制的应用太难，\n我们可以约定只使用15分钟\n但是，当前正在达成的记录将被打破",
                src: "mustSleep_onboarding_4"
            ),
            /// 5
            CarouselItemInfo(
                idx: 5,
                labelTitle: "如果Must Sleep要在该睡觉的时间帮助你入睡，\n需要对一些功能进行权限设置\n设置权限并坚持明天的计划",
                labelBody: "",
                src: "mustSleep_onboarding_5"
            )
        ]
    }

    @Published
    var carouselItems: [CarouselItemInfo]
}
