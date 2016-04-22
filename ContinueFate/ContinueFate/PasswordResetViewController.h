//
//  PasswordResetViewController.h
//  ContinueFate
//
//  Created by demon on 16/4/16.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import <UIKit/UIKit.h>//密码重置页面

@interface PasswordResetViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *telTF;
@property (weak, nonatomic) IBOutlet UITextField *passagainTF;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *newpasswordTF;
- (IBAction)obtainAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)ConfirmAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end
