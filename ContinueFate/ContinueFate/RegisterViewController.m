//
//  RegisterViewController.m
//  ContinueFate
//
//  Created by demon on 16/4/16.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "RegisterViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "MBProgressHUD+NJ.h"
@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
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
    
    if (password.length < 6 || PasswordAgainTF.length < 6) {
        [Utilities popUpAlertViewWithMsg:@"请输入不少于6位密码" andTitle:nil onView:self];
        return ;
    }
    if (![password isEqualToString:PasswordAgainTF]) {
        [Utilities popUpAlertViewWithMsg:@"您两次输入的密码不同，请重新输入" andTitle:nil onView:self];
        return;
    }
    NSLog(@"%@",username);
    NSLog(@"%@",password);
    NSLog(@"%@",TelTF);
    
    [SMSSDK commitVerificationCode:_registertf.text phoneNumber:_TelTF.text zone:@"86" result:^(NSError *error) {
        switch (error.code) {
            case 456:
                [Utilities popUpAlertViewWithMsg:@"您输入的手机号为空号" andTitle:nil onView:self];
                break;
            case 457:
                [Utilities popUpAlertViewWithMsg:@"您输入的手机号格式不正确" andTitle:nil onView:self];
                break;
            case 467:
                [Utilities popUpAlertViewWithMsg:@"请求校验验证码频繁" andTitle:nil onView:self];
                break;
            default:
                break;
        }

    }];
    //菊花
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    self.navigationController.view.self.userInteractionEnabled = NO;
    
    NSString *modulus = [[StorageMgr singletonStorageMgr] objectForKey:@"modulus"];
    NSString *exponent = [[StorageMgr singletonStorageMgr] objectForKey:@"exponent"];
    password = [NSString encryptWithPublicKeyFromModulusAndExponent:[password getMD5_32BitString].UTF8String modulus:modulus exponent:exponent];
    NSDictionary *parameters = @{@"code":username,@"pwd":password,@"mobile":TelTF,@"deviceId":[Utilities uniqueVendor]};
    [RequestAPI postURL:@"/register" withParameters:parameters success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        self.navigationController.view.self.userInteractionEnabled = YES;
        switch ([responseObject[@"resultFlag"]integerValue]) {
            case 8001:
                //将文本框的内容清除
                _UsernameTF.text = @"";
                _PasswordAgainTF.text = @"";
                _PasswordTF.text = @"";
                _TelTF.text = @"";
                _registertf.text = @"";
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
                [MBProgressHUD showError:@"用户名或者手机号已经注册" toView:self.view];
                break;
            default:
                break;
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error.userInfo);
        NSLog(@"注册失败");
        
    }];
    

}
//当按了验证码
- (IBAction)TestGetCodeAction:(UIButton *)sender forEvent:(UIEvent *)event {
    NSString *TelTF =_TelTF.text;
    
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    self.navigationController.view.self.userInteractionEnabled = NO;
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:TelTF zone:@"86" customIdentifier:nil result:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        self.navigationController.view.self.userInteractionEnabled=YES;
        switch (error.code) {
            case 200:
                NSLog(@"验证成功");
                break;
            case 466:
                [Utilities popUpAlertViewWithMsg:@"请输入验证码" andTitle:nil onView:self];
                break;
            case 468:
                [Utilities popUpAlertViewWithMsg:@"输入的验证码错误" andTitle:nil onView:self];
                break;
            default:
                break;
        }
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
