# 项目结构说明

```
uniapp-segment-tabs/
├── components/                    # 组件目录
│   ├── SegmentTabs.vue           # 主分段器组件
│   └── pages/                    # 页面组件目录
│       └── RecommendPage.vue     # 推荐页面组件示例
├── pages/                        # 页面目录
│   └── index/                    # 首页
│       └── index.vue             # 首页文件
├── examples/                     # 示例目录
│   └── usage-example.vue         # 完整使用示例
├── static/                       # 静态资源目录
│   └── images/                   # 图片资源
├── App.vue                       # 应用入口组件
├── main.js                       # 应用入口文件
├── manifest.json                 # 应用配置文件
├── pages.json                    # 页面配置文件
├── package.json                  # 项目依赖配置
├── README.md                     # 项目说明文档
└── PROJECT_STRUCTURE.md          # 项目结构说明（本文件）
```

## 核心文件说明

### 1. 主组件文件
- **`components/SegmentTabs.vue`**: 核心分段器组件，包含所有主要功能

### 2. 配置文件
- **`pages.json`**: uniapp页面路由配置
- **`manifest.json`**: uniapp应用配置
- **`package.json`**: 项目依赖和脚本配置

### 3. 入口文件
- **`main.js`**: Vue应用入口
- **`App.vue`**: 应用根组件

### 4. 示例文件
- **`pages/index/index.vue`**: 基础使用示例
- **`examples/usage-example.vue`**: 完整功能演示

## 组件功能模块

### SegmentTabs.vue 内部结构
```
<template>
├── scroll-view (分段器容器)
│   ├── tabs-wrapper (分段器包装器)
│   │   ├── tab-item (分段器项目)
│   │   └── indicator (指示器)
└── swiper (内容区域)
    └── swiper-item (页面项目)
        └── page-content (页面内容)
```

### 主要方法
- `init()`: 初始化组件
- `calculateTabWidths()`: 计算tab宽度
- `updateIndicator()`: 更新指示器位置
- `scrollToTab()`: 滚动到指定tab
- `loadPage()`: 加载页面（保活机制）
- `switchTab()`: 切换tab
- `getPageData()`: 获取页面数据

### 数据属性
- `currentIndex`: 当前选中索引
- `loadedPages`: 已加载页面数组
- `tabWidths`: tab宽度数组
- `indicatorLeft`: 指示器位置
- `scrollLeft`: 滚动位置

## 使用流程

1. **引入组件**: 在页面中引入 `SegmentTabs.vue`
2. **配置数据**: 准备 `tabs` 数组数据
3. **监听事件**: 监听 `change` 事件处理切换
4. **样式定制**: 根据需要调整样式

## 扩展说明

### 添加新页面类型
1. 在 `getPageData()` 方法中添加新的页面数据
2. 在模板中添加对应的条件渲染逻辑
3. 添加相应的样式

### 自定义样式
1. 修改组件内部的 scoped 样式
2. 使用深度选择器覆盖样式
3. 通过 props 传递样式参数

### 性能优化
1. 页面保活机制已内置
2. 按需加载页面内容
3. 指示器位置计算优化