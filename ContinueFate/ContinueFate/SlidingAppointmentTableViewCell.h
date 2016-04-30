//
//  SlidingAppointmentTableViewCell.h
//  ContinueFate
//
//  Created by demon on 16/4/23.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlidingAppointmentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *ExpertsnameLab;//专家名称
@property (weak, nonatomic) IBOutlet UIImageView *cardIM;//
@property (weak, nonatomic) IBOutlet UILabel *CardLab;
@property (weak, nonatomic) IBOutlet UILabel *MoneyLab;
- (IBAction)OrderAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UILabel *IfSuccessLab;
@property (weak, nonatomic) IBOutlet UILabel *DateLab;

@end
