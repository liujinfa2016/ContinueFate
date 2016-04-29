//
//  CExpertsTableViewCell.m
//  ContinueFate
//
//  Created by admin2015 on 16/4/19.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "CExpertsTableViewCell.h"

@implementation CExpertsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    _styleView .layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    _styleView.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    _styleView.layer.shadowOpacity = 0.8;//阴影透明度，默认0
    _styleView.layer.shadowRadius = 4;//阴影半径，默认3
    _styleView.layer.cornerRadius=8.0;
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
