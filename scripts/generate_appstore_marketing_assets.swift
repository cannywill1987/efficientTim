import AppKit
import Foundation

// 生成 App Store 6.7 英寸竖屏截图。当前真实 App 主界面在模拟器中白屏，
// 因此这里使用运营 mock 数据绘制可提交预览图，并在素材说明中标注来源。

struct Slide {
    let filename: String
    let lang: String
    let badge: String
    let title: String
    let subtitle: String
    let screen: ScreenKind
}

enum ScreenKind {
    case dashboard
    case voice
    case today
    case focus
    case stats
}

let outputRoot = URL(fileURLWithPath: CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "docs/运营素材/feature/newUI/appstore")
let zhDir = outputRoot.appendingPathComponent("zh", isDirectory: true)
let enDir = outputRoot.appendingPathComponent("en", isDirectory: true)
try FileManager.default.createDirectory(at: zhDir, withIntermediateDirectories: true)
try FileManager.default.createDirectory(at: enDir, withIntermediateDirectories: true)

let canvas = CGSize(width: 1290, height: 2796)
let phone = CGRect(x: 208, y: 770, width: 874, height: 1720)
let red = NSColor(calibratedRed: 1.0, green: 0.23, blue: 0.29, alpha: 1)
let deep = NSColor(calibratedRed: 0.10, green: 0.10, blue: 0.13, alpha: 1)
let muted = NSColor(calibratedRed: 0.48, green: 0.49, blue: 0.55, alpha: 1)
let bg = NSColor(calibratedRed: 0.985, green: 0.976, blue: 0.965, alpha: 1)

let slides: [Slide] = [
    Slide(filename: "01-cn-home.png", lang: "zh", badge: "时间管理局 Todo", title: "把待办、日程、专注\n放进一个移动工作台", subtitle: "任务管理、番茄钟、复盘统计，一屏进入高效节奏。", screen: .dashboard),
    Slide(filename: "02-cn-voice-ai.png", lang: "zh", badge: "AI 语音创建", title: "说出来\n自动整理成任务", subtitle: "会议、灵感、临时安排，录音后由 AI 提取标题、时间与标签。", screen: .voice),
    Slide(filename: "03-cn-today.png", lang: "zh", badge: "今日清单", title: "今天要做什么\n一眼看清", subtitle: "按重要度、时间段和文件夹组织任务，减少反复翻找。", screen: .today),
    Slide(filename: "04-cn-focus.png", lang: "zh", badge: "专注计时", title: "让每个任务\n都有执行节奏", subtitle: "番茄钟与任务绑定，开始、休息、完成都可追踪。", screen: .focus),
    Slide(filename: "05-cn-stats.png", lang: "zh", badge: "时间复盘", title: "复盘时间投入\n找到真正的重点", subtitle: "按任务、文件夹和日期统计投入，帮助下一次计划更准确。", screen: .stats),
    Slide(filename: "01-en-home.png", lang: "en", badge: "Timerbell Todo", title: "Tasks, schedule and focus\nin one mobile workspace", subtitle: "Plan your day, start focused sessions and review where time goes.", screen: .dashboard),
    Slide(filename: "02-en-voice-ai.png", lang: "en", badge: "AI Voice Capture", title: "Speak it.\nTurn it into tasks.", subtitle: "Capture meetings, ideas and reminders, then let AI structure the next actions.", screen: .voice),
    Slide(filename: "03-en-today.png", lang: "en", badge: "Today List", title: "See today\nat a glance", subtitle: "Organize tasks by priority, time block and project without losing context.", screen: .today),
    Slide(filename: "04-en-focus.png", lang: "en", badge: "Focus Timer", title: "Give every task\na rhythm", subtitle: "Link Pomodoro sessions to tasks and keep execution measurable.", screen: .focus),
    Slide(filename: "05-en-stats.png", lang: "en", badge: "Time Review", title: "Review where\nyour time goes", subtitle: "Understand focus distribution by task, project and day.", screen: .stats),
]

func font(_ size: CGFloat, weight: NSFont.Weight = .regular) -> NSFont {
    NSFont.systemFont(ofSize: size, weight: weight)
}

func drawText(_ text: String, in rect: CGRect, size: CGFloat, weight: NSFont.Weight = .regular, color: NSColor = deep, align: NSTextAlignment = .left, lineHeight: CGFloat = 1.08) {
    let style = NSMutableParagraphStyle()
    style.alignment = align
    style.lineSpacing = size * (lineHeight - 1)
    let attrs: [NSAttributedString.Key: Any] = [
        .font: font(size, weight: weight),
        .foregroundColor: color,
        .paragraphStyle: style
    ]
    NSString(string: text).draw(in: rect, withAttributes: attrs)
}

func rounded(_ rect: CGRect, _ radius: CGFloat, _ color: NSColor) {
    color.setFill()
    NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius).fill()
}

func strokeRounded(_ rect: CGRect, _ radius: CGFloat, _ color: NSColor, _ width: CGFloat = 2) {
    color.setStroke()
    let path = NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius)
    path.lineWidth = width
    path.stroke()
}

func line(_ from: CGPoint, _ to: CGPoint, _ color: NSColor, _ width: CGFloat = 4) {
    color.setStroke()
    let path = NSBezierPath()
    path.move(to: from)
    path.line(to: to)
    path.lineWidth = width
    path.lineCapStyle = .round
    path.stroke()
}

func drawPhoneShell() {
    rounded(phone, 98, NSColor.black)
    let inner = phone.insetBy(dx: 22, dy: 22)
    rounded(inner, 76, NSColor.white)
    rounded(CGRect(x: phone.midX - 158, y: phone.minY + 38, width: 316, height: 44), 22, NSColor.black)
}

func phonePoint(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
    CGPoint(x: phone.minX + 56 + x, y: phone.minY + 118 + y)
}

func phoneRect(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat) -> CGRect {
    CGRect(x: phone.minX + 56 + x, y: phone.minY + 118 + y, width: w, height: h)
}

func drawTaskRow(_ y: CGFloat, title: String, meta: String, color: NSColor = red, done: Bool = false) {
    let rect = phoneRect(0, y, 762, 132)
    rounded(rect, 28, NSColor(calibratedWhite: 0.985, alpha: 1))
    strokeRounded(rect, 28, NSColor(calibratedWhite: 0.90, alpha: 1), 1)
    rounded(phoneRect(24, y + 40, 54, 54), 27, done ? NSColor(calibratedWhite: 0.86, alpha: 1) : color)
    if done {
        drawText("✓", in: phoneRect(34, y + 41, 40, 44), size: 34, weight: .bold, color: .white, align: .center)
    }
    drawText(title, in: phoneRect(104, y + 30, 470, 42), size: 29, weight: .semibold)
    drawText(meta, in: phoneRect(104, y + 76, 520, 34), size: 22, color: muted)
    rounded(phoneRect(642, y + 44, 86, 44), 22, NSColor(calibratedRed: 1, green: 0.91, blue: 0.92, alpha: 1))
    drawText("25m", in: phoneRect(646, y + 52, 78, 24), size: 20, weight: .medium, color: red, align: .center)
}

func drawDashboard(_ zh: Bool) {
    drawText(zh ? "今天" : "Today", in: phoneRect(0, 0, 240, 54), size: 42, weight: .bold)
    drawText(zh ? "5月21日  周四" : "Thu, May 21", in: phoneRect(0, 58, 360, 32), size: 23, color: muted)
    rounded(phoneRect(620, 4, 62, 62), 31, red)
    drawText("+", in: phoneRect(620, 2, 62, 60), size: 44, weight: .medium, color: .white, align: .center)
    rounded(phoneRect(0, 132, 762, 218), 36, NSColor(calibratedRed: 1, green: 0.945, blue: 0.946, alpha: 1))
    drawText(zh ? "今日计划" : "Daily Plan", in: phoneRect(34, 166, 300, 38), size: 28, weight: .semibold)
    drawText(zh ? "7 个任务 · 3 个专注番茄 · 2 个会议" : "7 tasks · 3 focus blocks · 2 meetings", in: phoneRect(34, 212, 520, 30), size: 23, color: muted)
    rounded(phoneRect(34, 272, 178, 46), 23, red)
    drawText(zh ? "开始专注" : "Start Focus", in: phoneRect(34, 282, 178, 26), size: 20, weight: .medium, color: .white, align: .center)
    drawTaskRow(410, title: zh ? "整理移动端任务需求" : "Refine mobile task spec", meta: zh ? "产品 · 今天 10:30" : "Product · 10:30 AM")
    drawTaskRow(566, title: zh ? "复盘本周专注时间" : "Review weekly focus time", meta: zh ? "复盘 · 下午" : "Review · Afternoon", color: NSColor.systemBlue)
    drawTaskRow(722, title: zh ? "准备 App Store 素材" : "Prepare App Store assets", meta: zh ? "运营 · 高优先级" : "Marketing · High priority", color: NSColor.systemGreen)
    drawTaskRow(878, title: zh ? "回复用户反馈" : "Reply to feedback", meta: zh ? "客服 · 25 分钟" : "Support · 25 min", color: NSColor.systemPurple)
}

func drawVoice(_ zh: Bool) {
    drawText(zh ? "说出你要做的事" : "Say what you need to do", in: phoneRect(0, 26, 762, 58), size: zh ? 40 : 36, weight: .bold, align: .center)
    rounded(phoneRect(88, 174, 586, 586), 293, NSColor(calibratedRed: 1, green: 0.925, blue: 0.93, alpha: 1))
    rounded(phoneRect(260, 346, 242, 242), 121, red)
    drawText("■", in: phoneRect(260, 400, 242, 120), size: 78, weight: .bold, color: .white, align: .center)
    for i in 0..<36 {
        let x = CGFloat(i) * 20
        let h = CGFloat((i % 7) * 7 + 16)
        line(phonePoint(38 + x, 848 - h / 2), phonePoint(38 + x, 848 + h / 2), i > 14 ? red : NSColor(calibratedWhite: 0.75, alpha: 1), 6)
    }
    drawText("00:12", in: phoneRect(0, 918, 762, 48), size: 34, weight: .medium, color: muted, align: .center)
    rounded(phoneRect(0, 1048, 762, 244), 34, NSColor(calibratedWhite: 0.985, alpha: 1))
    drawText(zh ? "AI 解析结果" : "AI Parsed Result", in: phoneRect(34, 1082, 420, 38), size: 28, weight: .semibold)
    drawText(zh ? "明天下午三点和设计师确认任务创建页，并补齐语音入口。" : "Tomorrow at 3 PM, review task creation with design and add the voice entry.", in: phoneRect(34, 1134, 690, 82), size: zh ? 27 : 25, color: deep)
    drawText(zh ? "时间：明天 15:00   标签：产品 / AI" : "Time: Tomorrow 3:00 PM   Tags: Product / AI", in: phoneRect(34, 1230, 690, 30), size: 21, color: muted)
}

func drawToday(_ zh: Bool) {
    drawText(zh ? "今日清单" : "Today List", in: phoneRect(0, 0, 400, 56), size: 42, weight: .bold)
    let tabs = zh ? ["全部", "工作", "学习", "生活"] : ["All", "Work", "Study", "Life"]
    for (idx, tab) in tabs.enumerated() {
        let x = CGFloat(idx) * 170
        rounded(phoneRect(x, 98, 142, 56), 28, idx == 0 ? red : NSColor(calibratedWhite: 0.94, alpha: 1))
        drawText(tab, in: phoneRect(x, 113, 142, 28), size: 21, weight: .medium, color: idx == 0 ? .white : deep, align: .center)
    }
    drawTaskRow(212, title: zh ? "确认新版任务创建流程" : "Confirm new task flow", meta: zh ? "高优先级 · 09:30" : "High priority · 09:30")
    drawTaskRow(368, title: zh ? "用语音补录会议纪要" : "Voice capture meeting notes", meta: zh ? "AI · 30 分钟" : "AI · 30 min", color: NSColor.systemPurple)
    drawTaskRow(524, title: zh ? "跟进 App Store 截图" : "Follow App Store screenshots", meta: zh ? "运营 · 今天" : "Marketing · Today", color: NSColor.systemGreen)
    drawTaskRow(680, title: zh ? "整理下周目标" : "Plan next week goals", meta: zh ? "计划 · 明天" : "Planning · Tomorrow", color: NSColor.systemBlue)
    drawTaskRow(836, title: zh ? "完成英文素材检查" : "Check English assets", meta: zh ? "已完成" : "Completed", color: NSColor.systemGray, done: true)
}

func drawFocus(_ zh: Bool) {
    drawText(zh ? "专注中" : "Focusing", in: phoneRect(0, 12, 762, 56), size: 42, weight: .bold, align: .center)
    rounded(phoneRect(126, 160, 510, 510), 255, NSColor(calibratedRed: 1, green: 0.94, blue: 0.945, alpha: 1))
    strokeRounded(phoneRect(156, 190, 450, 450), 225, red, 16)
    drawText("24:18", in: phoneRect(126, 335, 510, 92), size: 76, weight: .bold, color: red, align: .center)
    drawText(zh ? "确认移动端任务管理" : "Mobile task management", in: phoneRect(126, 440, 510, 42), size: 28, weight: .medium, align: .center)
    rounded(phoneRect(160, 746, 442, 78), 39, red)
    drawText(zh ? "暂停专注" : "Pause Focus", in: phoneRect(160, 766, 442, 36), size: 26, weight: .semibold, color: .white, align: .center)
    rounded(phoneRect(0, 936, 762, 230), 34, NSColor(calibratedWhite: 0.985, alpha: 1))
    drawText(zh ? "本轮目标" : "Session Goal", in: phoneRect(34, 970, 400, 38), size: 28, weight: .semibold)
    drawText(zh ? "把任务标题、时间、标签和语音入口全部确认完。" : "Confirm title, time, tags and voice entry for task creation.", in: phoneRect(34, 1026, 690, 72), size: zh ? 26 : 24, color: deep)
}

func drawStats(_ zh: Bool) {
    drawText(zh ? "时间复盘" : "Time Review", in: phoneRect(0, 0, 420, 56), size: 42, weight: .bold)
    rounded(phoneRect(0, 104, 762, 260), 34, NSColor(calibratedWhite: 0.985, alpha: 1))
    drawText(zh ? "本周专注" : "Focused This Week", in: phoneRect(34, 138, 360, 38), size: 27, weight: .semibold)
    drawText("18h 40m", in: phoneRect(34, 192, 360, 72), size: 60, weight: .bold, color: red)
    drawText(zh ? "比上周 +22%" : "+22% vs last week", in: phoneRect(34, 278, 360, 32), size: 23, color: muted)
    let bars: [CGFloat] = [118, 168, 132, 216, 188, 244, 154]
    for (idx, h) in bars.enumerated() {
        let x = CGFloat(idx) * 96
        rounded(phoneRect(52 + x, 720 - h, 44, h), 22, idx == 5 ? red : NSColor(calibratedRed: 1, green: 0.78, blue: 0.80, alpha: 1))
    }
    let labels = zh ? ["一", "二", "三", "四", "五", "六", "日"] : ["M", "T", "W", "T", "F", "S", "S"]
    for (idx, label) in labels.enumerated() {
        drawText(label, in: phoneRect(38 + CGFloat(idx) * 96, 746, 70, 28), size: 21, color: muted, align: .center)
    }
    rounded(phoneRect(0, 868, 762, 290), 34, NSColor(calibratedWhite: 0.985, alpha: 1))
    drawText(zh ? "时间分布" : "Time Distribution", in: phoneRect(34, 902, 400, 38), size: 28, weight: .semibold)
    let rows = zh ? [("产品设计", "42%"), ("学习成长", "28%"), ("运营发布", "18%"), ("生活事务", "12%")] : [("Product Design", "42%"), ("Learning", "28%"), ("Marketing", "18%"), ("Life Admin", "12%")]
    for (idx, row) in rows.enumerated() {
        let y = 964 + CGFloat(idx) * 48
        rounded(phoneRect(36, y + 8, 20, 20), 10, [red, NSColor.systemBlue, NSColor.systemGreen, NSColor.systemPurple][idx])
        drawText(row.0, in: phoneRect(72, y, 360, 32), size: 23, color: deep)
        drawText(row.1, in: phoneRect(620, y, 90, 32), size: 23, weight: .medium, color: muted, align: .right)
    }
}

func drawSlide(_ slide: Slide) {
    let image = NSImage(size: canvas)
    image.lockFocus()
    bg.setFill()
    CGRect(origin: .zero, size: canvas).fill()
    rounded(CGRect(x: -120, y: 1980, width: 1530, height: 900), 0, NSColor(calibratedRed: 1, green: 0.91, blue: 0.92, alpha: 1))
    rounded(CGRect(x: 88, y: 132, width: 342, height: 64), 32, NSColor(calibratedRed: 1, green: 0.91, blue: 0.92, alpha: 1))
    drawText(slide.badge, in: CGRect(x: 120, y: 148, width: 300, height: 32), size: 24, weight: .semibold, color: red)
    drawText(slide.title, in: CGRect(x: 88, y: 248, width: 1114, height: 245), size: slide.lang == "zh" ? 72 : 64, weight: .heavy, color: deep, lineHeight: 1.05)
    drawText(slide.subtitle, in: CGRect(x: 92, y: 520, width: 1000, height: 92), size: slide.lang == "zh" ? 32 : 30, weight: .regular, color: muted, lineHeight: 1.18)
    drawPhoneShell()
    let isZH = slide.lang == "zh"
    switch slide.screen {
    case .dashboard: drawDashboard(isZH)
    case .voice: drawVoice(isZH)
    case .today: drawToday(isZH)
    case .focus: drawFocus(isZH)
    case .stats: drawStats(isZH)
    }
    drawText(slide.lang == "zh" ? "时间管理局 Todo" : "Timerbell Todo", in: CGRect(x: 88, y: 2638, width: 500, height: 44), size: 26, weight: .semibold, color: muted)
    image.unlockFocus()
    guard let tiff = image.tiffRepresentation,
          let rep = NSBitmapImageRep(data: tiff),
          let data = rep.representation(using: .png, properties: [:]) else {
        fatalError("Cannot render \(slide.filename)")
    }
    let dir = slide.lang == "zh" ? zhDir : enDir
    try! data.write(to: dir.appendingPathComponent(slide.filename))
}

for slide in slides {
    drawSlide(slide)
}

print("Generated \(slides.count) App Store marketing images at \(outputRoot.path)")
