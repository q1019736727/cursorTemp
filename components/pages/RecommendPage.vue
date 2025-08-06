<template>
  <view class="recommend-page">
    <view class="page-header">
      <text class="page-title">推荐内容</text>
    </view>
    
    <scroll-view class="content-scroll" scroll-y>
      <view class="content-list">
        <view 
          v-for="(item, index) in recommendList" 
          :key="index"
          class="content-item"
        >
          <image class="item-image" :src="item.image" mode="aspectFill"></image>
          <view class="item-info">
            <text class="item-title">{{ item.title }}</text>
            <text class="item-desc">{{ item.description }}</text>
            <view class="item-meta">
              <text class="meta-text">{{ item.author }}</text>
              <text class="meta-text">{{ item.date }}</text>
            </view>
          </view>
        </view>
      </view>
    </scroll-view>
  </view>
</template>

<script>
export default {
  name: 'RecommendPage',
  data() {
    return {
      recommendList: [
        {
          title: '推荐内容标题1',
          description: '这是推荐内容的详细描述，展示一些示例内容...',
          author: '作者1',
          date: '2024-01-15',
          image: '/static/images/placeholder.jpg'
        },
        {
          title: '推荐内容标题2',
          description: '这是推荐内容的详细描述，展示一些示例内容...',
          author: '作者2',
          date: '2024-01-14',
          image: '/static/images/placeholder.jpg'
        },
        {
          title: '推荐内容标题3',
          description: '这是推荐内容的详细描述，展示一些示例内容...',
          author: '作者3',
          date: '2024-01-13',
          image: '/static/images/placeholder.jpg'
        }
      ]
    }
  }
}
</script>

<style scoped>
.recommend-page {
  width: 100%;
  height: 100%;
  background-color: #fff;
}

.page-header {
  padding: 20rpx 30rpx;
  border-bottom: 1rpx solid #eee;
}

.page-title {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
}

.content-scroll {
  height: calc(100% - 80rpx);
}

.content-list {
  padding: 20rpx;
}

.content-item {
  display: flex;
  margin-bottom: 30rpx;
  padding: 20rpx;
  background-color: #f8f8f8;
  border-radius: 12rpx;
}

.item-image {
  width: 120rpx;
  height: 120rpx;
  border-radius: 8rpx;
  margin-right: 20rpx;
  background-color: #ddd;
}

.item-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
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