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
    _viewStyle .layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    _viewStyle.layer.shadowOffset = CGSizeMake(1,1);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    _viewStyle.layer.shadowOpacity = 0.2;//阴影透明度，默认0
    _viewStyle.layer.shadowRadius = 1;//阴影半径，默认3
   
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
