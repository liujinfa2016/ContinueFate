//
//  SlidingSetUpViewController.m
//  ContinueFate
//
//  Created by 刘金发 on 16/4/19.
//  Copyright © 2016年 XuYuan. All rights reserved.
//  设置

#import "SlidingSetUpViewController.h"

@interface SlidingSetUpViewController ()

@end

@implementation SlidingSetUpViewController

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
//按个人资料按钮
- (IBAction)Personal:(UIButton *)sender forEvent:(UIEvent *)event {
}
//按帮助按钮
- (IBAction)HlepAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
//当按了退出
- (IBAction)Exit:(UIButton *)sender forEvent:(UIEvent *)event {
//    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
//        if (!error) {
//            [self dismissViewControllerAnimated:YES completion:nil];
//        }else {
//            
//            [Utilities popUpAlertViewWithMsg:@"请保持网络畅通" andTitle:nil onView:self];
//            
//        }
//    }];

}
@end
