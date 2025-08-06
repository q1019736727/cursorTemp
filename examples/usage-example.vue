<template>
  <view class="example-page">
    <!-- 分段器组件 -->
    <segment-tabs 
      :tabs="tabs" 
      :default-index="currentTabIndex"
      :content-height="contentHeight"
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
</style>