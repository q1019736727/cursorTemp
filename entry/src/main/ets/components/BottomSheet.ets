export interface BottomSheetOptions {
  height?: number | string
  title?: string
  showDragBar?: boolean
  showCloseButton?: boolean
  backgroundColor?: ResourceColor
  borderRadius?: number
  maskColor?: ResourceColor
  onClose?: () => void
}

@Component
export struct CustomBottomSheet {
  @State isVisible: boolean = false
  @State translateY: number = 300
  private options: BottomSheetOptions = {}
  private content: () => void = () => {}

  aboutToAppear() {
    if (this.isVisible) {
      this.showAnimation()
    }
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      // 遮罩层
      if (this.isVisible) {
        Row()
          .width('100%')
          .height('100%')
          .backgroundColor(this.options.maskColor || 'rgba(0, 0, 0, 0.5)')
          .onClick(() => {
            this.hide()
          })
          .transition(TransitionEffect.OPACITY.animation({
            duration: 300,
            curve: Curve.EaseInOut
          }))
      }

      // 弹窗内容
      if (this.isVisible) {
        Column() {
          // 拖拽指示器
          if (this.options.showDragBar !== false) {
            Row()
              .width(40)
              .height(4)
              .backgroundColor('#d0d0d0')
              .borderRadius(2)
              .margin({ top: 8, bottom: 12 })
          }

          // 标题栏
          if (this.options.title) {
            Row() {
              Text(this.options.title)
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .flexGrow(1)

              if (this.options.showCloseButton !== false) {
                Image($r('app.media.ic_close'))
                  .width(24)
                  .height(24)
                  .onClick(() => {
                    this.hide()
                  })
              }
            }
            .width('100%')
            .padding({ left: 20, right: 20, bottom: 16 })
          }

          // 自定义内容
          Column() {
            this.content()
          }
          .flexGrow(1)
          .width('100%')
        }
        .width('100%')
        .height(this.options.height || 300)
        .backgroundColor(this.options.backgroundColor || Color.White)
        .borderRadius({
          topLeft: this.options.borderRadius || 16,
          topRight: this.options.borderRadius || 16
        })
        .translate({ y: this.translateY })
        .transition(TransitionEffect.SLIDE.bottom().animation({
          duration: 300,
          curve: Curve.EaseInOut
        }))
      }
    }
    .width('100%')
    .height('100%')
  }

  // 显示弹窗
  show() {
    this.isVisible = true
    this.showAnimation()
  }

  // 隐藏弹窗
  hide() {
    this.hideAnimation()
    setTimeout(() => {
      this.isVisible = false
      this.options.onClose?.()
    }, 300)
  }

  // 显示动画
  private showAnimation() {
    animateTo({
      duration: 300,
      curve: Curve.EaseInOut
    }, () => {
      this.translateY = 0
    })
  }

  // 隐藏动画
  private hideAnimation() {
    animateTo({
      duration: 300,
      curve: Curve.EaseInOut
    }, () => {
      this.translateY = 300
    })
  }

  // 设置选项
  setOptions(options: BottomSheetOptions) {
    this.options = { ...this.options, ...options }
    return this
  }

  // 设置内容
  setContent(content: () => void) {
    this.content = content
    return this
  }
}