from pathlib import Path
from PIL import Image, ImageDraw, ImageFont, ImageFilter
import zipfile


ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "real-screenshots" / "zh"
OUT = ROOT / "appstore-mobile-promo-v2"
W, H = 1290, 2796

FONT_CANDIDATES = [
    "/System/Library/Fonts/PingFang.ttc",
    "/System/Library/Fonts/STHeiti Light.ttc",
    "/System/Library/Fonts/Supplemental/Arial Unicode.ttf",
    "/Library/Fonts/Arial Unicode.ttf",
]


def font(size):
    for path in FONT_CANDIDATES:
        if Path(path).exists():
            return ImageFont.truetype(path, size=size, index=0)
    return ImageFont.load_default()


def rounded(draw, box, radius, fill, outline=None, width=1):
    draw.rounded_rectangle(box, radius=radius, fill=fill, outline=outline, width=width)


def fit_cover(img, box_w, box_h):
    scale = max(box_w / img.width, box_h / img.height)
    nw, nh = int(img.width * scale), int(img.height * scale)
    resized = img.resize((nw, nh), Image.Resampling.LANCZOS)
    left = (nw - box_w) // 2
    top = (nh - box_h) // 2
    return resized.crop((left, top, left + box_w, top + box_h))


def text_width(draw, text, font_obj):
    box = draw.textbbox((0, 0), text, font=font_obj)
    return box[2] - box[0]


def draw_multiline(draw, text, x, y, font_obj, fill, max_width, line_gap=14):
    current = ""
    lines = []
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

    for line in lines[:2]:
        draw.text((x, y), line, font=font_obj, fill=fill)
        y += font_obj.size + line_gap
    return y


def make_background(accent):
    canvas = Image.new("RGBA", (W, H), (248, 250, 247, 255))
    px = canvas.load()
    for y in range(H):
        t = y / (H - 1)
        base = (
            int(248 * (1 - t) + 255 * t),
            int(250 * (1 - t) + 255 * t),
            int(247 * (1 - t) + 252 * t),
            255,
        )
        for x in range(W):
            px[x, y] = base

    draw = ImageDraw.Draw(canvas)

    # 外层包装用轻量结构线，不影响真实 App 截图内容。
    for i in range(9):
        y = 310 + i * 198
        draw.line((72, y, W - 72, y), fill=(224, 229, 224, 95), width=2)
    draw.rectangle((0, 0, 20, H), fill=(*accent, 255))
    rounded(draw, (70, 318, W - 70, 2262), 64, (255, 255, 255, 145), outline=(230, 234, 230, 160), width=2)
    return canvas


def paste_round(base, img, xy, radius):
    mask = Image.new("L", img.size, 0)
    md = ImageDraw.Draw(mask)
    md.rounded_rectangle((0, 0, img.width, img.height), radius=radius, fill=255)
    base.paste(img, xy, mask)


def draw_phone(canvas, shot_name, y, accent):
    draw = ImageDraw.Draw(canvas)
    shot = Image.open(SRC / shot_name).convert("RGB")

    screen_w, screen_h = 760, 1647
    screen = fit_cover(shot, screen_w, screen_h).convert("RGBA")
    phone_x = (W - screen_w) // 2

    shadow = Image.new("RGBA", (screen_w + 120, screen_h + 120), (0, 0, 0, 0))
    sd = ImageDraw.Draw(shadow)
    sd.rounded_rectangle((60, 50, screen_w + 60, screen_h + 50), radius=92, fill=(24, 27, 34, 78))
    shadow = shadow.filter(ImageFilter.GaussianBlur(28))
    canvas.alpha_composite(shadow, (phone_x - 60, y - 24))

    rounded(draw, (phone_x - 28, y - 28, phone_x + screen_w + 28, y + screen_h + 28), 96, (18, 18, 18, 255))
    rounded(draw, (phone_x, y, phone_x + screen_w, y + screen_h), 72, (255, 255, 255, 255))
    paste_round(canvas, screen, (phone_x, y), 72)


def render(index, title, subtitle, tags, shot_name, accent):
    canvas = make_background(accent)
    draw = ImageDraw.Draw(canvas)

    brand_font = font(35)
    title_font = font(78)
    subtitle_font = font(34)
    tag_font = font(28)
    note_font = font(28)

    draw.text((84, 90), "时间管理局 ToDo", font=brand_font, fill=(61, 70, 83, 255))
    rounded(draw, (W - 325, 84, W - 82, 138), 27, (255, 255, 255, 230), outline=(224, 229, 224, 220), width=2)
    draw.text((W - 286, 100), "移动端上线图", font=note_font, fill=(105, 113, 126, 255))

    draw.text((84, 178), title, font=title_font, fill=(25, 30, 42, 255))
    draw_multiline(draw, subtitle, 88, 288, subtitle_font, (97, 107, 124, 255), W - 176, line_gap=16)

    draw_phone(canvas, shot_name, 514, accent)

    panel_y = 2268
    rounded(draw, (70, panel_y, W - 70, H - 92), 52, (255, 255, 255, 235), outline=(229, 234, 229, 190), width=2)
    draw.text((112, panel_y + 58), "适合场景", font=note_font, fill=(94, 103, 116, 255))

    x = 112
    y = panel_y + 122
    for tag in tags:
        tw = text_width(draw, tag, tag_font)
        box = (x, y, x + tw + 54, y + 66)
        chip_fill = tuple(int(c * 0.12 + 255 * 0.88) for c in accent)
        rounded(draw, box, 33, (*chip_fill, 255), outline=(*accent, 150), width=2)
        draw.text((x + 27, y + 16), tag, font=tag_font, fill=(*accent, 255))
        x += tw + 74
        if x > W - 260:
            x = 112
            y += 86

    draw.text((112, H - 176), "真实产品截图 + 上线包装，不伪造 App 内部界面", font=note_font, fill=(116, 126, 142, 255))

    out_dir = OUT / "zh"
    out_dir.mkdir(parents=True, exist_ok=True)
    path = out_dir / f"{index:02d}-zh-mobile-promo.png"
    canvas.convert("RGB").save(path, quality=95)
    return path


ITEMS = [
    (
        "把任务快速记下来",
        "标题、标签、优先级与时间设置，一屏完成日常任务创建。",
        ["任务管理", "快速创建", "番茄数"],
        "real-06-create-task.png",
        (238, 91, 93),
    ),
    (
        "四象限看清重点",
        "按重要与紧急程度拆分任务，先处理真正关键的事情。",
        ["四象限", "优先级", "工作法"],
        "real-03-quadrant.png",
        (134, 164, 55),
    ),
    (
        "日程安排更清楚",
        "月历和任务列表结合，计划每天的节奏与空档。",
        ["日历", "日程规划", "时间轴"],
        "real-04-calendar.png",
        (68, 115, 210),
    ),
    (
        "复盘专注投入",
        "任务数、专注时长与完成率可视化，看见效率变化。",
        ["数据复盘", "专注时长", "完成率"],
        "real-02-stats.png",
        (92, 98, 178),
    ),
    (
        "移动端设置完整",
        "提醒、清单、日期和番茄数都能随手配置，减少来回跳转。",
        ["提醒", "清单", "移动工作台"],
        "real-06-create-task.png",
        (230, 143, 50),
    ),
]


def main():
    generated = []
    for index, item in enumerate(ITEMS, 1):
        generated.append(render(index, *item))

    zip_path = ROOT / "appstore-mobile-promo-v2-260525.zip"
    with zipfile.ZipFile(zip_path, "w", compression=zipfile.ZIP_DEFLATED) as zf:
        for path in generated:
            zf.write(path, path.relative_to(ROOT))
        for shot_name in sorted({item[3] for item in ITEMS}):
            shot = SRC / shot_name
            zf.write(shot, shot.relative_to(ROOT))

    print("\n".join(str(path) for path in generated))
    print(zip_path)


if __name__ == "__main__":
    main()
