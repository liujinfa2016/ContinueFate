//
//  CFillInformationViewController.h
//  ContinueFate
//
//  Created by admin2015 on 16/4/23.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFillInformationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *CellTF;
@property (weak, nonatomic) IBOutlet UISwitch *Swtich;
@property (weak, nonatomic) IBOutlet UILabel *LimitWN;

@property (weak, nonatomic) IBOutlet UITextField *AgeTF;
@property (weak, nonatomic) IBOutlet UITextField *PhoneNum;
@property (weak, nonatomic) IBOutlet UITextView *DescribeTV;
@property (weak, nonatomic) IBOutlet UILabel *PlaceholderLab;
- (IBAction)CompleteAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (strong ,nonatomic)NSDictionary *expertsM;
@property (strong ,nonatomic)NSDictionary * objectForShow;
@end
