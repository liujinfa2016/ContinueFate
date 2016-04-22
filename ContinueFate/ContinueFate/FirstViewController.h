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
- (IBAction)consulAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)successAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)answerAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UILabel *articleTitlelab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@property (weak, nonatomic) IBOutlet UILabel *readQuantitylab;
@property (weak, nonatomic) IBOutlet UILabel *datelbe;

@end
