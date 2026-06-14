from pathlib import Path
import zipfile

from PIL import Image, ImageDraw, ImageEnhance, ImageFilter, ImageFont


ROOT = Path(__file__).resolve().parents[1]
DATE = "260525"
W, H = 1290, 2796
SCREEN_W, SCREEN_H = 760, 1648

GEN_SOURCE = ROOT / "genimage2-source" / "en-concept-260525" / "01-en-concept-wrapper-source.png"
SCREEN_OUT = ROOT / "concept-screenshots" / "en-demo-data-260525"
FINAL_OUT = ROOT / "appstore-en-concept-demo-data-260525" / "en"
PREVIEW_OUT = ROOT / "previews" / "en"
ZIP_PATH = ROOT / "efficienttime-en-concept-demo-data-260525.zip"

FONT_CANDIDATES = [
    "/System/Library/Fonts/Supplemental/Arial.ttf",
    "/System/Library/Fonts/Supplemental/Arial Bold.ttf",
    "/System/Library/Fonts/Helvetica.ttc",
    "/System/Library/Fonts/PingFang.ttc",
    "/Library/Fonts/Arial Unicode.ttf",
]


def font(size, bold=False):
    for path in FONT_CANDIDATES:
        if Path(path).exists():
            try:
                return ImageFont.truetype(path, size=size, index=1 if bold and path.endswith(".ttc") else 0)
            except OSError:
                continue
    return ImageFont.load_default()


def rounded(draw, box, radius, fill, outline=None, width=1):
    draw.rounded_rectangle(box, radius=radius, fill=fill, outline=outline, width=width)


def blend_with_white(color, ratio=0.86):
    return tuple(int(channel * (1 - ratio) + 255 * ratio) for channel in color[:3])


def text_width(draw, text, font_obj):
    box = draw.textbbox((0, 0), text, font=font_obj)
    return box[2] - box[0]


def draw_multiline(draw, text, x, y, font_obj, fill, max_width, line_gap=12, max_lines=None):
    words = text.split()
    lines = []
    current = ""
    for word in words:
        test = word if not current else f"{current} {word}"
        if text_width(draw, test, font_obj) <= max_width:
            current = test
        else:
            if current:
                lines.append(current)
            current = word
    if current:
        lines.append(current)

    if max_lines:
        lines = lines[:max_lines]

    for line in lines:
        draw.text((x, y), line, font=font_obj, fill=fill)
        y += font_obj.size + line_gap
    return y


def fit_cover(img, box_w, box_h):
    scale = max(box_w / img.width, box_h / img.height)
    nw, nh = int(img.width * scale), int(img.height * scale)
    resized = img.resize((nw, nh), Image.Resampling.LANCZOS)
    left = (nw - box_w) // 2
    top = (nh - box_h) // 2
    return resized.crop((left, top, left + box_w, top + box_h))


def paste_round(base, img, xy, radius):
    mask = Image.new("L", img.size, 0)
    md = ImageDraw.Draw(mask)
    md.rounded_rectangle((0, 0, img.width, img.height), radius=radius, fill=255)
    base.paste(img, xy, mask)


def app_background():
    img = Image.new("RGBA", (SCREEN_W, SCREEN_H), (249, 251, 248, 255))
    px = img.load()
    for y in range(SCREEN_H):
        t = y / (SCREEN_H - 1)
        r = int(249 * (1 - t) + 255 * t)
        g = int(251 * (1 - t) + 255 * t)
        b = int(248 * (1 - t) + 251 * t)
        for x in range(SCREEN_W):
            px[x, y] = (r, g, b, 255)
    return img


def status_bar(draw):
    draw.text((42, 34), "9:41", font=font(26, True), fill=(35, 39, 47, 255))
    x = SCREEN_W - 118
    rounded(draw, (x, 42, x + 48, 60), 6, (36, 40, 48, 255))
    rounded(draw, (x + 52, 46, x + 58, 56), 3, (36, 40, 48, 255))
    draw.arc((SCREEN_W - 178, 38, SCREEN_W - 142, 70), 210, 330, fill=(36, 40, 48, 255), width=4)
    draw.arc((SCREEN_W - 220, 36, SCREEN_W - 180, 74), 210, 330, fill=(36, 40, 48, 255), width=4)


def header(draw, title, subtitle, accent):
    rounded(draw, (40, 92, 116, 168), 28, (*accent, 255))
    draw.text((61, 112), "T", font=font(34, True), fill=(255, 255, 255, 255))
    draw.text((138, 96), title, font=font(42, True), fill=(25, 31, 42, 255))
    draw.text((140, 146), subtitle, font=font(24), fill=(110, 119, 133, 255))
    rounded(draw, (SCREEN_W - 126, 106, SCREEN_W - 50, 166), 30, (255, 255, 255, 235), outline=(229, 234, 226, 255), width=2)
    draw.text((SCREEN_W - 102, 122), "+", font=font(34, True), fill=(*accent, 255))


def bottom_nav(draw, active):
    labels = ["Today", "Focus", "Matrix", "Calendar", "Insights"]
    icons = ["●", "◐", "◇", "□", "▥"]
    y = SCREEN_H - 132
    rounded(draw, (36, y - 18, SCREEN_W - 36, SCREEN_H - 28), 42, (255, 255, 255, 245), outline=(230, 235, 226, 255), width=2)
    item_w = (SCREEN_W - 72) / 5
    for i, label in enumerate(labels):
        x = 36 + item_w * i
        is_active = label == active
        color = (45, 119, 74, 255) if is_active else (139, 147, 159, 255)
        if is_active:
            rounded(draw, (int(x + 18), y, int(x + item_w - 18), y + 76), 34, (231, 247, 235, 255))
        draw.text((int(x + item_w / 2 - 10), y + 12), icons[i], font=font(20), fill=color)
        tw = text_width(draw, label, font(17))
        draw.text((int(x + item_w / 2 - tw / 2), y + 40), label, font=font(17), fill=color)


def card(draw, box, fill=(255, 255, 255, 245), radius=30, outline=(230, 235, 226, 255)):
    rounded(draw, box, radius, fill, outline=outline, width=2)


def chip(draw, x, y, text, accent, pad_x=18):
    chip_font = font(19, True)
    tw = text_width(draw, text, chip_font)
    chip_fill = blend_with_white(accent, 0.82)
    chip_outline = blend_with_white(accent, 0.45)
    rounded(draw, (x, y, x + tw + pad_x * 2, y + 44), 22, (*chip_fill, 255), outline=(*chip_outline, 255), width=1)
    draw.text((x + pad_x, y + 11), text, font=chip_font, fill=(*accent[:3], 255))
    return x + tw + pad_x * 2 + 10


def task_row(draw, x, y, title, meta, accent, checked=False):
    card(draw, (x, y, SCREEN_W - 46, y + 126), fill=(255, 255, 255, 245), radius=28)
    outline = (*accent, 255) if checked else (202, 211, 204, 255)
    rounded(draw, (x + 22, y + 34, x + 70, y + 82), 24, (255, 255, 255, 255), outline=outline, width=4)
    if checked:
        draw.line((x + 33, y + 58, x + 46, y + 72, x + 64, y + 45), fill=(*accent, 255), width=5)
    draw.text((x + 88, y + 24), title, font=font(25, True), fill=(35, 40, 48, 255))
    draw.text((x + 88, y + 65), meta, font=font(20), fill=(112, 121, 136, 255))


def render_home():
    accent = (74, 160, 92)
    img = app_background()
    draw = ImageDraw.Draw(img)
    status_bar(draw)
    header(draw, "Today", "Plan your day with calm focus", accent)

    card(draw, (40, 210, SCREEN_W - 40, 436), fill=(239, 249, 240, 255), radius=36, outline=(210, 234, 213, 255))
    draw.text((72, 245), "Today's Progress", font=font(27, True), fill=(39, 61, 47, 255))
    draw.text((72, 292), "7 of 10 tasks done", font=font(50, True), fill=(26, 42, 32, 255))
    draw.text((74, 360), "Focus time 2h 35m  ·  Next: Design review", font=font(22), fill=(85, 111, 94, 255))
    rounded(draw, (74, 398, SCREEN_W - 74, 414), 8, (209, 226, 211, 255))
    rounded(draw, (74, 398, 74 + 450, 414), 8, (*accent, 255))

    card(draw, (40, 470, SCREEN_W - 40, 594), fill=(255, 255, 255, 248), radius=32)
    draw.text((72, 502), "Quick capture", font=font(26, True), fill=(35, 40, 48, 255))
    draw.text((72, 544), "Type or speak a task...", font=font(22), fill=(135, 145, 158, 255))
    rounded(draw, (SCREEN_W - 166, 500, SCREEN_W - 78, 566), 33, (255, 238, 230, 255))
    draw.text((SCREEN_W - 132, 517), "AI", font=font(24, True), fill=(218, 92, 61, 255))

    draw.text((44, 642), "Priority Tasks", font=font(30, True), fill=(30, 36, 45, 255))
    rows = [
        ("Finalize launch checklist", "Today · Work · 2 pomodoros", True),
        ("Design review with Maya", "10:30 AM · Product · High", False),
        ("Write onboarding notes", "Afternoon · Docs · Medium", False),
        ("Plan sprint backlog", "Tomorrow · Team · High", False),
    ]
    y = 696
    for title, meta, checked in rows:
        task_row(draw, 40, y, title, meta, accent, checked)
        y += 148
    bottom_nav(draw, "Today")
    return img


def render_voice():
    accent = (236, 105, 74)
    img = app_background()
    draw = ImageDraw.Draw(img)
    status_bar(draw)
    header(draw, "AI Voice Capture", "Speak naturally. Get structured tasks.", accent)

    card(draw, (40, 224, SCREEN_W - 40, 612), fill=(255, 246, 241, 255), radius=40, outline=(246, 220, 211, 255))
    draw.text((76, 264), "Listening", font=font(28, True), fill=(81, 51, 42, 255))
    draw.text((76, 316), "00:18", font=font(82, True), fill=(43, 32, 29, 255))
    base_y = 464
    for i, h in enumerate([34, 70, 46, 108, 64, 88, 38, 120, 58, 78, 44, 100, 62, 84, 36]):
        x = 76 + i * 40
        rounded(draw, (x, base_y - h // 2, x + 18, base_y + h // 2), 9, (*accent, 210))
    rounded(draw, (SCREEN_W - 218, 312, SCREEN_W - 82, 448), 68, (*accent, 255))
    draw.text((SCREEN_W - 171, 353), "●", font=font(42), fill=(255, 255, 255, 255))

    card(draw, (40, 660, SCREEN_W - 40, 890), fill=(255, 255, 255, 248), radius=34)
    draw.text((76, 696), "Transcript", font=font(28, True), fill=(34, 40, 49, 255))
    draw_multiline(
        draw,
        "Schedule a product review tomorrow at 10 AM, then remind me to send notes to the team.",
        76,
        744,
        font(24),
        (92, 102, 116, 255),
        SCREEN_W - 152,
        line_gap=12,
        max_lines=3,
    )

    draw.text((44, 940), "AI parsed tasks", font=font(30, True), fill=(30, 36, 45, 255))
    task_row(draw, 40, 994, "Product review", "Tomorrow 10:00 AM · Meeting", accent)
    task_row(draw, 40, 1142, "Send recap notes", "Tomorrow · Team · Reminder on", accent)
    rounded(draw, (72, 1334, SCREEN_W - 72, 1416), 41, (*accent, 255))
    draw.text((244, 1359), "Confirm and Create 2 Tasks", font=font(27, True), fill=(255, 255, 255, 255))
    bottom_nav(draw, "Today")
    return img


def render_focus():
    accent = (88, 128, 231)
    img = app_background()
    draw = ImageDraw.Draw(img)
    status_bar(draw)
    header(draw, "Focus Timer", "Turn tasks into steady progress", accent)

    card(draw, (54, 236, SCREEN_W - 54, 1010), fill=(244, 247, 255, 255), radius=52, outline=(218, 226, 248, 255))
    draw.ellipse((142, 332, SCREEN_W - 142, 948), outline=(213, 224, 250, 255), width=34)
    draw.arc((142, 332, SCREEN_W - 142, 948), -90, 194, fill=(*accent, 255), width=34)
    draw.text((234, 534), "18:42", font=font(112, True), fill=(29, 39, 68, 255))
    draw.text((286, 670), "Design App Store Screens", font=font(25, True), fill=(75, 88, 117, 255))
    rounded(draw, (230, 760, SCREEN_W - 230, 842), 41, (*accent, 255))
    draw.text((389, 785), "Pause Session", font=font(27, True), fill=(255, 255, 255, 255))

    metrics = [("3", "sessions"), ("1h 15m", "today"), ("82%", "completion")]
    x = 54
    for value, label in metrics:
        card(draw, (x, 1064, x + 224, 1228), fill=(255, 255, 255, 248), radius=30)
        draw.text((x + 34, 1100), value, font=font(40, True), fill=(35, 42, 58, 255))
        draw.text((x + 34, 1160), label, font=font(21), fill=(116, 126, 142, 255))
        x += 250

    draw.text((54, 1292), "Up next", font=font(30, True), fill=(30, 36, 45, 255))
    task_row(draw, 54, 1344, "Write release notes", "25 min · Focus queue", accent)
    bottom_nav(draw, "Focus")
    return img


def render_matrix():
    accent = (140, 168, 62)
    img = app_background()
    draw = ImageDraw.Draw(img)
    status_bar(draw)
    header(draw, "Priority Matrix", "Separate urgent from important", accent)

    labels = [
        ("Do First", "Launch checklist\nCustomer reply", (255, 242, 240)),
        ("Schedule", "Roadmap draft\nDesign review", (241, 249, 239)),
        ("Delegate", "Collect metrics\nExport assets", (244, 247, 255)),
        ("Later", "Archive notes\nTheme ideas", (255, 250, 235)),
    ]
    grid_x, grid_y = 40, 236
    cell_w, cell_h = 330, 454
    for i, (title, body, color) in enumerate(labels):
        col = i % 2
        row = i // 2
        x = grid_x + col * (cell_w + 22)
        y = grid_y + row * (cell_h + 22)
        card(draw, (x, y, x + cell_w, y + cell_h), fill=(*color, 255), radius=34, outline=(224, 231, 221, 255))
        draw.text((x + 28, y + 30), title, font=font(28, True), fill=(32, 38, 47, 255))
        yy = y + 96
        for line in body.split("\n"):
            rounded(draw, (x + 26, yy, x + cell_w - 26, yy + 78), 24, (255, 255, 255, 230))
            draw.text((x + 48, yy + 24), line, font=font(22), fill=(82, 91, 105, 255))
            yy += 96

    card(draw, (40, 1218, SCREEN_W - 40, 1410), fill=(255, 255, 255, 248), radius=32)
    draw.text((76, 1254), "Smart planning tip", font=font(28, True), fill=(34, 40, 49, 255))
    draw_multiline(draw, "Move low-value tasks out of today so your focus timer starts with the right priority.", 76, 1302, font(23), (97, 107, 122, 255), SCREEN_W - 152, max_lines=2)
    bottom_nav(draw, "Matrix")
    return img


def render_calendar():
    accent = (245, 171, 67)
    img = app_background()
    draw = ImageDraw.Draw(img)
    status_bar(draw)
    header(draw, "Calendar", "Plan tasks around real time", accent)

    card(draw, (40, 226, SCREEN_W - 40, 780), fill=(255, 252, 242, 255), radius=38, outline=(247, 230, 193, 255))
    draw.text((76, 264), "May 2026", font=font(34, True), fill=(46, 41, 31, 255))
    days = ["M", "T", "W", "T", "F", "S", "S"]
    start_x, start_y = 78, 334
    gap_x, gap_y = 92, 70
    for i, day in enumerate(days):
        draw.text((start_x + i * gap_x + 20, start_y), day, font=font(19, True), fill=(134, 119, 88, 255))
    n = 1
    for row in range(5):
        for col in range(7):
            x = start_x + col * gap_x
            y = start_y + 52 + row * gap_y
            if n in [7, 14, 25]:
                rounded(draw, (x, y, x + 54, y + 54), 27, (*accent, 255))
                fill = (255, 255, 255, 255)
            else:
                fill = (70, 64, 50, 255)
            draw.text((x + (16 if n < 10 else 9), y + 13), str(n), font=font(20, True), fill=fill)
            n += 1
            if n > 31:
                break

    draw.text((44, 838), "Today schedule", font=font(30, True), fill=(30, 36, 45, 255))
    schedule = [
        ("09:30", "Deep work: product copy", "Focus"),
        ("11:00", "Design QA review", "Team"),
        ("14:30", "Calendar cleanup", "Personal"),
        ("16:00", "Weekly planning", "Work"),
    ]
    y = 894
    for time, title, tag in schedule:
        card(draw, (40, y, SCREEN_W - 40, y + 120), fill=(255, 255, 255, 248), radius=28)
        draw.text((72, y + 32), time, font=font(24, True), fill=(*accent, 255))
        draw.text((164, y + 26), title, font=font(24, True), fill=(39, 45, 55, 255))
        draw.text((164, y + 66), tag, font=font(19), fill=(117, 127, 141, 255))
        y += 140
    bottom_nav(draw, "Calendar")
    return img


def render_insights():
    accent = (112, 104, 190)
    img = app_background()
    draw = ImageDraw.Draw(img)
    status_bar(draw)
    header(draw, "Insights", "Review where your time goes", accent)

    metrics = [("14h 20m", "focus time"), ("86%", "completion"), ("42", "tasks done"), ("5", "streak days")]
    x0, y0 = 40, 224
    for i, (value, label) in enumerate(metrics):
        col = i % 2
        row = i // 2
        x = x0 + col * 352
        y = y0 + row * 166
        card(draw, (x, y, x + 330, y + 142), fill=(255, 255, 255, 248), radius=30)
        draw.text((x + 30, y + 34), value, font=font(36, True), fill=(35, 42, 58, 255))
        draw.text((x + 30, y + 88), label, font=font(20), fill=(116, 126, 142, 255))

    card(draw, (40, 602, SCREEN_W - 40, 1036), fill=(248, 247, 255, 255), radius=38, outline=(224, 222, 244, 255))
    draw.text((76, 642), "Focus by day", font=font(30, True), fill=(39, 40, 60, 255))
    bars = [124, 206, 168, 254, 196, 300, 226]
    labels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    base = 956
    for i, h in enumerate(bars):
        x = 94 + i * 88
        rounded(draw, (x, base - h, x + 42, base), 21, (*accent, 210))
        draw.text((x - 6, base + 20), labels[i], font=font(17), fill=(106, 107, 132, 255))

    draw.text((44, 1102), "Recent wins", font=font(30, True), fill=(30, 36, 45, 255))
    task_row(draw, 40, 1154, "Finished launch checklist", "2h focus · Product", accent, checked=True)
    task_row(draw, 40, 1302, "Kept morning planning streak", "5 days · Personal", accent, checked=True)
    bottom_nav(draw, "Insights")
    return img


PAGES = [
    {
        "slug": "home",
        "title": "Plan every day",
        "subtitle": "Tasks, schedule, and focus sessions come together in a clean mobile workspace.",
        "badge": ["Tasks", "Today", "Planning"],
        "accent": (74, 160, 92),
        "screen": render_home,
    },
    {
        "slug": "voice-ai",
        "title": "Speak tasks into shape",
        "subtitle": "Capture ideas by voice and let AI turn them into structured to-dos.",
        "badge": ["AI Voice", "Fast Capture", "Tasks"],
        "accent": (236, 105, 74),
        "screen": render_voice,
    },
    {
        "slug": "focus",
        "title": "Focus with rhythm",
        "subtitle": "Use Pomodoro sessions to move important tasks forward one block at a time.",
        "badge": ["Focus Timer", "Pomodoro", "Flow"],
        "accent": (88, 128, 231),
        "screen": render_focus,
    },
    {
        "slug": "matrix",
        "title": "Prioritize what matters",
        "subtitle": "Use the Eisenhower matrix to separate urgent work from important goals.",
        "badge": ["Quadrants", "Priority", "Clarity"],
        "accent": (140, 168, 62),
        "screen": render_matrix,
    },
    {
        "slug": "calendar",
        "title": "Plan around time",
        "subtitle": "See tasks on a calendar and arrange your day before it gets crowded.",
        "badge": ["Calendar", "Schedule", "Reminders"],
        "accent": (245, 171, 67),
        "screen": render_calendar,
    },
    {
        "slug": "insights",
        "title": "Review your progress",
        "subtitle": "Understand focus time, completion rate, and task momentum with visual stats.",
        "badge": ["Insights", "Stats", "Review"],
        "accent": (112, 104, 190),
        "screen": render_insights,
    },
]


def package_background(accent):
    # Generation Image 生成图只作为外层包装纹理，内部 App UI 由脚本生成，便于控制英文文案与假数据。
    if GEN_SOURCE.exists():
        base = Image.open(GEN_SOURCE).convert("RGB")
        bg = fit_cover(base, W, H).convert("RGBA").filter(ImageFilter.GaussianBlur(10))
        bg = ImageEnhance.Color(bg).enhance(0.85)
        overlay = Image.new("RGBA", (W, H), (255, 255, 255, 188))
        bg.alpha_composite(overlay)
    else:
        bg = Image.new("RGBA", (W, H), (249, 251, 248, 255))

    draw = ImageDraw.Draw(bg)
    draw.rectangle((0, 0, 22, H), fill=(*accent, 255))
    draw.ellipse((-240, 120, 470, 830), fill=(*blend_with_white(accent, 0.72), 255))
    draw.ellipse((820, 1660, 1560, 2440), fill=(255, 255, 255, 255))
    rounded(draw, (70, 322, W - 70, 2242), 64, (255, 255, 255, 255), outline=(230, 235, 229, 255), width=2)
    return bg


def draw_phone(canvas, screen):
    draw = ImageDraw.Draw(canvas)
    phone_x, phone_y = (W - SCREEN_W) // 2, 538

    shadow = Image.new("RGBA", (SCREEN_W + 128, SCREEN_H + 128), (0, 0, 0, 0))
    sd = ImageDraw.Draw(shadow)
    sd.rounded_rectangle((64, 46, SCREEN_W + 64, SCREEN_H + 46), radius=96, fill=(24, 27, 34, 76))
    shadow = shadow.filter(ImageFilter.GaussianBlur(30))
    canvas.alpha_composite(shadow, (phone_x - 64, phone_y - 26))

    rounded(draw, (phone_x - 28, phone_y - 28, phone_x + SCREEN_W + 28, phone_y + SCREEN_H + 28), 96, (18, 18, 18, 255))
    rounded(draw, (phone_x, phone_y, phone_x + SCREEN_W, phone_y + SCREEN_H), 72, (255, 255, 255, 255))
    paste_round(canvas, screen, (phone_x, phone_y), 72)


def render_final(index, page):
    screen = page["screen"]().convert("RGBA")
    SCREEN_OUT.mkdir(parents=True, exist_ok=True)
    screen_path = SCREEN_OUT / f"{index:02d}-en-concept-{page['slug']}.png"
    screen.convert("RGB").save(screen_path, quality=95)

    canvas = package_background(page["accent"])
    draw = ImageDraw.Draw(canvas)

    draw.text((84, 90), "Timerbell Todo", font=font(36, True), fill=(54, 64, 78, 255))
    rounded(draw, (W - 420, 84, W - 82, 142), 29, (255, 255, 255, 235), outline=(224, 230, 224, 220), width=2)
    draw.text((W - 378, 101), "English concept only", font=font(22, True), fill=(99, 109, 124, 255))

    draw.text((84, 176), page["title"], font=font(72, True), fill=(24, 30, 42, 255))
    draw_multiline(draw, page["subtitle"], 88, 278, font(31), (86, 97, 114, 255), W - 176, line_gap=14, max_lines=2)

    draw_phone(canvas, screen)

    panel_y = 2264
    rounded(draw, (70, panel_y, W - 70, H - 92), 52, (255, 255, 255, 232), outline=(228, 234, 228, 185), width=2)
    draw.text((112, panel_y + 58), "Best for", font=font(27, True), fill=(92, 103, 119, 255))
    x = 112
    y = panel_y + 122
    for label in page["badge"]:
        x = chip(draw, x, y, label, page["accent"], pad_x=26)
    draw.text((112, H - 176), "AI concept UI with demo data. Replace with real English app screenshots before submission.", font=font(25), fill=(112, 123, 140, 255))

    FINAL_OUT.mkdir(parents=True, exist_ok=True)
    final_path = FINAL_OUT / f"{index:02d}-en-concept-{page['slug']}-1290x2796.png"
    canvas.convert("RGB").save(final_path, quality=95)
    return screen_path, final_path


def render_preview(final_paths):
    PREVIEW_OUT.mkdir(parents=True, exist_ok=True)
    thumb_w = 258
    thumb_h = int(thumb_w * H / W)
    cols = 3
    gap = 22
    margin = 34
    preview = Image.new("RGB", (margin * 2 + cols * thumb_w + (cols - 1) * gap, margin * 2 + 2 * thumb_h + gap), (246, 248, 245))
    for i, path in enumerate(final_paths):
        img = Image.open(path).convert("RGB").resize((thumb_w, thumb_h), Image.Resampling.LANCZOS)
        x = margin + (i % cols) * (thumb_w + gap)
        y = margin + (i // cols) * (thumb_h + gap)
        preview.paste(img, (x, y))
    preview_path = PREVIEW_OUT / "appstore-en-concept-demo-data-260525-preview.png"
    preview.save(preview_path, quality=95)
    return preview_path


def main():
    generated_screens = []
    generated_finals = []
    for index, page in enumerate(PAGES, 1):
        screen_path, final_path = render_final(index, page)
        generated_screens.append(screen_path)
        generated_finals.append(final_path)

    preview_path = render_preview(generated_finals)

    with zipfile.ZipFile(ZIP_PATH, "w", compression=zipfile.ZIP_DEFLATED) as zf:
        for path in generated_screens + generated_finals + [preview_path, GEN_SOURCE]:
            if path.exists():
                zf.write(path, path.relative_to(ROOT))

    print("\n".join(str(path) for path in generated_finals))
    print(preview_path)
    print(ZIP_PATH)


if __name__ == "__main__":
    main()
