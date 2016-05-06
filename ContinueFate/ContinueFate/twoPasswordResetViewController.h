//
//  twoPasswordResetViewController.h
//  ContinueFate
//
//  Created by demon on 16/4/22.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface twoPasswordResetViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *TelLable;//我们已将验证码发送至您的手机号：765432654
@property (weak, nonatomic) IBOutlet UITextField *nPasswordTF;//设置新密码
@property (weak, nonatomic) IBOutlet UITextField *nPasswordAgainTF;//再次输入新密码
- (IBAction)Return:(UIBarButtonItem *)sender;//返回
@property(strong,nonatomic) NSString *Tell;//容器
- (IBAction)confirmAction:(UIButton *)sender forEvent:(UIEvent *)event;//确认修改

@end
