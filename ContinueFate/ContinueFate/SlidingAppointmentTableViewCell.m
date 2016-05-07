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
   _ifsuccess.adjustsImageWhenHighlighted = YES;  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




//订单状态按钮
- (IBAction)OrderAction:(UIButton *)sender forEvent:(UIEvent *)event {
   
}
@end
