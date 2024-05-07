export * from './advert';

// 封装响应类型
export class ResponseData<T> {
  code: number = 0
  msg: string = ''
  data: T | null = null
}