<script>
export default {
  onLaunch: function() {
    console.log('App Launch')
  },
  onShow: function() {
    console.log('App Show')
  },
  onHide: function() {
    console.log('App Hide')
  }
}
</script>

<style>
/* 全局样式 */
page {
  background-color: #f5f5f5;
}

/* 重置样式 */
* {
  box-sizing: border-box;
}

/* 通用样式 */
.container {
  width: 100%;
  min-height: 100vh;
}

/* 文本样式 */
.text-primary {
  color: #007aff;
}

.text-secondary {
  color: #666;
}

.text-muted {
  color: #999;
}

/* 间距样式 */
.mt-10 {
  margin-top: 10rpx;
}

.mt-20 {
  margin-top: 20rpx;
}

.mb-10 {
  margin-bottom: 10rpx;
}

.mb-20 {
  margin-bottom: 20rpx;
}

.p-20 {
  padding: 20rpx;
}

.p-30 {
  padding: 30rpx;
}
</style>