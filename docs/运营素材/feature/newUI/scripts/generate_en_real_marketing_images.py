from pathlib import Path
from PIL import Image, ImageDraw, ImageFont, ImageFilter


ROOT = Path(__file__).resolve().parents[1]
RAW_DIR = ROOT / "real-screenshots" / "en-real-260526"
BG_PATH = ROOT / "genimage2-source" / "en-real-260526" / "01-en-real-wrapper-background-source.png"
OUT_DIR = ROOT / "appstore-en-real-genimage2-260526" / "en"
PREVIEW_PATH = ROOT / "previews" / "en" / "appstore-en-real-genimage2-260526-preview.png"

W = 1290
H = 2796

FONT_CANDIDATES = [
    "/System/Library/Fonts/Supplemental/Arial.ttf",
    "/System/Library/Fonts/Supplemental/Helvetica.ttc",
    "/Library/Fonts/Arial.ttf",
]


def font(size, bold=False):
    for path in FONT_CANDIDATES:
        if Path(path).exists():
            try:
                return ImageFont.truetype(path, size=size, index=1 if bold and path.endswith(".ttc") else 0)
            except Exception:
                try:
                    return ImageFont.truetype(path, size=size)
                except Exception:
                    continue
    return ImageFont.load_default()


def text_width(draw, text, font_obj):
    box = draw.textbbox((0, 0), text, font=font_obj)
    return box[2] - box[0]


def wrap_text(draw, text, font_obj, max_width):
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
    return lines


def rounded_mask(size, radius):
    mask = Image.new("L", size, 0)
    md = ImageDraw.Draw(mask)
    md.rounded_rectangle((0, 0, size[0], size[1]), radius=radius, fill=255)
    return mask


def fit_contain(img, box_w, box_h):
    scale = min(box_w / img.width, box_h / img.height)
    nw, nh = int(img.width * scale), int(img.height * scale)
    return img.resize((nw, nh), Image.Resampling.LANCZOS)


def draw_shadowed_round_rect(base, box, radius, fill, shadow_fill=(33, 40, 56, 26), blur=18, spread=18):
    layer = Image.new("RGBA", base.size, (0, 0, 0, 0))
    ld = ImageDraw.Draw(layer)
    x1, y1, x2, y2 = box
    ld.rounded_rectangle(
        (x1 + spread, y1 + spread, x2 + spread, y2 + spread),
        radius=radius,
        fill=shadow_fill,
    )
    layer = layer.filter(ImageFilter.GaussianBlur(blur))
    base.alpha_composite(layer)
    draw = ImageDraw.Draw(base)
    draw.rounded_rectangle(box, radius=radius, fill=fill)
    return draw


def draw_calendar_icon(draw, x, y, size, stroke, fill=None, stroke_w=4):
    if fill is not None:
        draw.rounded_rectangle((x, y, x + size, y + size), radius=size * 0.22, fill=fill)
    pad = size * 0.18
    body = (x + pad, y + pad * 1.25, x + size - pad, y + size - pad)
    draw.rounded_rectangle(body, radius=size * 0.12, outline=stroke, width=stroke_w)
    draw.line((x + pad, y + size * 0.37, x + size - pad, y + size * 0.37), fill=stroke, width=stroke_w)
    draw.line((x + size * 0.34, y + pad * 0.55, x + size * 0.34, y + size * 0.28), fill=stroke, width=stroke_w)
    draw.line((x + size * 0.66, y + pad * 0.55, x + size * 0.66, y + size * 0.28), fill=stroke, width=stroke_w)


def draw_clock_icon(draw, x, y, size, stroke, stroke_w=4):
    pad = size * 0.18
    draw.ellipse((x + pad, y + pad, x + size - pad, y + size - pad), outline=stroke, width=stroke_w)
    cx = x + size / 2
    cy = y + size / 2
    draw.line((cx, cy, cx, y + size * 0.33), fill=stroke, width=stroke_w)
    draw.line((cx, cy, x + size * 0.66, y + size * 0.62), fill=stroke, width=stroke_w)


def draw_target_icon(draw, x, y, size, stroke, stroke_w=4):
    pad = size * 0.16
    draw.ellipse((x + pad, y + pad, x + size - pad, y + size - pad), outline=stroke, width=stroke_w)
    draw.ellipse((x + size * 0.34, y + size * 0.34, x + size * 0.66, y + size * 0.66), outline=stroke, width=stroke_w)
    draw.line((x + size * 0.7, y + size * 0.3, x + size * 0.9, y + size * 0.12), fill=stroke, width=stroke_w)
    draw.line((x + size * 0.72, y + size * 0.12, x + size * 0.9, y + size * 0.12), fill=stroke, width=stroke_w)
    draw.line((x + size * 0.9, y + size * 0.12, x + size * 0.9, y + size * 0.28), fill=stroke, width=stroke_w)


def preprocess_home(shot):
    shot = shot.copy()
    draw = ImageDraw.Draw(shot)

    section_font = font(24, bold=True)
    card_title_font = font(27, bold=True)
    card_meta_font = font(21)
    chip_font = font(18, bold=True)

    # Add realistic demo tasks into the empty real screenshot area.
    section_y = 1216
    draw.text((94, section_y), "Today tasks", font=section_font, fill=(126, 134, 150, 255))
    draw.rounded_rectangle((940, section_y - 8, 1064, section_y + 34), radius=20, fill=(246, 249, 255, 255))
    draw.text((970, section_y + 1), "2 done", font=chip_font, fill=(90, 121, 244, 255))

    cards = [
        {
            "title": "Deep focus sprint",
            "meta": "09:30-10:20  |  2 tomatoes",
            "tag": "High",
            "tag_fill": (255, 242, 236, 255),
            "tag_text": (242, 109, 73, 255),
            "accent": (134, 96, 255, 255),
            "progress": 0.72,
        },
        {
            "title": "Revise launch copy",
            "meta": "11:00-11:45  |  1 tomato",
            "tag": "Writing",
            "tag_fill": (238, 247, 255, 255),
            "tag_text": (60, 142, 255, 255),
            "accent": (57, 196, 120, 255),
            "progress": 0.45,
        },
        {
            "title": "Inbox and follow-ups",
            "meta": "14:00-14:30  |  30 min",
            "tag": "Quick",
            "tag_fill": (244, 244, 244, 255),
            "tag_text": (128, 132, 142, 255),
            "accent": (255, 171, 59, 255),
            "progress": 0.88,
        },
    ]

    card_x = 64
    card_w = 1050
    card_h = 132
    start_y = 1260
    gap = 30
    for idx, item in enumerate(cards):
        y = start_y + idx * (card_h + gap)
        draw_shadowed_round_rect(
            shot,
            (card_x, y, card_x + card_w, y + card_h),
            radius=34,
            fill=(255, 255, 255, 255),
            shadow_fill=(48, 61, 84, 16),
            blur=18,
            spread=10,
        )
        draw = ImageDraw.Draw(shot)
        draw.rounded_rectangle((card_x + 28, y + 34, card_x + 44, y + 50), radius=8, fill=item["accent"])
        draw.text((card_x + 64, y + 24), item["title"], font=card_title_font, fill=(47, 53, 65, 255))
        draw.text((card_x + 64, y + 68), item["meta"], font=card_meta_font, fill=(129, 136, 149, 255))

        chip_w = text_width(draw, item["tag"], chip_font) + 28
        chip_x = card_x + card_w - chip_w - 28
        draw.rounded_rectangle((chip_x, y + 24, chip_x + chip_w, y + 58), radius=17, fill=item["tag_fill"])
        draw.text((chip_x + 14, y + 31), item["tag"], font=chip_font, fill=item["tag_text"])

        bar_x1 = card_x + 64
        bar_x2 = card_x + card_w - 64
        bar_y1 = y + 102
        bar_y2 = y + 112
        draw.rounded_rectangle((bar_x1, bar_y1, bar_x2, bar_y2), radius=5, fill=(241, 244, 248, 255))
        fill_x = int(bar_x1 + (bar_x2 - bar_x1) * item["progress"])
        draw.rounded_rectangle((bar_x1, bar_y1, fill_x, bar_y2), radius=5, fill=item["accent"])

    return shot


def preprocess_create_task(shot):
    shot = shot.copy()
    draw = ImageDraw.Draw(shot)

    # Clear the cramped header row inside the settings block.
    clear_box = (34, 1564, 1144, 1778)
    draw.rounded_rectangle(clear_box, radius=32, fill=(255, 255, 255, 255))
    draw.rectangle((1088, 1588, 1179, 1784), fill=(255, 255, 255, 255))
    draw.rectangle((1120, 1560, 1179, 1940), fill=(255, 255, 255, 255))

    outer_box = (246, 1618, 1028, 1678)
    draw.rounded_rectangle(outer_box, radius=29, fill=(255, 255, 255, 255), outline=(95, 126, 255, 255), width=4)

    selected_box = (252, 1624, 486, 1672)
    draw.rounded_rectangle(selected_box, radius=24, fill=(95, 126, 255, 255))

    label_font = font(25)
    selected_font = font(25, bold=True)
    inactive_color = (95, 126, 255, 255)
    active_color = (255, 255, 255, 255)

    # Selected: Date
    draw_calendar_icon(draw, 284, 1633, 28, active_color, stroke_w=3)
    draw.text((326, 1633), "Date", font=selected_font, fill=active_color)

    # Inactive: Time segment
    draw_clock_icon(draw, 540, 1633, 28, inactive_color, stroke_w=3)
    draw.text((582, 1633), "Time segment", font=label_font, fill=inactive_color)

    # Inactive: Objective
    draw_target_icon(draw, 818, 1633, 28, inactive_color, stroke_w=3)
    draw.text((860, 1633), "Objective", font=label_font, fill=inactive_color)

    return shot


def preprocess_screenshot(card, shot):
    if card["src"] == "00-home-clean.png":
        return preprocess_home(shot)
    if card["src"] == "01-create-task.png":
        return preprocess_create_task(shot)
    return shot


CARDS = [
    {
        "src": "00-home-clean.png",
        "out": "01-en-home-real-genimage2-1290x2796.png",
        "title": "Start with a clear day",
        "subtitle": "A real English home view with today's summary, quick add, and a direct focus entry.",
        "badge": "Home View",
    },
    {
        "src": "01-create-task.png",
        "out": "02-en-create-task-real-genimage2-1290x2796.png",
        "title": "Create tasks with context",
        "subtitle": "Priority, dates, lists, and focus settings on a real in-app creation screen.",
        "badge": "Task Setup",
    },
    {
        "src": "02-charts.png",
        "out": "03-en-charts-real-genimage2-1290x2796.png",
        "title": "Review progress clearly",
        "subtitle": "Live ranking, timeline, and weekly completion metrics from the real charts page.",
        "badge": "Charts",
    },
    {
        "src": "03-ai-note.png",
        "out": "04-en-ai-note-real-genimage2-1290x2796.png",
        "title": "Turn notes into action",
        "subtitle": "Write, brainstorm, outline, and expand ideas inside the real AI note workspace.",
        "badge": "AI Notes",
    },
]


def render_card(card):
    background = Image.open(BG_PATH).convert("RGBA").resize((W, H), Image.Resampling.LANCZOS)
    canvas = background.copy()
    draw = ImageDraw.Draw(canvas)

    brand_font = font(36)
    title_font = font(84, bold=True)
    sub_font = font(34)
    badge_font = font(28)

    draw.text((88, 92), "Timerbell Todo", font=brand_font, fill=(77, 86, 108, 255))

    title_y = 150
    for line in wrap_text(draw, card["title"], title_font, 940):
        draw.text((88, title_y), line, font=title_font, fill=(38, 44, 58, 255))
        title_y += title_font.size + 10

    sub_y = title_y + 8
    for line in wrap_text(draw, card["subtitle"], sub_font, 930):
        draw.text((88, sub_y), line, font=sub_font, fill=(108, 117, 135, 255))
        sub_y += sub_font.size + 10

    badge_x = 88
    badge_y = sub_y + 24
    badge_w = text_width(draw, card["badge"], badge_font) + 48
    draw.rounded_rectangle((badge_x, badge_y, badge_x + badge_w, badge_y + 56), radius=28, fill=(255, 243, 233, 255))
    draw.text((badge_x + 24, badge_y + 13), card["badge"], font=badge_font, fill=(244, 137, 43, 255))

    shot = Image.open(RAW_DIR / card["src"]).convert("RGBA")
    shot = preprocess_screenshot(card, shot)
    shot = fit_contain(shot, 1050, 2280)

    card_x = (W - shot.width) // 2
    card_y = 470

    shadow = Image.new("RGBA", (shot.width + 48, shot.height + 48), (0, 0, 0, 0))
    sd = ImageDraw.Draw(shadow)
    sd.rounded_rectangle((24, 24, shot.width + 24, shot.height + 24), radius=82, fill=(38, 44, 58, 46))
    shadow = shadow.filter(ImageFilter.GaussianBlur(18))
    canvas.alpha_composite(shadow, (card_x - 24, card_y - 8))

    mask = rounded_mask(shot.size, 76)
    frame = Image.new("RGBA", shot.size, (255, 255, 255, 255))
    frame.paste(shot, (0, 0), mask)
    canvas.paste(frame, (card_x, card_y), mask)

    OUT_DIR.mkdir(parents=True, exist_ok=True)
    out_path = OUT_DIR / card["out"]
    canvas.convert("RGB").save(out_path, quality=95)
    return out_path


def make_preview(paths):
    PREVIEW_PATH.parent.mkdir(parents=True, exist_ok=True)
    tiles = [Image.open(path).convert("RGB").resize((322, 699), Image.Resampling.LANCZOS) for path in paths]
    preview = Image.new("RGB", (322 * 2 + 36, 699 * 2 + 36), (248, 249, 252))
    coords = [(0, 0), (358, 0), (0, 735), (358, 735)]
    for tile, (x, y) in zip(tiles, coords):
        preview.paste(tile, (x, y))
    preview.save(PREVIEW_PATH, quality=92)


def main():
    paths = [render_card(card) for card in CARDS]
    make_preview(paths)
    for path in paths:
        print(path)
    print(PREVIEW_PATH)


if __name__ == "__main__":
    main()
