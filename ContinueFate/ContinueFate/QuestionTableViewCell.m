//
//  QuestionTableViewCell.m
//  ContinueFate
//
//  Created by hua on 16/4/17.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "QuestionTableViewCell.h"

@implementation QuestionTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    _viewStyle .layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    _viewStyle.layer.shadowOffset = CGSizeMake(1,1);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    _viewStyle.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    _viewStyle.layer.shadowRadius = 2;//阴影半径，默认3
    _viewStyle.layer.cornerRadius=5.0;
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
