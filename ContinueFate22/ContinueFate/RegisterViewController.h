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
@property (weak, nonatomic) IBOutlet UITextField *TelTF;//手机号
@property (weak, nonatomic) IBOutlet UITextField *PasswordTF;//密码
@property (weak, nonatomic) IBOutlet UITextField *PasswordAgainTF;//再次输入密码
@property (weak, nonatomic) IBOutlet UITextField *registertf;//输入验证码
- (IBAction)TestGetCodeAction:(UIButton *)sender forEvent:(UIEvent *)event;//获取验证码
- (IBAction)Registered:(UIButton *)sender forEvent:(UIEvent *)event;//注册


@end
