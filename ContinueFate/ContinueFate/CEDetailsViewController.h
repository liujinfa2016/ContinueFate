//
//  CEDetailsViewController.h
//  ContinueFate
//
//  Created by admin2015 on 16/4/19.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CEDetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *EImage;
@property (weak, nonatomic) IBOutlet UILabel *ZiXunLab;
@property (weak, nonatomic) IBOutlet UILabel *ZanLab;
@property (weak, nonatomic) IBOutlet UITextView *DetailsTV;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)ConsultingAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tvHeight;

@end
