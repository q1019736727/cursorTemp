# UniApp Vue2 分段器组件

一个功能完整的分段器组件，支持可滚动的分段器、指示器跟随、页面保活机制和双向同步。

## 功能特性

- ✅ 可滚动的分段器，支持超出屏幕显示
- ✅ 指示器跟随分段器滑动（长度20rpx，高3rpx）
- ✅ 下方页面支持手动左右滑动切换
- ✅ 分段器与页面双向同步
- ✅ 页面保活机制，已加载页面不销毁
- ✅ 分段器间距30rpx
- ✅ 自动滚动到可视区域
- ✅ Vue2 兼容，无需 `<component>` 标签

## 使用方法

### 1. 基础使用

```vue
<template>
  <view class="page">
    <SegmentedControl 
      :segments="segmentData"
      :initial-index="0"
      @change="onSegmentChange"
    />
  </view>
</template>

<script>
import SegmentedControl from '@/components/SegmentedControl.vue'

export default {
  components: {
    SegmentedControl
  },
  data() {
    return {
      segmentData: [
        { title: '推荐', component: 'Page1' },
        { title: '热门', component: 'Page2' },
        { title: '最新', component: 'Page1' }
      ]
    }
  },
  methods: {
    onSegmentChange(e) {
      console.log('切换到:', e.index, e.item)
    }
  }
}
</script>
```

### 2. Props 参数

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| segments | Array | 默认7个分段 | 分段器数据数组 |
| initialIndex | Number | 0 | 初始激活的分段索引 |

#### segments 数组结构

```javascript
[
  {
    title: '分段标题',    // 必需：显示的标题
    component: 'Page1'   // 可选：页面类型标识
  }
]
```

### 3. Events 事件

| 事件名 | 参数 | 说明 |
|--------|------|------|
| change | { index, item } | 分段切换时触发 |

### 4. Methods 方法

通过 `ref` 调用组件方法：

```javascript
// 切换到指定分段
this.$refs.segmentedControl.switchTo(index)

// 获取当前分段索引
const currentIndex = this.$refs.segmentedControl.getCurrentIndex()

// 获取已加载的页面索引数组
const loadedPages = this.$refs.segmentedControl.getLoadedPages()
```

## 样式定制

### 主要CSS变量

```css
/* 分段器高度 */
.segments-scroll {
  height: 88rpx;
}

/* 分段器间距 */
.segment-item {
  margin-right: 30rpx;
}

/* 指示器样式 */
.indicator {
  height: 3rpx;
  width: 20rpx; /* 固定宽度 */
  background-color: #007AFF;
}

/* 激活状态颜色 */
.segment-item.active .segment-text {
  color: #007AFF;
}
```

### 自定义样式

```css
/* 修改分段器背景色 */
.segments-scroll {
  background-color: #f8f9fa;
}

/* 修改指示器颜色 */
.indicator {
  background-color: #ff6b6b;
}

/* 修改激活文字颜色 */
.segment-item.active .segment-text {
  color: #ff6b6b;
}
```

## 页面内容定制

组件内部根据 `component` 字段渲染不同的页面内容：

```javascript
// Page1: 列表样式页面
{ title: '推荐', component: 'Page1' }

// Page2: 网格样式页面  
{ title: '热门', component: 'Page2' }

// 其他: 默认样式页面
{ title: '其他', component: 'Custom' }
```

你可以修改组件内部的页面渲染逻辑来适应你的需求。

## 保活机制说明

- 首次访问页面时才会加载内容
- 已加载的页面会保持在内存中，不会销毁
- 通过 `loadedPages` 数组管理已加载的页面
- 可通过 `getLoadedPages()` 方法查看已加载的页面

## 性能优化

1. **懒加载**: 只有访问过的页面才会渲染内容
2. **保活机制**: 避免重复渲染已加载的页面
3. **平滑动画**: 使用CSS过渡和uni-app原生动画
4. **内存管理**: 合理控制已加载页面数量

## 兼容性

- ✅ uniapp 2.x
- ✅ Vue 2.x
- ✅ 微信小程序
- ✅ H5
- ✅ App
- ✅ 支付宝小程序
- ✅ 百度小程序

## 注意事项

1. 确保 `segments` 数组不为空
2. `initialIndex` 应在有效范围内
3. 页面内容较多时注意内存使用
4. 在页面销毁时可考虑清理已加载页面

## 示例项目

参考 `pages/SegmentedDemo.vue` 查看完整的使用示例。