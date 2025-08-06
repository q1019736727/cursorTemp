<template>
  <view class="demo-page">
    <!-- 演示标题 -->
    <view class="demo-header">
      <text class="demo-title">分段器组件演示</text>
      <text class="demo-subtitle">支持滑动切换、保活机制、自动滚动</text>
    </view>
    
    <!-- 分段器组件 -->
    <SegmentedControl 
      ref="segmentedControl"
      :segments="segmentData"
      :initial-index="0"
      @change="onSegmentChange"
    />
    
    <!-- 操作按钮区域 -->
    <view class="action-buttons">
      <button class="action-btn" @click="switchToIndex(0)">切换到推荐</button>
      <button class="action-btn" @click="switchToIndex(3)">切换到关注</button>
      <button class="action-btn" @click="switchToIndex(6)">切换到本地</button>
      <button class="action-btn" @click="showLoadedPages">查看已加载页面</button>
    </view>
    
    <!-- 状态信息 -->
    <view class="status-info">
      <text class="status-text">当前页面：{{ currentPageInfo }}</text>
      <text class="status-text">已加载页面：{{ loadedPagesInfo }}</text>
    </view>
  </view>
</template>

<script>
import SegmentedControl from '../components/SegmentedControl.vue'

export default {
  name: 'SegmentedDemo',
  components: {
    SegmentedControl
  },
  data() {
    return {
      segmentData: [
        { title: '推荐', component: 'Page1' },
        { title: '热门视频', component: 'Page2' },
        { title: '最新资讯', component: 'Page1' },
        { title: '关注动态', component: 'Page2' },
        { title: '我的收藏', component: 'Page1' },
        { title: '浏览历史', component: 'Page2' },
        { title: '本地下载', component: 'Page1' },
        { title: '精选内容', component: 'Page2' },
        { title: '热门话题', component: 'Page1' }
      ],
      currentIndex: 0,
      loadedPages: []
    }
  },
  computed: {
    currentPageInfo() {
      return `${this.currentIndex + 1} - ${this.segmentData[this.currentIndex]?.title || '未知'}`
    },
    loadedPagesInfo() {
      return this.loadedPages.map(index => 
        `${index + 1}(${this.segmentData[index]?.title || '未知'})`
      ).join(', ')
    }
  },
  methods: {
    // 分段器切换回调
    onSegmentChange(e) {
      console.log('分段器切换:', e)
      this.currentIndex = e.index
      this.updateLoadedPages()
    },
    
    // 程序化切换到指定索引
    switchToIndex(index) {
      if (this.$refs.segmentedControl) {
        this.$refs.segmentedControl.switchTo(index)
      }
    },
    
    // 显示已加载的页面
    showLoadedPages() {
      if (this.$refs.segmentedControl) {
        const loaded = this.$refs.segmentedControl.getLoadedPages()
        uni.showToast({
          title: `已加载 ${loaded.length} 个页面`,
          icon: 'none',
          duration: 2000
        })
      }
    },
    
    // 更新已加载页面信息
    updateLoadedPages() {
      if (this.$refs.segmentedControl) {
        this.loadedPages = this.$refs.segmentedControl.getLoadedPages()
      }
    }
  },
  mounted() {
    this.updateLoadedPages()
  }
}
</script>

<style scoped>
.demo-page {
  width: 100%;
  height: 100vh;
  background-color: #ffffff;
  display: flex;
  flex-direction: column;
}

.demo-header {
  padding: 40rpx 30rpx 20rpx;
  background-color: #f8f9fa;
  border-bottom: 1rpx solid #e9ecef;
}

.demo-title {
  font-size: 32rpx;
  font-weight: bold;
  color: #333333;
  display: block;
  margin-bottom: 10rpx;
}

.demo-subtitle {
  font-size: 24rpx;
  color: #666666;
  display: block;
}

.action-buttons {
  position: fixed;
  bottom: 200rpx;
  left: 0;
  right: 0;
  padding: 0 30rpx;
  background-color: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10rpx);
  display: flex;
  flex-wrap: wrap;
  gap: 20rpx;
  justify-content: space-between;
  z-index: 1000;
}

.action-btn {
  flex: 1;
  min-width: 160rpx;
  height: 60rpx;
  line-height: 60rpx;
  background-color: #007AFF;
  color: #ffffff;
  border: none;
  border-radius: 8rpx;
  font-size: 24rpx;
  text-align: center;
}

.action-btn:active {
  background-color: #0056CC;
}

.status-info {
  position: fixed;
  bottom: 80rpx;
  left: 0;
  right: 0;
  padding: 20rpx 30rpx;
  background-color: rgba(0, 0, 0, 0.8);
  backdrop-filter: blur(10rpx);
  z-index: 1000;
}

.status-text {
  font-size: 24rpx;
  color: #ffffff;
  display: block;
  margin-bottom: 8rpx;
  line-height: 1.4;
}

.status-text:last-child {
  margin-bottom: 0;
}
</style>