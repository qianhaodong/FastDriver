import { StoreManager, USER_TOKEN } from '@common/basic/Index';
import { login } from '../../api';
import { LoginFormModel } from '../../models';
import { promptAction, router } from '@kit.ArkUI';

@Entry
@Component
struct Login {
  @State loading: boolean = false;
  @State loginForm: LoginFormModel = new LoginFormModel({
    account: 'bruceDriver',
    password: ''
  });
  // 高级类型Partial：可以快速把某个接口类型中定义的所有属性变成可选的。
  // @State loginForm: Partial<LoginForm> = {};

  @Styles loginStyle() {
    .backgroundColor('#fff')
    .border({ color: $r('app.color.background_divider'), width: { bottom: 1 } })
    .width('100%')
    .height(58)
    .borderRadius(0)
  }

  getBtnEnable() {
    if (this.loginForm.account !== '' && this.loginForm.password !== '') {
      return true;
    }
    return false;
  }

  // 登录
  async login() {
    this.loading = true;
    try {
      const token = await login(this.loginForm);

      // 登录成功提示
      promptAction.showToast({ message: '登录成功' });

      // 登录成功，保存token
      const store = new StoreManager(getContext(this));
      await store.setToken(token);
      AppStorage.set(USER_TOKEN, token);

      // 跳转到首页
      router.replaceUrl({
        url: 'pages/Index'
      });
    } catch (error) {}
    this.loading = false;
  }

  build() {
    Column() {
      // 顶部标题
      Text("小时达").fontColor($r('app.color.text_primary')).fontSize(18).height(25)
      // 账号登录
      Row() {
        Text('账号登录').fontColor($r('app.color.text_primary')).fontSize(24).fontWeight(FontWeight.Bold)
        Row() {
          Text("账号登录").fontColor($r('app.color.primary')).fontSize(16).fontWeight(FontWeight.Bold)
          Image($r("app.media.ic_angle")).width(10).height(10).margin({ left: 5 })
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ top: 50, bottom: 50 })

      // 用户名输入框
      TextInput({ text: this.loginForm.account, placeholder: '请输入账号' })
        .loginStyle()
        .onChange((value) => {
          this.loginForm.account = value;
        })

      // 密码框
      TextInput({ placeholder: '请输入密码' })
        .loginStyle()
        .type(InputType.Password) // 密码框
        .showPasswordIcon(true) // 显示密码按钮
        .onChange((value) => {
          this.loginForm.password = value;
        })

      // 登录按钮
      Button({ type: ButtonType.Capsule }) {
        Row() {
          if (this.loading) {
            LoadingProgress().width(20).height(20).margin({ right: 12 }).color($r('app.color.white'))
          }
          Text('登录').fontColor($r('app.color.white'))
        }
      }
      .backgroundColor($r('app.color.primary'))
      .width('100%')
      .height(50)
      .margin({ top: 50 })
      .enabled(this.getBtnEnable())
      .onClick(() => {
        this.login();
      })
    }
    .padding({ left: 32, right: 32 })
    .margin({ top: 40 })
  }
}