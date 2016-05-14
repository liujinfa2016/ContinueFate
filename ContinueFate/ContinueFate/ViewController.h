//
//  ViewController.h
//  ContinueFate
//
//  Created by 刘金发 on 16/4/16.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import <UIKit/UIKit.h>//登录页面

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameTF;//用户名
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;//密码
- (IBAction)loginAction:(id)sender forEvent:(UIEvent *)event;//登录
- (IBAction)ReturnAction:(UIBarButtonItem *)sender;//返回侧滑
@property (weak, nonatomic) IBOutlet UIButton *QQLoginButton;
- (IBAction)QQLoginAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end

