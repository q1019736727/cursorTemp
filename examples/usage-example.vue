<template>
  <view class="example-page">
    <!-- 页面头部 -->
    <view class="page-header">
      <text class="page-title">分段器使用示例</text>
      <text class="page-subtitle">支持指示器跟随、页面保活、手动滑动</text>
    </view>
    
    <!-- 分段器组件 -->
    <segment-tabs 
      :tabs="tabs" 
      :default-index="currentTabIndex"
      :content-height="contentHeight"
      @change="handleTabChange"
    />
    
    <!-- 控制面板 -->
    <view class="control-panel">
      <view class="control-item">
        <text class="control-label">当前选中:</text>
        <text class="control-value">{{ currentTabTitle }}</text>
      </view>
      <view class="control-item">
        <text class="control-label">已加载页面:</text>
        <text class="control-value">{{ loadedPagesCount }}个</text>
      </view>
      <view class="control-buttons">
        <button 
          class="control-btn" 
          @click="switchToTab(0)"
          :class="{ active: currentTabIndex === 0 }"
        >
          推荐
        </button>
        <button 
          class="control-btn" 
          @click="switchToTab(2)"
          :class="{ active: currentTabIndex === 2 }"
        >
          最新
        </button>
        <button 
          class="control-btn" 
          @click="switchToTab(5)"
          :class="{ active: currentTabIndex === 5 }"
        >
          设置
        </button>
      </view>
    </view>
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
      currentTabIndex: 0,
      contentHeight: 500,
      tabs: [
        {
          title: '推荐',
          component: 'RecommendPage',
          description: '个性化推荐内容'
        },
        {
          title: '热门',
          component: 'HotPage',
          description: '当前热门内容'
        },
        {
          title: '最新',
          component: 'LatestPage',
          description: '最新发布内容'
        },
        {
          title: '分类',
          component: 'CategoryPage',
          description: '内容分类浏览'
        },
        {
          title: '我的',
          component: 'MyPage',
          description: '个人中心'
        },
        {
          title: '设置',
          component: 'SettingsPage',
          description: '应用设置'
        }
      ]
    }
  },
  computed: {
    currentTabTitle() {
      return this.tabs[this.currentTabIndex]?.title || '未知'
    },
    loadedPagesCount() {
      // 这里应该从组件内部获取，这里只是示例
      return Math.min(this.currentTabIndex + 1, this.tabs.length)
    }
  },
  methods: {
    handleTabChange(e) {
      this.currentTabIndex = e.index
      console.log('切换到:', e.item.title, '索引:', e.index)
      
      // 可以在这里添加页面切换的逻辑
      uni.showToast({
        title: `切换到${e.item.title}`,
        icon: 'none',
        duration: 1000
      })
    },
    
    switchToTab(index) {
      // 通过ref调用组件方法（需要给组件添加ref）
      if (this.$refs.segmentTabs) {
        this.$refs.segmentTabs.switchTab(index)
      }
    }
  }
}
</script>

<style scoped>
.example-page {
  width: 100%;
  min-height: 100vh;
  background-color: #f5f5f5;
}

.page-header {
  padding: 40rpx 30rpx 20rpx;
  background-color: #fff;
  border-bottom: 1rpx solid #eee;
}

.page-title {
  display: block;
  font-size: 36rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 10rpx;
}

.page-subtitle {
  display: block;
  font-size: 24rpx;
  color: #666;
}

.control-panel {
  margin-top: 20rpx;
  padding: 30rpx;
  background-color: #fff;
  border-radius: 12rpx;
}

.control-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20rpx;
}

.control-label {
  font-size: 28rpx;
  color: #666;
}

.control-value {
  font-size: 28rpx;
  color: #333;
  font-weight: 500;
}

.control-buttons {
  display: flex;
  gap: 20rpx;
  margin-top: 30rpx;
}

.control-btn {
  flex: 1;
  height: 60rpx;
  line-height: 60rpx;
  text-align: center;
  background-color: #f0f0f0;
  color: #666;
  border-radius: 8rpx;
  font-size: 24rpx;
  border: none;
}

.control-btn.active {
  background-color: #007aff;
  color: #fff;
}
</style>