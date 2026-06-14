创建日期：260525

# GenIMAGE2 Prompt：English App Store 概念截图

## 原始需求

用户要求创建英文版应用市场图片，截图数据可使用假数据，并按 UI 设计师 Agent 为每个相关页面创建一张截图。用户同时说明这些图片只能作为英文概念参考图，最终英文上架仍需要切到英文 App UI 后重新截真实图。

## 生成 Prompt

```text
Use case: ads-marketing
Asset type: English App Store / mobile productivity app concept reference visual, portrait 1290 x 2796 composition.
Primary request: Create a polished App Store marketing wrapper concept for a mobile productivity app named Timerbell Todo. This is an outer visual packaging reference only; do not invent detailed internal app UI screens. Leave the central phone screen area as a clean blank white rounded rectangle suitable for later compositing. Include a refined background, device frame, tasteful productivity motifs, and English headline typography.
Visual copy: "Plan. Focus. Review." and subtitle "Tasks, calendar, focus timer, and insights in one workspace". Keep text large, clean, and readable.
Style: modern productivity, premium iOS app marketing, light background, balanced white space, fresh green, coral, soft blue, and warm yellow accents. Avoid dark blue/slate dominance, purple gradients, beige-heavy themes, clutter, fake awards, App Store badges, watermarks, or tiny unreadable text.
Hard constraints: The phone screen must be blank/empty for compositing. Do not generate real app UI inside the phone. No fake rankings. No brand logos except the text Timerbell Todo if needed.
```

## 本次生成结果

- 生成状态：已生成
- 生成方式：GenImage2
- GenImage2 源图路径：`docs/运营素材/feature/newUI/genimage2-source/en-concept-260525/01-en-concept-wrapper-source.png`
- 本地后处理脚本：`docs/运营素材/feature/newUI/scripts/generate_english_concept_demo_data.py`
- 最终概念图目录：`docs/运营素材/feature/newUI/appstore-en-concept-demo-data-260525/en/`
- 总览预览图：`docs/运营素材/feature/newUI/previews/en/appstore-en-concept-demo-data-260525-preview.png`
- 用途边界：英文概念参考图，不作为真实英文 App 截图或 App Store 官方截图槽位最终素材

## 负向约束

- 不把 AI 生成图当成真实 App 页面截图。
- 不把假数据截图上传为最终 App Store 官方截图。
- 不写虚假排名、绝对化效果或审核风险文案。
- 不使用不可读小字或遮挡主要页面内容。
