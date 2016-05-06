//
//  onePasswordResetViewController.h
//  ContinueFate
//
//  Created by demon on 16/4/22.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import <UIKit/UIKit.h>//密码修改1

@interface onePasswordResetViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *telTF;//输入手机号
@property (weak, nonatomic) IBOutlet UITextField *registerTF;//输入验证码
- (IBAction)testGetCodeAction:(UIButton *)sender forEvent:(UIEvent *)event;//获取验证码
- (IBAction)nextAction:(UIButton *)sender forEvent:(UIEvent *)event;//下一步

@end
