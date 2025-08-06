<template>
  <view class="segment-tabs">
    <!-- 分段器容器 -->
    <scroll-view 
      class="tabs-container" 
      scroll-x 
      :scroll-left="scrollLeft"
      scroll-with-animation
      :show-scrollbar="false"
    >
      <view class="tabs-wrapper" :style="{ transform: `translateX(${tabsOffset}px)` }">
        <view 
          v-for="(item, index) in tabs" 
          :key="index"
          class="tab-item"
          :class="{ active: currentIndex === index }"
          @click="handleTabClick(index)"
        >
          <text class="tab-text">{{ item.title }}</text>
        </view>
        <!-- 指示器 -->
        <view 
          class="indicator" 
          :style="{ 
            left: indicatorLeft + 'px',
            width: '20rpx',
            height: '3rpx'
          }"
        ></view>
      </view>
    </scroll-view>
    
    <!-- 页面内容区域 -->
    <swiper 
      class="content-swiper" 
      :current="currentIndex" 
      @change="handleSwiperChange"
      :style="{ height: contentHeight + 'px' }"
    >
      <swiper-item 
        v-for="(item, index) in tabs" 
        :key="index"
        class="swiper-item"
      >
        <view class="content-wrapper">
          <!-- 使用v-if控制页面显示，v-show保持页面保活 -->
          <view v-if="loadedPages.includes(index)" class="page-content">
            <view v-if="item.component" class="component-wrapper">
              <!-- 动态渲染组件 -->
              <view v-if="item.component === 'RecommendPage'" class="recommend-page">
                <scroll-view 
                  class="content-scroll" 
                  scroll-y 
                  refresher-enabled
                  :refresher-triggered="getRefreshState(index)"
                  @refresherrefresh="onRefresh(index)"
                  @scrolltolower="onLoadMore(index)"
                >
                  <view class="content-list">
                    <view 
                      v-for="(content, idx) in pageData[index]?.list || getPageData(index)" 
                      :key="idx"
                      class="content-item"
                    >
                      <view class="item-info">
                        <text class="item-title">{{ content.title }}</text>
                        <text class="item-desc">{{ content.description }}</text>
                        <view class="item-meta">
                          <text class="meta-text">{{ content.author }}</text>
                          <text class="meta-text">{{ content.date }}</text>
                        </view>
                      </view>
                    </view>
                  </view>
                </scroll-view>
              </view>
              <view v-else class="default-content">
                <text>{{ item.title }} 页面内容</text>
              </view>
            </view>
            <view v-else class="default-content">
              <text>{{ item.title }} 页面内容</text>
            </view>
          </view>
        </view>
      </swiper-item>
    </swiper>
  </view>
</template>

<script>
export default {
  name: 'SegmentTabs',
  props: {
    // 分段器数据
    tabs: {
      type: Array,
      default: () => []
    },
    // 默认选中索引
    defaultIndex: {
      type: Number,
      default: 0
    },
    // 内容区域高度
    contentHeight: {
      type: Number,
      default: 400
    }
  },
  data() {
    return {
      currentIndex: 0,
      scrollLeft: 0,
      tabsOffset: 0,
      indicatorLeft: 0,
      loadedPages: [], // 已加载的页面索引
      tabWidths: [], // 每个tab的宽度
      containerWidth: 0, // 容器宽度
      systemInfo: null,
      calculateTimer: null,
      refreshStates: {}, // 各页面的刷新状态
      pageData: {} // 各页面的数据
    }
  },
  mounted() {
    this.init()
  },
  
  beforeDestroy() {
    // 清理定时器
    if (this.calculateTimer) {
      clearTimeout(this.calculateTimer)
    }
  },
  methods: {
    // 初始化
    init() {
      this.currentIndex = this.defaultIndex
      this.getSystemInfo()
      this.$nextTick(() => {
        this.calculateTabWidths()
        // 只加载当前页面，不预加载其他页面
        this.loadPage(this.currentIndex)
        this.updateIndicator()
      })
    },
    
    // 获取系统信息
    getSystemInfo() {
      const systemInfo = uni.getSystemInfoSync()
      this.systemInfo = systemInfo
      this.containerWidth = systemInfo.windowWidth
    },
    
    // 计算每个tab的宽度
    calculateTabWidths() {
      const query = uni.createSelectorQuery().in(this)
      query.selectAll('.tab-item').boundingClientRect((rects) => {
        if (rects) {
          this.tabWidths = rects.map(rect => rect.width)
          this.updateIndicator()
        }
      }).exec()
    },
    
    // 处理tab点击
    handleTabClick(index) {
      this.switchTab(index)
    },
    
    // 处理swiper切换
    handleSwiperChange(e) {
      const index = e.detail.current
      this.switchTab(index)
    },
    
    // 切换tab
    switchTab(index) {
      if (this.currentIndex === index) return
      
      this.currentIndex = index
      this.loadPage(index)
      this.updateIndicator()
      this.scrollToTab(index)
      
      this.$emit('change', {
        index,
        item: this.tabs[index]
      })
    },
    
    // 加载页面
    loadPage(index) {
      if (!this.loadedPages.includes(index)) {
        this.loadedPages.push(index)
        // 初始化页面数据
        this.initPageData(index)
      }
    },
    
    // 初始化页面数据
    initPageData(index) {
      if (!this.pageData[index]) {
        this.pageData[index] = {
          list: this.getPageData(index),
          loading: false,
          refreshing: false,
          hasMore: true
        }
      }
    },
    
    // 更新指示器位置
    updateIndicator() {
      if (this.tabWidths.length === 0) return
      
      let left = 0
      for (let i = 0; i < this.currentIndex; i++) {
        left += this.tabWidths[i] || 0
      }
      
      // 计算当前tab的中心位置，指示器宽度20rpx
      const currentTabWidth = this.tabWidths[this.currentIndex] || 0
      const indicatorOffset = (currentTabWidth - 20) / 2
      
      // 加上左边距30rpx
      this.indicatorLeft = left + indicatorOffset + 30
    },
    
    // 滚动到指定tab
    scrollToTab(index) {
      if (this.tabWidths.length === 0) return
      
      let scrollLeft = 0
      for (let i = 0; i < index; i++) {
        scrollLeft += this.tabWidths[i] || 0
      }
      
      // 计算需要滚动的位置，使tab居中显示
      const currentTabWidth = this.tabWidths[index] || 0
      const centerOffset = (this.containerWidth - currentTabWidth) / 2
      
      // 加上左边距30rpx
      this.scrollLeft = Math.max(0, scrollLeft - centerOffset + 30)
    },
    
    // 获取页面数据
    getPageData(index) {
      const pageData = {
        0: [ // 推荐
          {
            title: '推荐内容标题1',
            description: '这是推荐内容的详细描述，展示一些示例内容...',
            author: '作者1',
            date: '2024-01-15'
          },
          {
            title: '推荐内容标题2',
            description: '这是推荐内容的详细描述，展示一些示例内容...',
            author: '作者2',
            date: '2024-01-14'
          },
          {
            title: '推荐内容标题3',
            description: '这是推荐内容的详细描述，展示一些示例内容...',
            author: '作者3',
            date: '2024-01-13'
          }
        ],
        1: [ // 热门
          {
            title: '热门内容标题1',
            description: '这是热门内容的详细描述，展示一些示例内容...',
            author: '热门作者1',
            date: '2024-01-15'
          },
          {
            title: '热门内容标题2',
            description: '这是热门内容的详细描述，展示一些示例内容...',
            author: '热门作者2',
            date: '2024-01-14'
          }
        ],
        2: [ // 最新
          {
            title: '最新内容标题1',
            description: '这是最新内容的详细描述，展示一些示例内容...',
            author: '最新作者1',
            date: '2024-01-15'
          },
          {
            title: '最新内容标题2',
            description: '这是最新内容的详细描述，展示一些示例内容...',
            author: '最新作者2',
            date: '2024-01-14'
          }
        ],
        3: [ // 分类
          {
            title: '分类内容标题1',
            description: '这是分类内容的详细描述，展示一些示例内容...',
            author: '分类作者1',
            date: '2024-01-15'
          }
        ],
        4: [ // 我的
          {
            title: '我的内容标题1',
            description: '这是我的内容的详细描述，展示一些示例内容...',
            author: '我的作者1',
            date: '2024-01-15'
          }
        ],
        5: [ // 设置
          {
            title: '设置内容标题1',
            description: '这是设置内容的详细描述，展示一些示例内容...',
            author: '设置作者1',
            date: '2024-01-15'
          }
        ]
      }
      
      return pageData[index] || []
    },
    
    // 获取刷新状态
    getRefreshState(index) {
      return this.refreshStates[index] || false
    },
    
    // 下拉刷新
    onRefresh(index) {
      if (this.pageData[index] && this.pageData[index].refreshing) return
      
      this.refreshStates[index] = true
      if (this.pageData[index]) {
        this.pageData[index].refreshing = true
      }
      
      // 模拟刷新数据
      setTimeout(() => {
        if (this.pageData[index]) {
          this.pageData[index].list = this.getPageData(index)
          this.pageData[index].refreshing = false
        }
        this.refreshStates[index] = false
        
        uni.showToast({
          title: '刷新成功',
          icon: 'success',
          duration: 1000
        })
      }, 1000)
    },
    
    // 上拉加载更多
    onLoadMore(index) {
      if (this.pageData[index] && (this.pageData[index].loading || !this.pageData[index].hasMore)) return
      
      if (this.pageData[index]) {
        this.pageData[index].loading = true
      }
      
      // 模拟加载更多数据
      setTimeout(() => {
        if (this.pageData[index]) {
          const newData = this.getMoreData(index)
          if (newData.length > 0) {
            this.pageData[index].list = [...this.pageData[index].list, ...newData]
          } else {
            this.pageData[index].hasMore = false
          }
          this.pageData[index].loading = false
        }
        
        uni.showToast({
          title: this.pageData[index]?.hasMore ? '加载成功' : '没有更多数据',
          icon: 'none',
          duration: 1000
        })
      }, 1000)
    },
    
    // 获取更多数据
    getMoreData(index) {
      const moreData = {
        0: [ // 推荐
          {
            title: '推荐内容标题4',
            description: '这是推荐内容的详细描述，展示一些示例内容...',
            author: '作者4',
            date: '2024-01-12'
          },
          {
            title: '推荐内容标题5',
            description: '这是推荐内容的详细描述，展示一些示例内容...',
            author: '作者5',
            date: '2024-01-11'
          }
        ],
        1: [ // 热门
          {
            title: '热门内容标题3',
            description: '这是热门内容的详细描述，展示一些示例内容...',
            author: '热门作者3',
            date: '2024-01-13'
          }
        ],
        2: [ // 最新
          {
            title: '最新内容标题3',
            description: '这是最新内容的详细描述，展示一些示例内容...',
            author: '最新作者3',
            date: '2024-01-13'
          }
        ]
      }
      
      return moreData[index] || []
    }
  }
}
</script>

<style scoped>
.segment-tabs {
  width: 100%;
}

.tabs-container {
  width: 100%;
  white-space: nowrap;
  position: relative;
  background-color: #fff;
}

.tabs-wrapper {
  display: flex;
  position: relative;
  padding: 0 30rpx;
}

.tab-item {
  flex-shrink: 0;
  padding: 20rpx 30rpx;
  margin-right: 30rpx;
  position: relative;
  transition: all 0.3s ease;
}

.tab-item:last-child {
  margin-right: 0;
}

.tab-text {
  font-size: 28rpx;
  color: #666;
  transition: color 0.3s ease;
}

.tab-item.active .tab-text {
  color: #007aff;
  font-weight: 500;
}

.indicator {
  position: absolute;
  bottom: 0;
  background-color: #007aff;
  border-radius: 2rpx;
  transition: left 0.3s ease;
}

.content-swiper {
  width: 100%;
}

.swiper-item {
  width: 100%;
  height: 100%;
}

.content-wrapper {
  width: 100%;
  height: 100%;
  overflow: hidden;
}

.page-content {
  width: 100%;
  height: 100%;
  padding: 20rpx;
  box-sizing: border-box;
}

.default-content {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100%;
  color: #999;
  font-size: 28rpx;
}

/* 页面组件样式 */
.component-wrapper {
  width: 100%;
  height: 100%;
}

.recommend-page {
  width: 100%;
  height: 100%;
  background-color: #fff;
}

.content-scroll {
  height: 100%;
}

.content-list {
  padding: 20rpx;
}

.content-item {
  margin-bottom: 30rpx;
  padding: 20rpx;
  background-color: #f8f8f8;
  border-radius: 12rpx;
}

.item-info {
  display: flex;
  flex-direction: column;
}

.item-title {
  font-size: 28rpx;
  font-weight: 500;
  color: #333;
  margin-bottom: 10rpx;
}

.item-desc {
  font-size: 24rpx;
  color: #666;
  line-height: 1.4;
  margin-bottom: 15rpx;
}

.item-meta {
  display: flex;
  justify-content: space-between;
}

.meta-text {
  font-size: 22rpx;
  color: #999;
}
</style>