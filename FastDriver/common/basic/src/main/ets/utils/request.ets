import { http } from '@kit.NetworkKit';
import { BASE_URL, USER_TOKEN } from '../constants';
import { promptAction, router } from '@kit.ArkUI';
import { StoreManager } from '.';
import { ResponseData } from '../models';

// 封装请求方法
async function requestHttp<T>(url: string, method: http.RequestMethod = http.RequestMethod.GET, data?: object): Promise<T> {
  // 请求url
  let urlStr = BASE_URL + url;

  // 创建请求对象
  const httpRequest = http.createHttp();

  // 请求参数
  const config: http.HttpRequestOptions = {
    method,
    header: {
      'Content-Type': 'application/json',
      // token
      Authorization: AppStorage.get(USER_TOKEN) || ''
    },
    readTimeout: 10000, // 超时时间
    extraData: method === http.RequestMethod.POST ? data : '',
  };

  // get请求拼接参数
  if (method === http.RequestMethod.GET && data) {
    urlStr += '?' + Object.keys(data as object).map(item => `${item}=${data[item]}`).join('&');
  }

  // 请求处理
  try {
    const result = await httpRequest.request(urlStr, config);

    // 判断Http状态码
    if (result.responseCode === 401) {
      // 401表示token无效
      // 错误提示
      promptAction.showToast({ message: '登录失效' });

      // 清空token
      const store = new StoreManager(getContext());
      store.setToken('');
      AppStorage.set(USER_TOKEN, '');

      // 跳转到登录页面
      router.pushUrl({
        url: 'pages/Login/Login'
      });
      return Promise.reject(new Error('登录失效')); // 请求终止
    } else if (result.responseCode === 404) {
      // 请求地址错误
      promptAction.showToast({ message: '请求地址错误' })
      return Promise.reject(new Error('请求地址错误'));
    } else {
      // 判断业务状态码
      const res = JSON.parse(result.result as string) as ResponseData<T>;
      if (res.code === 200) {
        return res.data as T;
      } else {
        // 业务报错
        promptAction.showToast({ message: '服务器异常' });
        return Promise.reject(new Error(res.msg)); // 业务错误 请求终止
      }
    }
  } catch (error) {
    promptAction.showToast({ message: error.message });
    return Promise.reject(error);
  }
}

export class Request {
  static get<T>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, http.RequestMethod.GET, data);
  }

  static post<T>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, http.RequestMethod.POST, data);
  }

  static put<T>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, http.RequestMethod.PUT, data);
  }

  static delete<T>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, http.RequestMethod.DELETE, data);
  }
}