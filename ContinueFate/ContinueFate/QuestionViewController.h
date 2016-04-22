//
//  QuestionViewController.h
//  ContinueFate
//
//  Created by px on 16/4/17.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionViewController : UIViewController
- (IBAction)chooseAction:(UIBarButtonItem *)sender;
- (IBAction)askAction:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
