# 漫画管理 API 文档

## 基础信息

- 基础URL: `http://your-domain:9999`
- 所有API返回格式统一为：
```json
{
  "success": true,
  "code": 0,
  "message": "success",
  "data": {}
}
```

---

## 1. 创建单个漫画

**请求URL:** `POST /api/manga`

**请求参数:**
```json
{
  "title": "漫画标题",
  "link": "https://example.com/manga/123",
  "categories": "Azione,Drammatico,Shounen",
  "author": "作者名称",
  "pic_url": "https://example.com/pic.jpg",
  "state": "连载中",
  "score": 8.5,
  "isHot": "是",
  "country": "日本",
  "year": "2023",
  "views": "10000",
  "description": "漫画描述",
  "latest_chapter": "第100话",
  "latest_chapter_link": "https://example.com/chapter/100",
  "lattest_chapter_date": "2024-01-01",
  "latest_chapter_timestamp": "1704067200"
}
```

**请求示例:**
```bash
curl -X POST http://localhost:9999/api/manga \
  -H "Content-Type: application/json" \
  -d '{
    "title": "火影忍者",
    "link": "https://example.com/manga/naruto",
    "categories": "Azione,Drammatico,Shounen",
    "author": "岸本齐史",
    "pic_url": "https://example.com/pic/naruto.jpg",
    "state": "已完结",
    "score": 9.2,
    "isHot": "是",
    "country": "日本",
    "year": "1999",
    "views": "1000000",
    "description": "一个关于忍者的故事",
    "latest_chapter": "第700话",
    "latest_chapter_link": "https://example.com/chapter/700",
    "lattest_chapter_date": "2014-11-10",
    "latest_chapter_timestamp": "1415548800"
  }'
```

**返回示例:**
```json
{
  "success": true,
  "code": 0,
  "message": "success",
  "data": {
    "success": true,
    "id": 1,
    "message": "创建成功"
  }
}
```

---

## 2. 批量创建漫画

**请求URL:** `POST /api/manga/batch`

**请求参数:**
```json
{
  "list": [
    {
      "title": "漫画1",
      "link": "https://example.com/manga/1",
      "categories": "Azione,Drammatico",
      "author": "作者1",
      "pic_url": "https://example.com/pic1.jpg",
      "state": "连载中",
      "score": 8.5
    },
    {
      "title": "漫画2",
      "link": "https://example.com/manga/2",
      "categories": "Shounen",
      "author": "作者2",
      "pic_url": "https://example.com/pic2.jpg",
      "state": "已完结",
      "score": 9.0
    }
  ]
}
```

**请求示例:**
```bash
curl -X POST http://localhost:9999/api/manga/batch \
  -H "Content-Type: application/json" \
  -d '{
    "list": [
      {
        "title": "火影忍者",
        "link": "https://example.com/manga/naruto",
        "categories": "Azione,Drammatico,Shounen",
        "author": "岸本齐史",
        "pic_url": "https://example.com/pic/naruto.jpg",
        "state": "已完结",
        "score": 9.2
      },
      {
        "title": "海贼王",
        "link": "https://example.com/manga/onepiece",
        "categories": "Azione,Shounen",
        "author": "尾田荣一郎",
        "pic_url": "https://example.com/pic/onepiece.jpg",
        "state": "连载中",
        "score": 9.5
      }
    ]
  }'
```

**返回示例:**
```json
{
  "success": true,
  "code": 0,
  "message": "success",
  "data": {
    "success": 2,
    "failed": 0,
    "errors": []
  }
}
```

**说明:**
- 如果 `link` 已存在，会自动更新该记录
- 返回结果包含成功数量、失败数量和错误详情

---

## 3. 根据ID查询漫画

**请求URL:** `GET /api/manga/:id`

**路径参数:**
- `id` (Number): 漫画ID

**请求示例:**
```bash
curl http://localhost:9999/api/manga/1
```

**返回示例:**
```json
{
  "success": true,
  "code": 0,
  "message": "success",
  "data": {
    "id": 1,
    "title": "火影忍者",
    "link": "https://example.com/manga/naruto",
    "categories": "Azione,Drammatico,Shounen",
    "author": "岸本齐史",
    "pic_url": "https://example.com/pic/naruto.jpg",
    "state": "已完结",
    "score": 9.2,
    "isHot": "是",
    "country": "日本",
    "year": "1999",
    "views": "1000000",
    "description": "一个关于忍者的故事",
    "latest_chapter": "第700话",
    "latest_chapter_link": "https://example.com/chapter/700",
    "lattest_chapter_date": "2014-11-10",
    "latest_chapter_timestamp": "1415548800",
    "created_at": "2024-01-01 10:00:00",
    "updated_at": "2024-01-01 10:00:00"
  }
}
```

---

## 4. 更新漫画（根据ID）

**请求URL:** `PUT /api/manga/:id`

**路径参数:**
- `id` (Number): 漫画ID

**请求参数:**
```json
{
  "title": "更新后的标题",
  "score": 9.5,
  "state": "连载中"
}
```

**请求示例:**
```bash
curl -X PUT http://localhost:9999/api/manga/1 \
  -H "Content-Type: application/json" \
  -d '{
    "title": "火影忍者（更新）",
    "score": 9.5,
    "state": "连载中"
  }'
```

**返回示例:**
```json
{
  "success": true,
  "code": 0,
  "message": "success",
  "data": {
    "success": true,
    "affectedRows": 1
  }
}
```

---

## 5. 删除漫画（根据ID）

**请求URL:** `DELETE /api/manga/:id`

**路径参数:**
- `id` (Number): 漫画ID

**请求示例:**
```bash
curl -X DELETE http://localhost:9999/api/manga/1
```

**返回示例:**
```json
{
  "success": true,
  "code": 0,
  "message": "success",
  "data": {
    "success": true,
    "affectedRows": 1
  }
}
```

---

## 6. 分页查询漫画列表

**请求URL:** `GET /api/manga/list`

**查询参数:**
- `page` (Number, 可选): 页码，默认1
- `pageSize` (Number, 可选): 每页数量，默认20
- `state` (String, 可选): 状态筛选，如 "连载中"、"已完结"
- `country` (String, 可选): 国家筛选，如 "日本"、"中国"
- `isHot` (String, 可选): 是否热门，如 "是"、"否"

**请求示例:**
```bash
# 基本查询
curl "http://localhost:9999/api/manga/list?page=1&pageSize=20"

# 带筛选条件
curl "http://localhost:9999/api/manga/list?page=1&pageSize=20&state=连载中&country=日本"
```

**返回示例:**
```json
{
  "success": true,
  "code": 0,
  "message": "success",
  "data": {
    "list": [
      {
        "id": 1,
        "title": "火影忍者",
        "link": "https://example.com/manga/naruto",
        "categories": "Azione,Drammatico,Shounen",
        "author": "岸本齐史",
        "pic_url": "https://example.com/pic/naruto.jpg",
        "state": "已完结",
        "score": 9.2
      }
    ],
    "total": 100,
    "page": 1,
    "pageSize": 20,
    "totalPages": 5
  }
}
```

---

## 7. 猜你喜欢 - 根据categories随机返回

**请求URL:** `GET /api/manga/recommendations`

**查询参数:**
- `categories` (String, 可选): 分类字符串，多个分类用逗号分隔，如 "Azione,Drammatico,Shounen"
- `limit` (Number, 可选): 返回数量，默认10

**说明:**
- 如果提供了 `categories`，会查找包含任一分类的漫画，然后随机返回指定数量
- 如果没有提供 `categories`，会随机返回所有漫画中的指定数量
- 随机算法：先计算总数，然后随机一个偏移量，查询后n个

**请求示例:**
```bash
# 根据分类推荐
curl "http://localhost:9999/api/manga/recommendations?categories=Azione,Drammatico&limit=10"

# 随机推荐（不指定分类）
curl "http://localhost:9999/api/manga/recommendations?limit=10"
```

**返回示例:**
```json
{
  "success": true,
  "code": 0,
  "message": "success",
  "data": {
    "list": [
      {
        "id": 5,
        "title": "火影忍者",
        "link": "https://example.com/manga/naruto",
        "categories": "Azione,Drammatico,Shounen",
        "author": "岸本齐史",
        "pic_url": "https://example.com/pic/naruto.jpg",
        "state": "已完结",
        "score": 9.2
      },
      {
        "id": 12,
        "title": "海贼王",
        "link": "https://example.com/manga/onepiece",
        "categories": "Azione,Shounen",
        "author": "尾田荣一郎",
        "pic_url": "https://example.com/pic/onepiece.jpg",
        "state": "连载中",
        "score": 9.5
      }
    ],
    "count": 10,
    "categories": "Azione,Drammatico"
  }
}
```

---

## 8. 根据category查询漫画列表

**请求URL:** `GET /api/manga/category/:category`

**路径参数:**
- `category` (String): 分类名称，如 "Azione"、"Drammatico"、"Shounen"

**查询参数:**
- `page` (Number, 可选): 页码，默认1
- `pageSize` (Number, 可选): 每页数量，默认20

**说明:**
- `categories` 字段是用逗号分隔的字符串，如 "Azione,Drammatico,Shounen"
- 使用 `FIND_IN_SET` 函数查询包含指定分类的记录

**请求示例:**
```bash
# 查询包含 "Azione" 分类的漫画
curl "http://localhost:9999/api/manga/category/Azione?page=1&pageSize=20"

# 查询包含 "Shounen" 分类的漫画
curl "http://localhost:9999/api/manga/category/Shounen?page=1&pageSize=20"
```

**返回示例:**
```json
{
  "success": true,
  "code": 0,
  "message": "success",
  "data": {
    "list": [
      {
        "id": 1,
        "title": "火影忍者",
        "link": "https://example.com/manga/naruto",
        "categories": "Azione,Drammatico,Shounen",
        "author": "岸本齐史",
        "pic_url": "https://example.com/pic/naruto.jpg",
        "state": "已完结",
        "score": 9.2
      },
      {
        "id": 3,
        "title": "死神",
        "link": "https://example.com/manga/bleach",
        "categories": "Azione,Shounen",
        "author": "久保带人",
        "pic_url": "https://example.com/pic/bleach.jpg",
        "state": "已完结",
        "score": 8.8
      }
    ],
    "total": 50,
    "page": 1,
    "pageSize": 20,
    "totalPages": 3,
    "category": "Azione"
  }
}
```

---

## 错误处理

当请求失败时，返回格式如下：

```json
{
  "success": false,
  "code": -1,
  "message": "错误信息"
}
```

常见错误码：
- `-1`: 通用错误
- `404`: 资源不存在

---

## 注意事项

1. **categories 字段格式**: 使用逗号分隔的字符串，如 "Azione,Drammatico,Shounen"
2. **link 唯一性**: `link` 字段是唯一索引，重复的 `link` 会自动更新而不是创建新记录
3. **批量操作**: 批量创建使用事务处理，如果部分失败会回滚
4. **随机推荐算法**: 先计算总数，然后随机一个偏移量，查询后n个记录
5. **分类查询**: 使用 `FIND_IN_SET` 函数查询，支持逗号分隔的分类字符串

