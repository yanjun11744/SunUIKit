# SunUIKit

个人 SwiftUI 组件库，持续收录项目中沉淀的通用 UI 组件。

- **iOS 17+**
- Swift 5.9+
- 零第三方依赖

---

## 安装

### Swift Package Manager

在 Xcode 中：**File → Add Package Dependencies...**

```
https://github.com/yanjunsun/SunUIKit
```

或在 `Package.swift` 中添加：

```swift
dependencies: [
    .package(url: "https://github.com/yanjunsun/SunUIKit", from: "1.0.0")
]
```

---

## 组件列表

### FlexibleHeader

ScrollView 下拉弹性拉伸头部效果。用户向下拉超出顶部边界时，头部视图随之拉伸放大。

#### 最简用法

```swift
import SunUIKit

ScrollView {
    HeroView()
        .flexibleHeaderContent()   // 挂在头部视图
    
    // 其他内容...
}
.flexibleHeaderScrollView()        // 挂在 ScrollView
.ignoresSafeArea(edges: .top)
```

#### 自定义配置

```swift
// 定义一次，两处共用同一个实例
let config = FlexibleHeaderConfiguration(
    baseHeight: .fixed(260),   // 静止高度，也可用 .halfContainer（容器高度/2）
    maximumHeight: 480,        // 拉伸上限，nil 表示不限制
    minimumHeight: 100,        // 压缩下限，nil 表示不限制
    onStretchProgress: { progress in
        // 拉伸进度 0.0 ~ 1.0，需设置 maximumHeight 才有意义
        print("stretch: \(progress)")
    }
)

ScrollView {
    HeroView()
        .flexibleHeaderContent(configuration: config)
    // ...
}
.flexibleHeaderScrollView(configuration: config)
.ignoresSafeArea(edges: .top)
```

#### 便捷预设

```swift
// 限制最大拉伸高度
.flexibleHeaderScrollView(configuration: .clamped(max: 480))

// 带进度回调
.flexibleHeaderScrollView(
    configuration: .clamped(baseHeight: .fixed(260), max: 480) { p in
        print(p)
    }
)
```

---

## 目录结构

```
SunUIKit/
├── Package.swift
├── README.md
├── Sources/
│   └── SunUIKit/
│       ├── SunUIKit.swift                          # 库入口
│       └── FlexibleHeader/                         # 组件目录
│           ├── FlexibleHeaderGeometry.swift
│           ├── FlexibleHeaderConfiguration.swift
│           ├── FlexibleHeaderModifiers.swift
│           └── FlexibleHeader+ViewExtensions.swift
└── Tests/
    └── SunUIKitTests/
        └── FlexibleHeaderTests.swift
```

新增组件时在 `Sources/SunUIKit/` 下新建同名文件夹，放入相关文件即可。

---

## 版本记录

| 版本 | 内容 |
|------|------|
| 1.0.0 | 初始发布，包含 FlexibleHeader |