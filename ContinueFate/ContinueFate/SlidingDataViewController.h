//
//  SlidingDataViewController.h
//  ContinueFate
//
//  Created by demon on 16/4/22.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlidingDataViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *image;//图片
@property (weak, nonatomic) IBOutlet UITextField *nameFiet;//名字
@property (weak, nonatomic) IBOutlet UILabel *ageText;//年龄
@property (weak, nonatomic) IBOutlet UILabel *regiontext;//地区
@property (weak, nonatomic) IBOutlet UITextView *textView;//简介输入框
- (IBAction)imageAction:(UIButton *)sender forEvent:(UIEvent *)event;//图片按钮
- (IBAction)modifyAction:(UIButton *)sender forEvent:(UIEvent *)event;//确定修改
- (IBAction)modifyEiet:(UIBarButtonItem *)sender;//修改




@end
