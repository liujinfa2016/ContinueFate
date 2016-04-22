//
//  FirstTableViewCell.h
//  ContinueFate
//
//  Created by jdld on 16/4/18.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *articleTitlelab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@property (weak, nonatomic) IBOutlet UILabel *readQuantitylab;
@property (weak, nonatomic) IBOutlet UILabel *datelbe;

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@end
