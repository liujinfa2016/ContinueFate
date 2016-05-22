//
//  SlidingSetUpViewController.m
//  ContinueFate
//
//  Created by 刘金发 on 16/4/19.
//  Copyright © 2016年 XuYuan. All rights reserved.
//  设置

#import "SlidingSetUpViewController.h"

@interface SlidingSetUpViewController ()
@property(strong,nonatomic) NSString *lable;
@end

@implementation SlidingSetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航条"] forBarMetrics:UIBarMetricsDefault];
     self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
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
//按个人资料按钮
- (IBAction)Personal:(UIButton *)sender forEvent:(UIEvent *)event {
//  [self.navigationController pushViewController:[Utilities getStoryboardInstanceByIdentity:@"Sliding" byIdentity:@"Data"] animated:YES];
//    NSString *userid = [[StorageMgr singletonStorageMgr] objectForKey:@"UserID"];
//    //提示框
//    if (userid == nil && userid.length == 0) {
//        
//        UIViewController *tabVc =[Utilities  getStoryboardInstanceByIdentity:@"Main" byIdentity:@"Login"];
//        
//        [self presentViewController:tabVc animated:YES completion:nil];
//        
//    }else{
//
//   [self presentViewController:[Utilities getStoryboardInstanceByIdentity:@"Sliding" byIdentity:@"Data"] animated:YES completion:nil];
//    
//    }
    if ([Utilities loginState]) {
        [Utilities popUpAlertViewWithMsg:@"您当前还未登录，请问您是否要登录！" andTitle:nil onView:self tureAction:^(UIAlertAction *action) {
            UIViewController *loginVc =[Utilities  getStoryboardInstanceByIdentity:@"Main" byIdentity:@"Login"];
            [self presentViewController:loginVc animated:YES completion:nil];
        }];
    } else {
        [self presentViewController:[Utilities getStoryboardInstanceByIdentity:@"Sliding" byIdentity:@"Data"] animated:YES completion:nil];
    }
}
//按帮助按钮
- (IBAction)HlepAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
//当按了退出
- (IBAction)Exit:(UIButton *)sender forEvent:(UIEvent *)event {
    NSString * userid =[[StorageMgr singletonStorageMgr] objectForKey:@"UserID"];
    if (userid == NULL) {
        [Utilities popUpAlertViewWithMsg:@"您还没有登录，请您先登录" andTitle:nil onView:self];
        return;
    }
    UIActivityIndicatorView *avi = [Utilities getCoverOnView:self.view];
    self.navigationController.view.self.userInteractionEnabled =NO;
    NSDictionary *dic =@{@"userid":userid,@"logoutType":@1};
    [RequestAPI postURL:@"/logout"withParameters:dic success:^(id responseObject) {
        [avi stopAnimating];
        self.navigationController.view.self.userInteractionEnabled = YES;
        NSLog(@"responseObject = %@",responseObject);
        [[StorageMgr singletonStorageMgr] removeObjectForKey:@"Nickname"];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSError *error) {
        [avi stopAnimating];
        self.navigationController.view.self.userInteractionEnabled = YES;
        [Utilities popUpAlertViewWithMsg:@"请保持网络畅通" andTitle:nil onView:self];
    }];
    [[StorageMgr singletonStorageMgr] removeObjectForKey:@"UserID"];
    [[StorageMgr singletonStorageMgr] removeObjectForKey:@"UserType"];
}

- (IBAction)Return:(UIBarButtonItem *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
@end
