//
//  QAskViewController.h
//  ContinueFate
//
//  Created by hua on 16/4/19.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QAskViewController : UIViewController<UITextViewDelegate,UIAlertViewDelegate>
- (IBAction)cancelAction:(UIBarButtonItem *)sender;
- (IBAction)saveAction:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITextView *titleView;
@property (weak, nonatomic) IBOutlet UITextView *substanceView;

@end
