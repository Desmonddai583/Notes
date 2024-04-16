// 此方法是用于判断是不是取消的字符串
export function isCancel(message: any): message is Cancel {
  return message instanceof Cancel;
}
export class Cancel {
  constructor(public message: string) {}
}
export class CancelTokenStatic {
  public resolve: any;

  source() {
    return {
      // token 就是一个promise方法
      token: new Promise<Cancel>((resolve, reject) => {
        this.resolve = resolve;
      }),
      // cancel就是让这个promise成功而已
      cancel: (message: string) => {
        this.resolve(new Cancel(message));
      },
    };
  }
}
