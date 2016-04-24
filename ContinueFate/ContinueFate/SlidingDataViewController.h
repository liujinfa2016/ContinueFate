//
//  SlidingDataViewController.h
//  ContinueFate
//
//  Created by demon on 16/4/22.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlidingDataViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)saveBut:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)changeItem:(UIBarButtonItem *)sender;

@end
