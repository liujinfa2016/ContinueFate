//
//  CAConsultingViewController.h
//  ContinueFate
//
//  Created by admin2015 on 16/4/22.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAConsultingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *identity;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong ,nonatomic)NSDictionary *expertsM;



@end
