//
//  QAskViewController.m
//  ContinueFate
//
//  Created by hua on 16/4/19.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "QAskViewController.h"

@interface QAskViewController ()

@end

@implementation QAskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
 }
- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)saveAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
