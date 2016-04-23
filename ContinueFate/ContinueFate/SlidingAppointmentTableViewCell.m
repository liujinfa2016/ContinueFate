//
//  SlidingAppointmentTableViewCell.m
//  ContinueFate
//
//  Created by demon on 16/4/23.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "SlidingAppointmentTableViewCell.h"

@implementation SlidingAppointmentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        return cell;
    
}


- (IBAction)OrderAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
