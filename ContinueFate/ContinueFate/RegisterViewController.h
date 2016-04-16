//
//  RegisterViewController.h
//  ContinueFate
//
//  Created by demon on 16/4/16.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import <UIKit/UIKit.h>//注册页面

@interface RegisterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *UsernameTF;
@property (weak, nonatomic) IBOutlet UITextField *TelTF;
@property (weak, nonatomic) IBOutlet UITextField *PasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *PasswordAgainTF;
- (IBAction)Registered:(UIButton *)sender forEvent:(UIEvent *)event;

@end
