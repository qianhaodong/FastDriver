import { preferences } from '@kit.ArkData';
import { DRIVER_AD, DRIVER_STORE, USER_TOKEN } from '../constants';
import { AdvertClass } from '../models';

// 默认广告选项
export const defaultAd: AdvertClass = {
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

  // 设置广告信息
  async setUserAd(ad: AdvertClass) {
    const store = this.getStore();
    store.putSync(DRIVER_AD, JSON.stringify(ad));
    await store.flush();
  }

  // 读取广告信息
  getUserAd() {
    const store = this.getStore();
    return JSON.parse(store.getSync(DRIVER_AD, JSON.stringify(defaultAd)) as string) as AdvertClass;
  }

  // 设置token
  async setToken(token: string) {
    const store = this.getStore();
    store.putSync(USER_TOKEN, token);
    await store.flush();
  }

  // 读取token
  getToken() {
    const store = this.getStore();
    return store.getSync(USER_TOKEN, '') as string;
  }
}