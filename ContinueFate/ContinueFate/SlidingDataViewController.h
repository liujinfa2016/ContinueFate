//
//  SlidingDataViewController.h
//  ContinueFate
//
//  Created by demon on 16/4/22.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlidingDataViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *sexTF;//性别

@property (weak, nonatomic) IBOutlet UITextField *neckName;//昵称
@property (weak, nonatomic) IBOutlet UIButton *image;//头像图片
@property (weak, nonatomic) IBOutlet UITextField *nameTF;//姓名
@property (weak, nonatomic) IBOutlet UITextField * ageTF;//出生日期
@property (weak, nonatomic) IBOutlet UITextField *regionTF;//地区
@property (weak, nonatomic) IBOutlet UITextField *telTF;//手机号码
@property (weak, nonatomic) IBOutlet UITextView *textView;//简介输入框
- (IBAction)imageAction:(UIButton *)sender forEvent:(UIEvent *)event;//图片按钮
- (IBAction)modifyAction:(UIButton *)sender forEvent:(UIEvent *)event;//确定修改
- (IBAction)modifyEiet:(UIBarButtonItem *)sender;//修改
- (IBAction)ReturnAction:(UIBarButtonItem *)sender;//返回

@property (weak, nonatomic) IBOutlet UIScrollView *SCView;
@property (strong , nonatomic)UITapGestureRecognizer *tapTrick;



@end
