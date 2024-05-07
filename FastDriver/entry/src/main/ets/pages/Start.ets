import { AdvertClass, StoreManager } from '@common/basic'
import { window } from '@kit.ArkUI';

@Entry
@Component
struct Start {
  store: StoreManager = new StoreManager(getContext(this));
  timer: number = -1;

  @State adObj: AdvertClass  = {
    showAd: false,
    adTime: 0
  };

  async aboutToAppear() {
    this.adObj = await this.store.getUserAd();
    this.timer = setInterval(() => {
      if(this.adObj.adTime === 0) {
        clearInterval(this.timer);
        this.closeWin();
        return;
      }
      this.adObj.adTime--;
    }, 1000);
  }

  aboutToDisappear() {
    clearInterval(this.timer);
  }

  closeWin() {
    // 销毁子窗口
    window.findWindow('ad_window').destroyWindow();
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      Image(this.adObj.adImg)
        .objectFit(ImageFit.Cover)
      Text(`${this.adObj.adTime}秒后跳过`)
        .padding({ left: 10, right: 10 })
        .margin({ right: 20, top: 20 })
        .height(30)
        .fontSize(14)
        .borderRadius(15)
        .backgroundColor($r("app.color.background_page"))
        .textAlign(TextAlign.Center)
        .onClick(() => {
          this.closeWin()
        })
    }
    .height('100%')
    .width('100%')
  }
}