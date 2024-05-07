import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { defaultAd, StoreManager, USER_TOKEN } from '@common/basic/Index';
import { AdvertClass } from '@common/basic';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    // 检查是否有广告
    const store = new StoreManager(this.context);

    // 模拟请求，获取广告配置
    const ad = await new Promise<AdvertClass>((resolve, reject) => {
      setTimeout(() => {
        resolve(defaultAd)
      }, 500)
    });

    // 写入首选项
    await store.setUserAd(ad);

    // 判断是否显示广告
    if (ad.showAd) {
      // 使用子窗口，显示广告页面
      const win = await windowStage.createSubWindow('ad_window');
      await win.showWindow()
      win.setUIContent('pages/Start')
    }

    // 判断token是否存在
    const token = store.getToken();
    let url = '';
    if (token) {
      // 保存到内存中，应用内可随时读取
      AppStorage.setOrCreate(USER_TOKEN, token);
      url = 'pages/Index';
    } else {
      url = 'pages/Login/Login'
    }

    // 加载页面
    windowStage.loadContent(url, (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
