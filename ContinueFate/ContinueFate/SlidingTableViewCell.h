//
//  SlidingTableViewCell.h
//  ContinueFate
//
//  Created by 刘金发 on 16/4/18.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlidingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *Lable;
@property(strong,nonatomic)NSMutableArray *menuList;

@end
