//
//  QuestionTableViewCell.h
//  ContinueFate
//
//  Created by hua on 16/4/17.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *tiltlename;
@property (weak, nonatomic) IBOutlet UILabel *substance;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *answerCount;

@end
