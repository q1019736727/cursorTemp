@Entry
@Component
struct BottomSheetDemo {
  @State showSheet1: boolean = false
  @State showSheet2: boolean = false
  @State showSheet3: boolean = false

  build() {
    Column() {
      Text('鸿蒙底部弹窗演示')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 60, bottom: 40 })

      // 示例按钮
      Column({ space: 20 }) {
        Button('基础底部弹窗')
          .width('80%')
          .height(50)
          .fontSize(16)
          .onClick(() => {
            this.showSheet1 = true
          })

        Button('带标题的弹窗')
          .width('80%')
          .height(50)
          .fontSize(16)
          .onClick(() => {
            this.showSheet2 = true
          })

        Button('自定义样式弹窗')
          .width('80%')
          .height(50)
          .fontSize(16)
          .onClick(() => {
            this.showSheet3 = true
          })
      }
      .width('100%')

      Spacer()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f8f9fa')
    .bindSheet($$this.showSheet1, this.BasicSheetBuilder(), {
      height: 300,
      dragBar: true,
      showClose: false,
      backgroundColor: Color.White,
      onDisappear: () => {
        this.showSheet1 = false
      }
    })
    .bindSheet($$this.showSheet2, this.TitleSheetBuilder(), {
      height: 350,
      dragBar: false,
      showClose: true,
      backgroundColor: Color.White,
      onDisappear: () => {
        this.showSheet2 = false
      }
    })
    .bindSheet($$this.showSheet3, this.CustomSheetBuilder(), {
      height: 400,
      dragBar: true,
      showClose: false,
      backgroundColor: '#ffffff',
      onDisappear: () => {
        this.showSheet3 = false
      }
    })
  }

  @Builder
  BasicSheetBuilder() {
    Column() {
      // 内容区域
      Column({ space: 16 }) {
        Text('基础弹窗内容')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .margin({ top: 20 })

        Text('这是一个从底部弹出的半屏弹窗，高度为300px，左右贴着屏幕边缘。')
          .fontSize(14)
          .fontColor('#666666')
          .textAlign(TextAlign.Center)
          .margin({ left: 20, right: 20 })

        // 操作按钮
        Row({ space: 12 }) {
          Button('取消')
            .width(100)
            .height(40)
            .fontSize(14)
            .backgroundColor('#f0f0f0')
            .fontColor('#333333')
            .onClick(() => {
              this.showSheet1 = false
            })

          Button('确认')
            .width(100)
            .height(40)
            .fontSize(14)
            .backgroundColor('#007AFF')
            .fontColor(Color.White)
            .onClick(() => {
              console.log('确认操作')
              this.showSheet1 = false
            })
        }
        .margin({ top: 30 })
      }
      .width('100%')
      .flexGrow(1)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  TitleSheetBuilder() {
    Column() {
      // 标题栏
      Row() {
        Text('选择操作')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
        
        Spacer()
        
        Image($r('app.media.icon'))
          .width(24)
          .height(24)
          .onClick(() => {
            this.showSheet2 = false
          })
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 16, bottom: 16 })

      Divider()
        .color('#e0e0e0')

      // 选项列表
      Column() {
        this.OptionItem('拍照', () => {
          console.log('选择拍照')
          this.showSheet2 = false
        })

        Divider().color('#f0f0f0').margin({ left: 20, right: 20 })

        this.OptionItem('从相册选择', () => {
          console.log('选择相册')
          this.showSheet2 = false
        })

        Divider().color('#f0f0f0').margin({ left: 20, right: 20 })

        this.OptionItem('文件管理器', () => {
          console.log('选择文件')
          this.showSheet2 = false
        })
      }
      .flexGrow(1)
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  CustomSheetBuilder() {
    Column() {
      // 自定义内容
      Column({ space: 20 }) {
        // 图标和标题
        Column({ space: 12 }) {
          Image($r('app.media.icon'))
            .width(48)
            .height(48)
          
          Text('自定义弹窗')
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
          
          Text('这是一个自定义样式的底部弹窗示例')
            .fontSize(14)
            .fontColor('#888888')
            .textAlign(TextAlign.Center)
        }
        .margin({ top: 30 })

        // 功能列表
        Column({ space: 0 }) {
          this.FeatureItem('🏠', '首页', '返回应用首页')
          this.FeatureItem('⚙️', '设置', '打开应用设置')
          this.FeatureItem('📞', '联系我们', '获取技术支持')
          this.FeatureItem('ℹ️', '关于', '查看应用信息')
        }
        .backgroundColor('#f8f9fa')
        .borderRadius(12)
        .margin({ left: 20, right: 20, top: 20 })

        // 底部按钮
        Button('关闭')
          .width('90%')
          .height(48)
          .fontSize(16)
          .backgroundColor('#ff6b6b')
          .fontColor(Color.White)
          .borderRadius(24)
          .margin({ top: 20 })
          .onClick(() => {
            this.showSheet3 = false
          })
      }
      .width('100%')
      .flexGrow(1)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  OptionItem(title: string, onTap: () => void) {
    Row() {
      Text(title)
        .fontSize(16)
        .fontColor('#333333')
      
      Spacer()
      
      Text('>')
        .fontSize(16)
        .fontColor('#cccccc')
    }
    .width('100%')
    .height(50)
    .padding({ left: 20, right: 20 })
    .onClick(onTap)
  }

  @Builder
  FeatureItem(icon: string, title: string, subtitle: string) {
    Row() {
      Text(icon)
        .fontSize(24)
        .margin({ right: 16 })
      
      Column({ space: 4 }) {
        Text(title)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .alignSelf(ItemAlign.Start)
        
        Text(subtitle)
          .fontSize(12)
          .fontColor('#888888')
          .alignSelf(ItemAlign.Start)
      }
      .alignItems(HorizontalAlign.Start)
      .flexGrow(1)
      
      Text('>')
        .fontSize(16)
        .fontColor('#cccccc')
    }
    .width('100%')
    .height(60)
    .padding({ left: 16, right: 16 })
    .onClick(() => {
      console.log(`点击了${title}`)
      this.showSheet3 = false
    })
  }
}