//
//  onePasswordResetViewController.m
//  ContinueFate
//
//  Created by demon on 16/4/22.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "onePasswordResetViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "twoPasswordResetViewController.h"

@interface onePasswordResetViewController ()

@end

@implementation onePasswordResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航条"] forBarMetrics:UIBarMetricsDefault];
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
//获取验证码
- (IBAction)testGetCodeAction:(UIButton *)sender forEvent:(UIEvent *)event {
    NSString *Tell = _telTF.text;
    UIActivityIndicatorView *avi = [Utilities getCoverOnView:self.view];
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:Tell zone:@"86" customIdentifier:nil result:^(NSError *error) {
        //成功之后的回调
        [avi stopAnimating];
        NSLog(@"error = %@",error.description);
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
    } ];
    
}
//下一步
- (IBAction)nextAction:(UIButton *)sender forEvent:(UIEvent *)event {
     NSString *GetCode = _registerTF.text;
    NSString *tell = _telTF.text;
    
    [[StorageMgr singletonStorageMgr] addKey:@"Tell" andValue:tell];
    
    if (GetCode.length == 0 || tell.length == 0) {
        [Utilities popUpAlertViewWithMsg:@"请填写所有信息" andTitle:nil onView:self];
        return ;
    }
    UIActivityIndicatorView *avi = [Utilities getCoverOnView:self.view];
    self.navigationController.view.self.userInteractionEnabled = NO;
    UITableViewController *Reset=[Utilities getStoryboardInstanceByIdentity:@"Main" byIdentity:@"Reset"];
  
    [SMSSDK commitVerificationCode:GetCode phoneNumber:tell zone:@"86" result:^(NSError *error) {
        [avi stopAnimating];
        self.navigationController.view.self.userInteractionEnabled= YES;
        switch (error.code) {
            case 200:
                NSLog(@"验证成功");
                [self presentViewController:Reset animated:YES completion:nil];
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
