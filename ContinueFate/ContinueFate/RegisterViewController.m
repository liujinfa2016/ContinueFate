//
//  RegisterViewController.m
//  ContinueFate
//
//  Created by demon on 16/4/16.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "RegisterViewController.h"
#import <SMS_SDK/SMSSDK.h>
@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//注册
- (IBAction)Registered:(UIButton *)sender forEvent:(UIEvent *)event { NSString *username = _UsernameTF.text;
    NSString *password = _PasswordTF.text;
    NSString *PasswordAgainTF = _PasswordAgainTF.text;
    NSString *TelTF =_TelTF.text;
    NSString *registertf = _registertf.text;
    
    
    if (username.length == 0 || password.length == 0 || PasswordAgainTF.length == 0 || registertf.length == 0) {
        [Utilities popUpAlertViewWithMsg:@"请输入完整信息" andTitle:nil onView:self];
        return;
    }
    if (TelTF.length != 11 ) {
        [Utilities popUpAlertViewWithMsg:@"请输入11位手机号" andTitle:nil onView:self];
        return;
    }
    
    if (![password isEqualToString:PasswordAgainTF]) {
        [Utilities popUpAlertViewWithMsg:@"您两次输入的密码不同，请重新输入" andTitle:nil onView:self];
        return;
    }
    NSLog(@"%@",username);
    NSLog(@"%@",password);
    NSLog(@"%@",TelTF);
    
    [SMSSDK commitVerificationCode:_registertf.text phoneNumber:_TelTF.text zone:@"86" result:^(NSError *error) {
        NSLog(@"提交验证");
    }];
    //菊花
    UIActivityIndicatorView *avi = [Utilities getCoverOnView:self.view];
    NSDictionary *parameters = @{@"code":username,@"pwd":password,@"mobile":TelTF};
    [RequestAPI postURL:@"/register" withParameters:parameters success:^(id responseObject) {
        NSLog(@"responseObject :%@",responseObject);
        [avi stopAnimating];
        switch ([responseObject[@"resultFlag"]integerValue]) {
            case 8001:
                NSLog(@"注册成功");
                //将文本框的内容清除
                _UsernameTF.text = @"";
                _PasswordAgainTF.text = @"";
                _PasswordTF.text = @"";
                _TelTF.text = @"";
                _registertf.text = @"";
                [Utilities popUpAlertViewWithMsg:@"注册成功" andTitle:nil onView:self];
                //先将SignUpSuccessfully这个单例化全局变量中的folg删除以保证
                [[StorageMgr singletonStorageMgr] removeObjectForKey:@"SignUpSuccessfully"];
                //初始化一个bool格式的单例化全局标量来表示是否成功执行了注册  默认为否
                [[StorageMgr singletonStorageMgr] addKey:@"Username" andValue:username];
                //在单例化全局变量中保存用户名和密码以供登录页面自动登录使用
                [[StorageMgr singletonStorageMgr] addKey:@"Password" andValue:password];
                //回到登录页面
                [self.navigationController popViewControllerAnimated:YES];
                break;
            case 6001:
                [Utilities popUpAlertViewWithMsg:@"注册失败" andTitle:nil onView:self];
                break;default:break;
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error.userInfo);
        NSLog(@"注册失败");
        
    }];
    

}
//当按了验证码
- (IBAction)TestGetCodeAction:(UIButton *)sender forEvent:(UIEvent *)event {
    NSString *TelTF =_TelTF.text;
    if (TelTF.length != 11 ) {
        [Utilities popUpAlertViewWithMsg:@"请输入11位手机号" andTitle:nil onView:self];
        return;
    }
    //菊花
    UIActivityIndicatorView *avi = [Utilities getCoverOnView:self.view];
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_TelTF.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        [avi stopAnimating];
        NSLog(@"发送成功");
    }];

}
//隐藏键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}
@end
