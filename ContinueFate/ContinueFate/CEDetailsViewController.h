//
//  CEDetailsViewController.h
//  ContinueFate
//
//  Created by admin2015 on 16/4/19.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CEDetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *EImage;//专家照片
@property (weak, nonatomic) IBOutlet UILabel *ConsultantLab;//咨询过的人数

@property (weak, nonatomic) IBOutlet UITextView *DetailsTV;//专家咨询服务
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)ConsultingAction:(UIButton *)sender forEvent:(UIEvent *)event;//点击预约
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tvHeight;//获取textView的高度
@property (strong ,nonatomic)NSDictionary *dict;//传值容器
@end
