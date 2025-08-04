# 鸿蒙ArkTS底部弹窗组件

这是一个鸿蒙ArkTS开发的底部弹窗组件示例，实现了从底部动画弹出的半屏弹窗效果。

## 功能特性

- ✅ 从底部平滑动画弹出
- ✅ 高度为300px（可自定义）
- ✅ 左右贴着屏幕边缘
- ✅ 支持拖拽指示器
- ✅ 支持点击遮罩关闭
- ✅ 自定义标题和内容
- ✅ 多种样式配置

## 文件结构

```
entry/src/main/ets/
├── pages/
│   ├── Index.ets              # 基础示例页面
│   └── BottomSheetDemo.ets    # 完整演示页面
└── components/
    └── BottomSheet.ets        # 自定义底部弹窗组件
```

## 使用方法

### 1. 基础用法（使用系统bindSheet）

```typescript
@Entry
@Component
struct Index {
  @State showBottomSheet: boolean = false

  build() {
    Column() {
      Button('打开底部弹窗')
        .onClick(() => {
          this.showBottomSheet = true
        })
    }
    .bindSheet($$this.showBottomSheet, this.BottomSheetBuilder(), {
      height: 300,
      dragBar: true,
      showClose: false,
      backgroundColor: Color.White,
      onDisappear: () => {
        this.showBottomSheet = false
      }
    })
  }

  @Builder
  BottomSheetBuilder() {
    Column() {
      Text('弹窗内容')
        .fontSize(18)
        .margin(20)
      
      Button('关闭')
        .onClick(() => {
          this.showBottomSheet = false
        })
    }
    .width('100%')
    .height(300)
  }
}
```

### 2. 高级用法（自定义组件）

```typescript
import { CustomBottomSheet, BottomSheetOptions } from '../components/BottomSheet'

@Entry
@Component
struct MyPage {
  private bottomSheet: CustomBottomSheet = new CustomBottomSheet()

  build() {
    Stack() {
      // 页面内容
      Column() {
        Button('显示弹窗')
          .onClick(() => {
            this.bottomSheet
              .setOptions({
                height: 300,
                title: '自定义弹窗',
                showDragBar: true,
                backgroundColor: Color.White,
                onClose: () => {
                  console.log('弹窗关闭')
                }
              })
              .setContent(() => {
                this.CustomContent()
              })
              .show()
          })
      }

      // 弹窗组件
      CustomBottomSheet()
    }
  }

  @Builder
  CustomContent() {
    Column() {
      Text('自定义内容')
      // ... 更多内容
    }
  }
}
```

## 配置选项

### BottomSheetOptions

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| height | number \| string | 300 | 弹窗高度 |
| title | string | - | 弹窗标题 |
| showDragBar | boolean | true | 是否显示拖拽指示器 |
| showCloseButton | boolean | true | 是否显示关闭按钮 |
| backgroundColor | ResourceColor | Color.White | 背景颜色 |
| borderRadius | number | 16 | 圆角大小 |
| maskColor | ResourceColor | 'rgba(0,0,0,0.5)' | 遮罩颜色 |
| onClose | () => void | - | 关闭回调 |

## 动画效果

- **弹出动画**: 从底部向上滑动，持续时间300ms
- **消失动画**: 向下滑动到底部，持续时间300ms
- **遮罩动画**: 透明度渐变效果
- **缓动曲线**: 使用EaseInOut曲线，提供平滑的动画体验

## 最佳实践

1. **高度设置**: 建议高度不超过屏幕的70%，保持良好的用户体验
2. **内容布局**: 使用flexGrow(1)让内容区域自适应剩余空间
3. **交互反馈**: 为可点击元素添加适当的视觉反馈
4. **无障碍支持**: 为重要元素添加语义化描述

## 注意事项

- 弹窗会自动贴着屏幕左右边缘（width: '100%'）
- 支持点击遮罩层关闭弹窗
- 可以通过拖拽指示器提示用户可以手势操作
- 建议在onDisappear回调中重置状态

## 运行项目

1. 在DevEco Studio中打开项目
2. 连接鸿蒙设备或启动模拟器
3. 点击运行按钮
4. 在应用中点击按钮测试底部弹窗效果
