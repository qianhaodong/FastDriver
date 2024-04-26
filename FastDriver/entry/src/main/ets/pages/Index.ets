import { DRIVER_STORE } from '@common/basic/Index';

@Entry
@Component
struct Index {
  @State message: string = DRIVER_STORE;

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}