//
//  SlidingViewController.h
//  ContinueFate
//
//  Created by 刘金发 on 16/4/17.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlidingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *imageLable;
//图片按钮
- (IBAction)PhotoAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
