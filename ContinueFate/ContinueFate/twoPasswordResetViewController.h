//
//  twoPasswordResetViewController.h
//  ContinueFate
//
//  Created by demon on 16/4/19.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

//密码重置2
#import <UIKit/UIKit.h>

@interface twoPasswordResetViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *telLab;//已发送验证码的手机号码－eg:657689097
@property (weak, nonatomic) IBOutlet UITextField *nuewPWTF;//设置新密码
@property (weak, nonatomic) IBOutlet UITextField *PWAgainTF;//再次输入密码
- (IBAction)confirmAction:(UIButton *)sender forEvent:(UIEvent *)event;//确认修改

@end
