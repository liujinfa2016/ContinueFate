//
//  onePasswordResetViewController.h
//  ContinueFate
//
//  Created by demon on 16/4/19.
//  Copyright © 2016年 XuYuan. All rights reserved.
//


//密码重置1
#import <UIKit/UIKit.h>

@interface onePasswordResetViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *TelTF;//s输入手机号
@property (weak, nonatomic) IBOutlet UITextField *VerifyTF;//输入验证码
- (IBAction)verifyAction:(UIButton *)sender forEvent:(UIEvent *)event;//获取验证码
- (IBAction)nextAction:(UIButton *)sender forEvent:(UIEvent *)event;//下一步

@end
