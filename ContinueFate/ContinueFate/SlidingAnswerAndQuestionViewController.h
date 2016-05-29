//
//  SlidingAnswerAndQuestionViewController.h
//  ContinueFate
//
//  Created by demon on 16/5/15.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlidingAnswerAndQuestionViewController : UIViewController
- (IBAction)backAction:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *Segment;//segment控件
- (IBAction)segmentAction:(UISegmentedControl *)sender forEvent:(UIEvent *)event;//segment控件事件

@end
