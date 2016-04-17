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
<<<<<<< HEAD
=======
    //显示加载
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    //加载完成
    [MBProgressHUD hideHUDForView:self.view];
>>>>>>> 8ebe6f865e8ad100dc47d83bbc9f34dfb042804b
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(id)sender forEvent:(UIEvent *)event {
}
@end
