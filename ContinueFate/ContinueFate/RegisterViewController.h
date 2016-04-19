//
//  RegisterViewController.h
//  ContinueFate
//
//  Created by demon on 16/4/16.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import <UIKit/UIKit.h>//注册页面

@interface RegisterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *UsernameTF;//用户名
@property (weak, nonatomic) IBOutlet UITextField *TelTF;    //电话号码
@property (weak, nonatomic) IBOutlet UITextField *PasswordTF;//设置密码
@property (weak, nonatomic) IBOutlet UITextField *PasswordAgainTF;//再次输入密码
@property (weak, nonatomic) IBOutlet UITextField *verifyTF;//输入验证码
- (IBAction)verifyAction:(UIButton *)sender forEvent:(UIEvent *)event;//获取验证码
- (IBAction)Registered:(UIButton *)sender forEvent:(UIEvent *)event;//确认注册
@end
