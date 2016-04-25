//
//  QuestionViewController.h
//  ContinueFate
//
//  Created by px on 16/4/17.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSDropDownMenu.h"
@interface QuestionViewController : UIViewController<FSDropDownMenuDataSource,FSDropDownMenuDelegate>

- (IBAction)askAction:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
