//
//  SlidingDataTableViewCell.m
//  ContinueFate
//
//  Created by demon on 16/4/22.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "SlidingDataTableViewCell.h"
#import "SlidingDataViewController.h"

@implementation SlidingDataTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)sexTF:(UISwitch *)sender forEvent:(UIEvent *)event {
}

- (IBAction)datePc:(UIDatePicker *)sender forEvent:(UIEvent *)event {
}
@end
