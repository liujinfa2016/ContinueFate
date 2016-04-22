//
//  RegisterViewController.m
//  ContinueFate
//
//  Created by demon on 16/4/16.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "RegisterViewController.h"

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


- (IBAction)Registered:(UIButton *)sender forEvent:(UIEvent *)event {
    NSString *username = _UsernameTF.text;
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
    
    NSDictionary *parameters = @{@"code":username,@"pwd":password,@"mobile":TelTF};
    [RequestAPI postURL:@"/register" withParameters:parameters success:^(id responseObject) {
        NSLog(@"responseObject :%@",responseObject);
        switch ([responseObject[@"resultFlag"]integerValue]) {
            case 8001:
                NSLog(@"注册成功");
                
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
- (IBAction)TestGetCodeAction:(UIButton *)sender forEvent:(UIEvent *)event {
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
