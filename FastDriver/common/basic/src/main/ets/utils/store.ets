import { preferences } from '@kit.ArkData';
import { DRIVER_STORE } from '../constants';
import { AdvertClass } from '../models';

// 默认广告选项
const defaultAd: AdvertClass = {
  showAd: true,
  adTime: 5,
  adImg: $r('app.media.start')
};

export class StoreManager {
  context: Context

  constructor(context: Context) {
    this.context = context;
  }

  getStore() {
    return preferences.getPreferencesSync(this.context, { name: DRIVER_STORE });
  }

  async setUserAd(ad: AdvertClass) {
    const store = this.getStore();
    store.putSync(DRIVER_STORE, JSON.stringify(ad));
    await store.flush();
  }

  getUserAd() {
    const store = this.getStore();
    return JSON.parse(store.getSync(DRIVER_STORE, JSON.stringify(defaultAd)) as string) as AdvertClass;
  }
}