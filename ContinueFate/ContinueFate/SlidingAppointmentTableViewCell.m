//
//  SlidingAppointmentTableViewCell.m
//  ContinueFate
//
//  Created by demon on 16/4/23.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "SlidingAppointmentTableViewCell.h"
#import "slidingAppointmentViewController.h"
@implementation SlidingAppointmentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



//专家头像按钮
- (IBAction)photoAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
//去付款按钮
- (IBAction)paybutAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
