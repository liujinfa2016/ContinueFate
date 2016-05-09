//
//  DetailTableViewCell.h
//  ContinueFate
//
//  Created by hua on 16/4/23.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *expertName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *expertImage;
@property (weak, nonatomic) IBOutlet UILabel *substance;
@property (weak, nonatomic) IBOutlet UIButton *actBtn;
@property (weak, nonatomic) IBOutlet UIButton *answer;

@end
