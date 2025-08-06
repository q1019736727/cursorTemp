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
        },
        {
          title: '分类',
          component: 'CategoryPage'
        },
        {
          title: '我的',
          component: 'MyPage'
        },
        {
          title: '设置',
          component: 'SettingsPage'
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

<style scoped>
.container {
  width: 100%;
  min-height: 100vh;
  background-color: #f5f5f5;
}
</style>