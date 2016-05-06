//
//  AMASucCellTableViewCell.h
//  ContinueFate
//
//  Created by jdld on 16/4/29.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMASucCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UILabel *substance;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;//更新时间
@property (weak, nonatomic) IBOutlet UILabel *readnumLab;//阅读量
@end
