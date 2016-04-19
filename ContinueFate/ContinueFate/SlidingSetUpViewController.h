//
//  SlidingSetUpViewController.h
//  ContinueFate
//
//  Created by 刘金发 on 16/4/19.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlidingSetUpViewController : UIViewController
//个人资料按钮
- (IBAction)Personal:(UIButton *)sender forEvent:(UIEvent *)event;
//帮助按钮
- (IBAction)HlepAction:(UIButton *)sender forEvent:(UIEvent *)event;
//退出按钮
- (IBAction)Exit:(UIButton *)sender forEvent:(UIEvent *)event;

@end
