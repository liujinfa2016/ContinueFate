//
//  SlidingDataTableViewCell.h
//  ContinueFate
//
//  Created by demon on 16/4/22.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlidingDataTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
- (IBAction)sexTF:(UISwitch *)sender forEvent:(UIEvent *)event;
- (IBAction)datePc:(UIDatePicker *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIPickerView *PCView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
