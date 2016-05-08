//
//  SlidingCollectionViewController.h
//  ContinueFate
//
//  Created by demon on 16/4/25.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlidingCollectionViewController : UIViewController
- (IBAction)Return:(UIBarButtonItem *)sender;//返回
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBut;
- (IBAction)rightButAction:(UIBarButtonItem *)sender;

@end
