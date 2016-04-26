//
//  CAConsultingViewController.h
//  ContinueFate
//
//  Created by admin2015 on 16/4/22.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAConsultingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *image;//专家头像
@property (weak, nonatomic) IBOutlet UILabel *name;//专家姓名
@property (weak, nonatomic) IBOutlet UILabel *identity;//专家等级
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong ,nonatomic)NSDictionary *expertsM;//传值（容器）



@end
