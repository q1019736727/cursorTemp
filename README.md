# uniapp Vue2 分段器组件

这是一个基于 uniapp Vue2 的分段器组件，支持指示点跟随滑动、页面手动切换、页面保活等功能。

## 功能特性

- ✅ 分段器指示点跟随滑动（长度20rpx，高度3rpx）
- ✅ 支持手动左右滑动切换页面
- ✅ 分段器跟随页面切换自动滚动
- ✅ 页面保活，已加载的页面不会销毁
- ✅ 分段器间距30rpx
- ✅ 分段器可超出屏幕，自动滚动到对应位置
- ✅ 按需加载，每次只加载当前页面
- ✅ 下拉刷新功能
- ✅ 上拉加载更多功能
- ✅ 简洁界面，无多余附加信息

## 组件结构

```
components/
├── SegmentTabs.vue          # 主分段器组件
└── pages/
    └── RecommendPage.vue    # 示例页面组件

pages/
└── index/
    └── index.vue           # 示例使用页面
```

## 使用方法

### 1. 引入组件

```vue
<template>
  <view class="container">
    <segment-tabs 
      :tabs="tabs" 
      :default-index="0"
      :content-height="600"
      @change="handleTabChange"
    />
  </view>
</template>

<script>
import SegmentTabs from '@/components/SegmentTabs.vue'

export default {
  components: {
    SegmentTabs
  },
  data() {
    return {
      tabs: [
        {
          title: '推荐',
          component: 'RecommendPage'
        },
        {
          title: '热门',
          component: 'HotPage'
        },
        {
          title: '最新',
          component: 'LatestPage'
        }
      ]
    }
  },
  methods: {
    handleTabChange(e) {
      console.log('切换到:', e.item.title, '索引:', e.index)
    }
  }
}
</script>
```

### 2. 组件属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| tabs | Array | [] | 分段器数据数组 |
| defaultIndex | Number | 0 | 默认选中的索引 |
| contentHeight | Number | 400 | 内容区域高度（px） |

### 3. 事件

| 事件名 | 说明 | 回调参数 |
|--------|------|----------|
| change | 切换分段器时触发 | { index, item } |

### 4. tabs数据结构

```javascript
tabs: [
  {
    title: '分段器标题',     // 必填，显示的文字
    component: 'PageName'   // 可选，对应的页面组件名
  }
]
```

## 核心实现

### 1. 指示器跟随

```javascript
// 更新指示器位置
updateIndicator() {
  let left = 0
  for (let i = 0; i < this.currentIndex; i++) {
    left += this.tabWidths[i] || 0
  }
  
  const currentTabWidth = this.tabWidths[this.currentIndex] || 0
  const indicatorOffset = (currentTabWidth - 20) / 2
  
  this.indicatorLeft = left + indicatorOffset
}
```

### 2. 页面保活

```javascript
// 加载页面
loadPage(index) {
  if (!this.loadedPages.includes(index)) {
    this.loadedPages.push(index)
    // 初始化页面数据
    this.initPageData(index)
  }
}
```

### 3. 下拉刷新和上拉加载

```javascript
// 下拉刷新
onRefresh(index) {
  // 刷新当前页面数据
  this.pageData[index].list = this.getPageData(index)
}

// 上拉加载更多
onLoadMore(index) {
  // 加载更多数据
  const newData = this.getMoreData(index)
  this.pageData[index].list = [...this.pageData[index].list, ...newData]
}
```

### 4. 分段器滚动

```javascript
// 滚动到指定tab
scrollToTab(index) {
  let scrollLeft = 0
  for (let i = 0; i < index; i++) {
    scrollLeft += this.tabWidths[i] || 0
  }
  
  const currentTabWidth = this.tabWidths[index] || 0
  const centerOffset = (this.containerWidth - currentTabWidth) / 2
  
  this.scrollLeft = Math.max(0, scrollLeft - centerOffset)
}
```

## 样式定制

组件使用 scoped 样式，可以通过以下方式定制：

1. 修改组件内部的样式变量
2. 使用深度选择器覆盖样式
3. 通过 props 传递样式参数

## 注意事项

1. 由于 uniapp 不支持 `<component>` 标签，页面内容通过条件渲染实现
2. 组件会自动计算每个 tab 的宽度，确保指示器位置准确
3. 页面保活机制通过 `loadedPages` 数组控制，已加载的页面不会重新渲染
4. 分段器滚动使用 `scroll-view` 组件，支持超出屏幕的滚动
5. 下拉刷新和上拉加载功能已内置，支持各页面独立的数据管理
6. 指示器位置已优化，考虑了左边距30rpx的偏移

## 兼容性

- ✅ H5
- ✅ 微信小程序
- ✅ App（iOS/Android）
- ✅ 其他小程序平台

## 更新日志

### v1.0.0
- 初始版本
- 支持基础分段器功能
- 实现指示器跟随
- 支持页面保活
- 支持手动滑动切换
