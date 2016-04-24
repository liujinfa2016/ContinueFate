//
//  QuestViewController.h
//  ContinueFate
//
//  Created by hua on 16/4/17.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionObject.h"
@interface QuestViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *titlename;
@property (weak, nonatomic) IBOutlet UILabel *substance;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *ansNumber;

@property (weak, nonatomic) IBOutlet UILabel *typeLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (strong,nonatomic)QuestionObject *detail;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)convention:(UIButton *)sender forEvent:(UIEvent *)event;

@end
