@Entry
@Component
struct Index {
  @State showBottomSheet: boolean = false

  build() {
    Column() {
      // 页面内容
      Text('鸿蒙底部弹窗示例')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 50 })

      Button('打开底部弹窗')
        .fontSize(18)
        .width(200)
        .height(50)
        .margin({ top: 50 })
        .onClick(() => {
          this.showBottomSheet = true
        })

      Spacer()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5')
    .bindSheet($$this.showBottomSheet, this.BottomSheetBuilder(), {
      height: 300,
      dragBar: false,
      blurStyle: BlurStyle.Regular,
      showClose: false,
      onDisappear: () => {
        this.showBottomSheet = false
      }
    })
  }

  @Builder
  BottomSheetBuilder() {
    Column() {
      // 顶部拖拽指示器
      Row()
        .width(40)
        .height(4)
        .backgroundColor('#d0d0d0')
        .borderRadius(2)
        .margin({ top: 8, bottom: 20 })

      // 弹窗标题
      Text('底部弹窗')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 20 })

      // 弹窗内容
      Column() {
        Row() {
          Image($r('app.media.icon'))
            .width(24)
            .height(24)
            .margin({ right: 12 })
          Text('选项一')
            .fontSize(16)
            .flexGrow(1)
        }
        .width('100%')
        .height(50)
        .padding({ left: 20, right: 20 })
        .onClick(() => {
          console.log('选择了选项一')
          this.showBottomSheet = false
        })

        Divider()
          .color('#e0e0e0')
          .margin({ left: 20, right: 20 })

        Row() {
          Image($r('app.media.icon'))
            .width(24)
            .height(24)
            .margin({ right: 12 })
          Text('选项二')
            .fontSize(16)
            .flexGrow(1)
        }
        .width('100%')
        .height(50)
        .padding({ left: 20, right: 20 })
        .onClick(() => {
          console.log('选择了选项二')
          this.showBottomSheet = false
        })

        Divider()
          .color('#e0e0e0')
          .margin({ left: 20, right: 20 })

        Row() {
          Image($r('app.media.icon'))
            .width(24)
            .height(24)
            .margin({ right: 12 })
          Text('选项三')
            .fontSize(16)
            .flexGrow(1)
        }
        .width('100%')
        .height(50)
        .padding({ left: 20, right: 20 })
        .onClick(() => {
          console.log('选择了选项三')
          this.showBottomSheet = false
        })
      }
      .flexGrow(1)

      // 关闭按钮
      Button('关闭')
        .width('90%')
        .height(44)
        .fontSize(16)
        .backgroundColor('#007AFF')
        .fontColor(Color.White)
        .borderRadius(8)
        .margin({ top: 20, bottom: 20 })
        .onClick(() => {
          this.showBottomSheet = false
        })
    }
    .width('100%')
    .height(300)
    .backgroundColor(Color.White)
    .borderRadius({ topLeft: 16, topRight: 16 })
    .padding({ top: 0, bottom: 0, left: 0, right: 0 })
  }
}