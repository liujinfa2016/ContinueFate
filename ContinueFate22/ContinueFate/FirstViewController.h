//
//  FirstViewController.h
//  ContinueFate
//
//  Created by demon on 16/4/17.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)consulAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)successAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)answerAction:(UIButton *)sender forEvent:(UIEvent *)event;


@end
