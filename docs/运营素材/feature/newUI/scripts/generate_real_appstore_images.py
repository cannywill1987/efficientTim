from pathlib import Path
from PIL import Image, ImageDraw, ImageFont, ImageFilter
import zipfile

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "real-screenshots" / "zh"
OUT = ROOT / "appstore-real"
W, H = 1284, 2778

FONT_CANDIDATES = [
    "/System/Library/Fonts/PingFang.ttc",
    "/System/Library/Fonts/STHeiti Light.ttc",
    "/System/Library/Fonts/Supplemental/Arial Unicode.ttf",
    "/Library/Fonts/Arial Unicode.ttf",
]


def font(size, bold=False):
    for path in FONT_CANDIDATES:
        if Path(path).exists():
            return ImageFont.truetype(path, size=size, index=0)
    return ImageFont.load_default()


def draw_round_rect(draw, xy, radius, fill, outline=None, width=1):
    draw.rounded_rectangle(xy, radius=radius, fill=fill, outline=outline, width=width)


def fit_cover(img, box_w, box_h):
    scale = max(box_w / img.width, box_h / img.height)
    nw, nh = int(img.width * scale), int(img.height * scale)
    resized = img.resize((nw, nh), Image.Resampling.LANCZOS)
    left = (nw - box_w) // 2
    top = (nh - box_h) // 2
    return resized.crop((left, top, left + box_w, top + box_h))


def fit_contain(img, box_w, box_h):
    scale = min(box_w / img.width, box_h / img.height)
    nw, nh = int(img.width * scale), int(img.height * scale)
    return img.resize((nw, nh), Image.Resampling.LANCZOS)


def paste_round(base, img, xy, radius):
    mask = Image.new("L", img.size, 0)
    md = ImageDraw.Draw(mask)
    md.rounded_rectangle((0, 0, img.width, img.height), radius=radius, fill=255)
    base.paste(img, xy, mask)


def text_width(draw, text, font_obj):
    box = draw.textbbox((0, 0), text, font=font_obj)
    return box[2] - box[0]


def is_mostly_ascii(text):
    chars = [ch for ch in text if not ch.isspace()]
    if not chars:
        return False
    return sum(1 for ch in chars if ord(ch) < 128) / len(chars) > 0.75


def multiline(draw, text, x, y, font_obj, fill, max_width, line_gap=14):
    lines = []
    if is_mostly_ascii(text):
        current = ""
        for word in text.split():
            test = word if not current else f"{current} {word}"
            if text_width(draw, test, font_obj) <= max_width:
                current = test
            else:
                if current:
                    lines.append(current)
                current = word
    else:
        current = ""
        for ch in text:
            test = current + ch
            if text_width(draw, test, font_obj) <= max_width:
                current = test
            else:
                if current:
                    lines.append(current)
                current = ch
    if current:
        lines.append(current)
    for line in lines:
        draw.text((x, y), line, font=font_obj, fill=fill)
        y += font_obj.size + line_gap
    return y


def make_gradient(top, bottom):
    img = Image.new("RGB", (W, H), top)
    px = img.load()
    for y in range(H):
        t = y / (H - 1)
        r = int(top[0] * (1 - t) + bottom[0] * t)
        g = int(top[1] * (1 - t) + bottom[1] * t)
        b = int(top[2] * (1 - t) + bottom[2] * t)
        for x in range(W):
            px[x, y] = (r, g, b)
    return img


def render_card(lang, idx, title, subtitle, badge, shot_name, theme):
    top, bottom, accent = theme
    canvas = make_gradient(top, bottom).convert("RGBA")
    draw = ImageDraw.Draw(canvas)

    # Soft decorative bands outside the product UI. These are packaging only.
    draw.ellipse((-260, -180, 520, 560), fill=(*accent, 24))
    draw.ellipse((850, 210, 1540, 980), fill=(*accent, 18))
    draw.ellipse((760, 1900, 1530, 2750), fill=(255, 255, 255, 88))

    brand_font = font(34)
    title_font = font(78)
    sub_font = font(34)
    badge_font = font(30)

    draw.text((86, 98), "Timerbell ToDo", font=brand_font, fill=(86, 95, 115, 255))

    shot = Image.open(SRC / shot_name).convert("RGB")
    screen_w, screen_h = 760, 1648
    screen = fit_cover(shot, screen_w, screen_h)

    phone_x, phone_y = 262, 390
    shadow = Image.new("RGBA", (screen_w + 86, screen_h + 86), (0, 0, 0, 0))
    sd = ImageDraw.Draw(shadow)
    sd.rounded_rectangle((43, 43, screen_w + 43, screen_h + 43), radius=92, fill=(29, 34, 45, 80))
    shadow = shadow.filter(ImageFilter.GaussianBlur(22))
    canvas.alpha_composite(shadow, (phone_x - 43, phone_y - 28))

    draw_round_rect(draw, (phone_x - 24, phone_y - 24, phone_x + screen_w + 24, phone_y + screen_h + 24), 96, (18, 18, 18, 255))
    draw_round_rect(draw, (phone_x, phone_y, phone_x + screen_w, phone_y + screen_h), 70, (255, 255, 255, 255))
    paste_round(canvas, screen.convert("RGBA"), (phone_x, phone_y), 70)

    # Bottom text panel; keep away from screenshot to avoid altering real UI.
    panel_y = 2128
    draw_round_rect(draw, (70, panel_y, W - 70, H - 92), 48, (255, 255, 255, 215))
    draw.text((112, panel_y + 64), title, font=title_font, fill=(30, 35, 48, 255))
    multiline(draw, subtitle, 116, panel_y + 185, sub_font, (111, 120, 139, 255), W - 232, line_gap=16)
    draw_round_rect(draw, (112, H - 214, 450, H - 144), 35, (255, 239, 241, 255))
    draw.text((146, H - 194), badge, font=badge_font, fill=(238, 91, 93, 255))

    out_dir = OUT / lang
    out_dir.mkdir(parents=True, exist_ok=True)
    path = out_dir / f"{idx:02d}-{lang}.png"
    canvas.convert("RGB").save(path, quality=95)
    return path


ZH = [
    ("快速创建任务", "真实移动端任务创建页，支持优先级、日期、清单与番茄数设置。", "任务管理", "real-06-create-task.png", ((255, 245, 246), (255, 255, 255), (238, 91, 93))),
    ("四象限安排优先级", "按紧急与重要程度拆分任务，先处理真正关键的事。", "四象限", "real-03-quadrant.png", ((255, 247, 239), (255, 255, 255), (244, 158, 52))),
    ("用日程管理时间", "月视图与日程列表结合，计划安排更清晰。", "日程", "real-04-calendar.png", ((242, 247, 255), (255, 255, 255), (92, 132, 255))),
    ("复盘专注与任务", "查看任务数、专注时长与完成率，让效率变化可视化。", "数据复盘", "real-02-stats.png", ((244, 247, 251), (255, 255, 255), (64, 125, 255))),
    ("任务设置更完整", "优先级、提醒、清单、日期和番茄数都能在移动端完成。", "移动端任务", "real-06-create-task.png", ((247, 253, 241), (255, 255, 255), (135, 196, 34))),
]

EN = [
    ("Create Tasks Fast", "Real mobile task creation with priority, dates, lists, and Pomodoro count.", "Task Planner", "real-06-create-task.png", ((255, 245, 246), (255, 255, 255), (238, 91, 93))),
    ("Prioritize with Quadrants", "Sort tasks by urgency and importance, then focus on what matters.", "Quadrants", "real-03-quadrant.png", ((255, 247, 239), (255, 255, 255), (244, 158, 52))),
    ("Plan Time on Calendar", "Monthly calendar and schedule views help your day stay organized.", "Schedule", "real-04-calendar.png", ((242, 247, 255), (255, 255, 255), (92, 132, 255))),
    ("Review Focus and Tasks", "Track task counts, focus time, and completion rate with clear data.", "Review", "real-02-stats.png", ((244, 247, 251), (255, 255, 255), (64, 125, 255))),
    ("Manage Tasks on Mobile", "Set priority, reminders, lists, dates, and Pomodoro count right on your phone.", "Mobile Tasks", "real-06-create-task.png", ((247, 253, 241), (255, 255, 255), (135, 196, 34))),
]


def main():
    generated = []
    for i, item in enumerate(ZH, 1):
        generated.append(render_card("zh", i, *item))
    for i, item in enumerate(EN, 1):
        generated.append(render_card("en", i, *item))

    zip_path = ROOT / "appstore-real-images-260523.zip"
    used_shots = sorted({item[3] for item in ZH + EN})
    with zipfile.ZipFile(zip_path, "w", compression=zipfile.ZIP_DEFLATED) as zf:
        for path in generated:
            zf.write(path, path.relative_to(ROOT))
        for shot_name in used_shots:
            shot = SRC / shot_name
            zf.write(shot, shot.relative_to(ROOT))

    print("\n".join(str(p) for p in generated))
    print(zip_path)


if __name__ == "__main__":
    main()
