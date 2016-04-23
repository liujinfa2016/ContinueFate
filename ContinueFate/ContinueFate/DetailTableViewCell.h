//
//  DetailTableViewCell.h
//  ContinueFate
//
//  Created by hua on 16/4/23.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTableViewCell : UITableViewCell

- (IBAction)convention:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UILabel *expertName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *expertImage;
@property (weak, nonatomic) IBOutlet UILabel *substance;

@end
