<template>
  <view class="segmented-control">
    <!-- 分段器容器 -->
    <scroll-view 
      class="segments-scroll" 
      scroll-x 
      :scroll-left="scrollLeft"
      :scroll-with-animation="true"
      @scroll="onScroll"
    >
      <view class="segments-container">
        <view 
          v-for="(item, index) in segments" 
          :key="index"
          class="segment-item"
          :class="{ active: activeIndex === index }"
          @click="onSegmentClick(index)"
          :id="`segment-${index}`"
        >
          <text class="segment-text">{{ item.title }}</text>
        </view>
        
        <!-- 指示器 -->
        <view 
          class="indicator"
          :style="{ 
            left: indicatorLeft + 'rpx',
            width: indicatorWidth + 'rpx'
          }"
        ></view>
      </view>
    </scroll-view>
    
    <!-- 页面内容区域 -->
    <swiper 
      class="content-swiper"
      :current="activeIndex"
      @change="onSwiperChange"
      @animationfinish="onSwiperAnimationFinish"
      :duration="300"
    >
      <swiper-item 
        v-for="(item, index) in segments" 
        :key="index"
        class="swiper-item"
      >
        <view class="page-content" v-if="loadedPages.includes(index)">
          <!-- 动态渲染页面内容 -->
          <view v-if="item.component === 'Page1'" class="page-wrapper">
            <text class="page-title">页面 {{ index + 1 }}</text>
            <text class="page-desc">{{ item.title }} 的内容</text>
            <view class="content-list">
              <view v-for="i in 20" :key="i" class="list-item">
                列表项 {{ i }}
              </view>
            </view>
          </view>
          
          <view v-else-if="item.component === 'Page2'" class="page-wrapper">
            <text class="page-title">页面 {{ index + 1 }}</text>
            <text class="page-desc">{{ item.title }} 的特殊内容</text>
            <view class="grid-content">
              <view v-for="i in 12" :key="i" class="grid-item">
                网格 {{ i }}
              </view>
            </view>
          </view>
          
          <view v-else class="page-wrapper">
            <text class="page-title">页面 {{ index + 1 }}</text>
            <text class="page-desc">{{ item.title }} 的默认内容</text>
            <view class="default-content">
              <text>这是 {{ item.title }} 页面的默认内容</text>
            </view>
          </view>
        </view>
        
        <!-- 加载占位 -->
        <view v-else class="loading-placeholder">
          <text class="loading-text">加载中...</text>
        </view>
      </swiper-item>
    </swiper>
  </view>
</template>

<script>
export default {
  name: 'SegmentedControl',
  props: {
    segments: {
      type: Array,
      default: () => [
        { title: '推荐', component: 'Page1' },
        { title: '热门', component: 'Page2' },
        { title: '最新', component: 'Page1' },
        { title: '关注', component: 'Page2' },
        { title: '收藏', component: 'Page1' },
        { title: '历史', component: 'Page2' },
        { title: '本地', component: 'Page1' }
      ]
    },
    initialIndex: {
      type: Number,
      default: 0
    }
  },
  data() {
    return {
      activeIndex: this.initialIndex,
      loadedPages: [this.initialIndex], // 已加载的页面索引
      scrollLeft: 0,
      indicatorLeft: 0,
      indicatorWidth: 20,
      segmentWidths: [], // 存储每个分段的宽度
      segmentPositions: [], // 存储每个分段的位置
      isScrolling: false
    }
  },
  mounted() {
    this.$nextTick(() => {
      this.calculateSegmentPositions()
      this.updateIndicator()
    })
  },
  methods: {
    // 计算每个分段的位置和宽度
    calculateSegmentPositions() {
      const query = uni.createSelectorQuery().in(this)
      
      this.segments.forEach((_, index) => {
        query.select(`#segment-${index}`).boundingClientRect()
      })
      
      query.exec((res) => {
        if (res && res.length > 0) {
          this.segmentWidths = res.map(item => item ? item.width : 0)
          this.segmentPositions = res.map(item => item ? item.left : 0)
          this.updateIndicator()
        }
      })
    },
    
    // 更新指示器位置
    updateIndicator() {
      if (this.segmentPositions.length === 0) return
      
      const currentSegment = this.segmentPositions[this.activeIndex]
      const currentWidth = this.segmentWidths[this.activeIndex]
      
      if (currentSegment !== undefined && currentWidth !== undefined) {
        // 计算指示器位置（居中对齐）
        this.indicatorLeft = (currentSegment - this.segmentPositions[0]) + (currentWidth - 20) / 2
        this.indicatorWidth = 20 // 固定宽度20rpx
        
        // 自动滚动到可见区域
        this.scrollToActiveSegment()
      }
    },
    
    // 滚动到当前激活的分段
    scrollToActiveSegment() {
      if (this.segmentPositions.length === 0) return
      
      const query = uni.createSelectorQuery().in(this)
      query.select('.segments-scroll').boundingClientRect()
      query.exec((res) => {
        if (res && res[0]) {
          const scrollViewWidth = res[0].width
          const segmentLeft = this.segmentPositions[this.activeIndex] - this.segmentPositions[0]
          const segmentWidth = this.segmentWidths[this.activeIndex]
          
          // 计算滚动位置，确保当前分段在可视区域中央
          let targetScrollLeft = segmentLeft + segmentWidth / 2 - scrollViewWidth / 2
          
          // 边界处理
          targetScrollLeft = Math.max(0, targetScrollLeft)
          
          this.scrollLeft = targetScrollLeft
        }
      })
    },
    
    // 分段点击事件
    onSegmentClick(index) {
      if (index === this.activeIndex) return
      
      this.activeIndex = index
      this.loadPage(index)
      this.updateIndicator()
      
      this.$emit('change', {
        index,
        item: this.segments[index]
      })
    },
    
    // Swiper 切换事件
    onSwiperChange(e) {
      const index = e.detail.current
      if (index !== this.activeIndex) {
        this.activeIndex = index
        this.loadPage(index)
        this.updateIndicator()
        
        this.$emit('change', {
          index,
          item: this.segments[index]
        })
      }
    },
    
    // Swiper 动画结束事件
    onSwiperAnimationFinish(e) {
      // 动画结束后可以执行一些清理工作
    },
    
    // 加载页面（保活机制）
    loadPage(index) {
      if (!this.loadedPages.includes(index)) {
        this.loadedPages.push(index)
      }
    },
    
    // 滚动事件
    onScroll(e) {
      // 可以在这里添加滚动相关的逻辑
    },
    
    // 外部调用：切换到指定页面
    switchTo(index) {
      if (index >= 0 && index < this.segments.length) {
        this.onSegmentClick(index)
      }
    },
    
    // 外部调用：获取当前页面索引
    getCurrentIndex() {
      return this.activeIndex
    },
    
    // 外部调用：获取已加载的页面
    getLoadedPages() {
      return [...this.loadedPages]
    }
  },
  watch: {
    segments: {
      handler() {
        this.$nextTick(() => {
          this.calculateSegmentPositions()
        })
      },
      deep: true
    }
  }
}
</script>

<style scoped>
.segmented-control {
  width: 100%;
  height: 100vh;
  display: flex;
  flex-direction: column;
  background-color: #ffffff;
}

.segments-scroll {
  width: 100%;
  height: 88rpx;
  background-color: #ffffff;
  border-bottom: 1rpx solid #f0f0f0;
}

.segments-container {
  display: flex;
  align-items: center;
  height: 88rpx;
  position: relative;
  padding: 0 30rpx;
}

.segment-item {
  flex-shrink: 0;
  padding: 0 30rpx;
  height: 88rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 30rpx;
  position: relative;
}

.segment-item:last-child {
  margin-right: 30rpx; /* 保持最后一个元素的右边距 */
}

.segment-text {
  font-size: 28rpx;
  color: #666666;
  transition: color 0.3s ease;
}

.segment-item.active .segment-text {
  color: #007AFF;
  font-weight: 600;
}

.indicator {
  position: absolute;
  bottom: 6rpx;
  height: 3rpx;
  background-color: #007AFF;
  border-radius: 2rpx;
  transition: left 0.3s ease, width 0.3s ease;
}

.content-swiper {
  flex: 1;
  width: 100%;
}

.swiper-item {
  height: 100%;
  overflow: hidden;
}

.page-content {
  height: 100%;
  overflow-y: auto;
}

.loading-placeholder {
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #f8f8f8;
}

.loading-text {
  font-size: 28rpx;
  color: #999999;
}

.page-wrapper {
  padding: 30rpx;
  height: 100%;
  box-sizing: border-box;
}

.page-title {
  font-size: 36rpx;
  font-weight: bold;
  color: #333333;
  margin-bottom: 20rpx;
  display: block;
}

.page-desc {
  font-size: 28rpx;
  color: #666666;
  margin-bottom: 40rpx;
  display: block;
}

.content-list {
  width: 100%;
}

.list-item {
  width: 100%;
  height: 80rpx;
  background-color: #f8f8f8;
  margin-bottom: 20rpx;
  border-radius: 8rpx;
  display: flex;
  align-items: center;
  padding: 0 30rpx;
  font-size: 28rpx;
  color: #333333;
}

.grid-content {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
}

.grid-item {
  width: 48%;
  height: 120rpx;
  background-color: #e8f4fd;
  margin-bottom: 20rpx;
  border-radius: 8rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 28rpx;
  color: #007AFF;
}

.default-content {
  width: 100%;
  height: 200rpx;
  background-color: #f0f0f0;
  border-radius: 8rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.default-content text {
  font-size: 28rpx;
  color: #666666;
}
</style>