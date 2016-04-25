//
//  CFillInformationViewController.h
//  ContinueFate
//
//  Created by admin2015 on 16/4/23.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFillInformationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *CellTF;//称呼
@property (weak, nonatomic) IBOutlet UILabel *LimitWN;//限制字数
@property (weak, nonatomic) IBOutlet UIButton *GenderBut;//性别

//年龄
@property (weak, nonatomic) IBOutlet UITextField *AgeTF;
//电话号码
@property (weak, nonatomic) IBOutlet UITextField *PhoneNum;
//问题描述
@property (weak, nonatomic) IBOutlet UITextView *DescribeTV;
//类似textFile的提示
@property (weak, nonatomic) IBOutlet UILabel *PlaceholderLab;
//完成
- (IBAction)CompleteAction:(UIButton *)sender forEvent:(UIEvent *)event;
//点击跳转协议界面
- (IBAction)AgreementFileAction:(UIButton *)sender forEvent:(UIEvent *)event;
//点击同意协议（打勾/去勾）
- (IBAction)AgreenmentAction:(UIButton *)sender forEvent:(UIEvent *)event;
//选择性别（点击弹出PickerView）
- (IBAction)GreederChooseAction:(UIButton *)sender forEvent:(UIEvent *)event;
//接收传值 （传值入口）
@property (strong ,nonatomic)NSDictionary *expertsM;
@property (strong ,nonatomic)NSDictionary * objectForShow;
@end
