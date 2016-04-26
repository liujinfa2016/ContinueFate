//
//  twoPasswordResetViewController.m
//  ContinueFate
//
//  Created by demon on 16/4/22.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "twoPasswordResetViewController.h"
#import "onePasswordResetViewController.h"
@interface twoPasswordResetViewController ()

@end

@implementation twoPasswordResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *tellArr =[[StorageMgr singletonStorageMgr] objectForKey:@"Tell"];
    _TelLable.text =tellArr;
    [[StorageMgr singletonStorageMgr] removeObjectForKey:@"Tell"];
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

- (IBAction)confirmAction:(UIButton *)sender forEvent:(UIEvent *)event {
    NSString *pass = _nPasswordTF.text;
    NSString *passArr = _nPasswordAgainTF.text;
    if (pass.length >= 6 || passArr.length >= 6) {
        [Utilities popUpAlertViewWithMsg:@"请输入不少于6位密码" andTitle:nil onView:self];
        return ;
    }
    NSDictionary *dic = @{@"pwd":passArr,@"mobile":_Tell};
    [RequestAPI postURL:@"/editPwd" withParameters:dic success:^(id responseObject) {
        NSLog(@"responseObject = %@ 成功",responseObject);
//        UIViewController *view =[Utilities getStoryboardInstanceByIdentity:@"Mian" byIdentity:@"HomeTF"];
//        
//        [self presentViewController:view animated:YES completion:Nil];
    } failure:^(NSError *error) {
        [Utilities popUpAlertViewWithMsg:@"修改失败，请保持网络畅通" andTitle:nil onView:self];
    }];
}
- (IBAction)Return:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
