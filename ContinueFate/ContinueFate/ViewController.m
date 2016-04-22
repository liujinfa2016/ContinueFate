//
//  ViewController.m
//  ContinueFate
//
//  Created by 刘金发 on 16/4/16.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD+NJ.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //显示加载
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    //加载完成
    [MBProgressHUD hideHUDForView:self.view];



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(id)sender forEvent:(UIEvent *)event {
    NSString *username = _usernameTF.text;
    NSString *password = _passwordTF.text;
    if (username.length == 0 || password.length == 0) {
        [Utilities popUpAlertViewWithMsg:@"请填写所有信息" andTitle:nil onView:self];
        return;
        
    }
    NSLog(@"%@",username);
    NSLog(@"%@",password);
    NSDictionary *parameters = @{@"code":username,@"pwd":password,@"loginType":@1};
    [RequestAPI postURL:@"/login" withParameters:parameters success:^(id responseObject) {
        NSLog(@"responseObject :%@",responseObject);
        switch ([responseObject[@"resultFlag"]integerValue]) {
            case 8001:
                
                NSLog(@"登陆成功");
                
                break;
            case 6001:
                [Utilities popUpAlertViewWithMsg:@"登录失败" andTitle:nil onView:self];
                break;
            default:break;
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error.userInfo);
        NSLog(@"登录失败");
        
    }];

//    [self signInWithUsername:username addpassword:password];
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
