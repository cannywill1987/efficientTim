# VIP Code API 使用文档

## 数据库设计

### VipCodeModel 集合结构

```javascript
{
  vipCode: String,        // VIP Code（唯一，索引）
  bindCount: Number,      // 绑定次数（0-3）
  bindings: Array,        // 绑定记录数组
  // bindings 中每个元素格式:
  // {
  //   phone: String,      // 手机号
  //   deviceId: String,   // 设备号
  //   bindTime: Date      // 绑定时间
  // }
  createdAt: Date,        // 创建时间
  updatedAt: Date         // 更新时间
}
```

## API 接口

### 1. 生成 VIP Code

**接口地址：** `POST /api/vipcode/generate`

**请求参数：** 无

**响应示例：**
```json
{
  "success": true,
  "data": {
    "vipCode": "efwji12qw",
    "bindCount": 0,
    "maxBindCount": 3
  }
}
```

### 2. 绑定手机号和设备号到 VIP Code

**接口地址：** `POST /api/vipcode/bind`

**请求参数：**
```json
{
  "vipCode": "efwji12qw",
  "phone": "13800138000",
  "deviceId": "device123456"
}
```

**响应示例（成功）：**
```json
{
  "success": true,
  "data": {
    "vipCode": "efwji12qw",
    "bindCount": 1,
    "maxBindCount": 3,
    "bindings": [
      {
        "phone": "13800138000",
        "deviceId": "device123456",
        "bindTime": "2024-01-01T00:00:00.000Z"
      }
    ],
    "message": "绑定成功"
  }
}
```

**错误响应示例：**
- VIP Code 不存在：
```json
{
  "success": false,
  "code": "VIP_CODE_NOT_FOUND",
  "message": "VIP Code 不存在"
}
```

- 绑定次数已达上限：
```json
{
  "success": false,
  "code": "VIP_CODE_BIND_LIMIT_EXCEEDED",
  "message": "绑定次数已达到上限（最多3次）"
}
```

- 已绑定过：
```json
{
  "success": false,
  "code": "VIP_CODE_ALREADY_BOUND",
  "message": "该手机号和设备号已经绑定过此 VIP Code"
}
```

### 3. 查询 VIP Code 信息

**接口地址：** `GET /api/vipcode/info?vipCode=efwji12qw`

**请求参数：**
- `vipCode` (query参数，必填): VIP Code

**响应示例：**
```json
{
  "success": true,
  "data": {
    "vipCode": "efwji12qw",
    "bindCount": 2,
    "maxBindCount": 3,
    "bindings": [
      {
        "phone": "13800138000",
        "deviceId": "device123456",
        "bindTime": "2024-01-01T00:00:00.000Z"
      },
      {
        "phone": "13900139000",
        "deviceId": "device789012",
        "bindTime": "2024-01-02T00:00:00.000Z"
      }
    ],
    "createdAt": "2024-01-01T00:00:00.000Z",
    "updatedAt": "2024-01-02T00:00:00.000Z"
  }
}
```

## 业务规则

1. **VIP Code 生成**：自动生成10位随机字符串（字母和数字组合），确保唯一性
2. **绑定限制**：每个 VIP Code 最多可以绑定 3 次
3. **重复绑定检查**：同一个手机号和设备号组合不能重复绑定到同一个 VIP Code
4. **绑定记录**：每次绑定都会记录手机号、设备号和绑定时间

## 文件结构

```
app/
├── model/
│   └── VipCodeModel.js          # MongoDB 模型定义
├── controller/
│   └── vipcode/
│       └── VipCode.js           # 控制器
├── service/
│   └── vipcode/
│       └── VipCode.js           # 服务层
└── router.js                    # 路由配置（已添加 VIP Code 相关路由）
