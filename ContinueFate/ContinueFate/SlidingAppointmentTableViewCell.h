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
@property (weak, nonatomic) IBOutlet UIImageView *cardIM;//图片
@property (weak, nonatomic) IBOutlet UILabel *CardLab;//卡片类型
@property (weak, nonatomic) IBOutlet UILabel *MoneyLab;//金额
@property (weak, nonatomic) IBOutlet UILabel *IfSuccessLab;//预约状态
@property (weak, nonatomic) IBOutlet UILabel *DateLab;//剩余时间
- (IBAction)photoAction:(UIButton *)sender forEvent:(UIEvent *)event;//专家头像按钮
@property (weak, nonatomic) IBOutlet UIButton *photo;//专家头像
@property (weak, nonatomic) IBOutlet UIButton *paybut;
- (IBAction)paybutAction:(UIButton *)sender forEvent:(UIEvent *)event;




@end
