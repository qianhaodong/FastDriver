import { Request } from '@common/basic'
import { LoginFormModel } from '../models'

export const login = (loginForm: LoginFormModel) => {
  return Request.post<string>('/login/account', loginForm);
}