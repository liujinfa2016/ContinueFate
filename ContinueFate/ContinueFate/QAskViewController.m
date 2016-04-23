//
//  QAskViewController.m
//  ContinueFate
//
//  Created by hua on 16/4/19.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "QAskViewController.h"

@interface QAskViewController ()
@property (strong,nonatomic) UILabel *titleLbl;
@property (strong,nonatomic) UILabel *substance;

@end

@implementation QAskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _titleView.delegate = self;
    _substanceView.delegate = self;
    _titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(3, 3, 200, 20)];
    _titleLbl.enabled = NO;
    _titleLbl.text = @"请输入标题";
    _titleLbl.font = [UIFont systemFontOfSize:13];
    _titleLbl.textColor = [UIColor lightGrayColor];
    [_titleView addSubview:_titleLbl];
    
    
    _substance = [[UILabel alloc]initWithFrame:CGRectMake(3, 3, 300, 20)];
    _substance.enabled = NO;
    _substance.text = @"请详细写出您的问题和感受(不少于60个字)";
    
    _substance.font = [UIFont systemFontOfSize:13];
    _substance.textColor = [UIColor lightGrayColor];
    [_substanceView addSubview:_substance];
    
 }

- (void)textViewDidChange:(UITextView *)textView{
    
    if ([_substanceView.text length] == 0) {
        _substance.hidden = NO;
    }else{
        _substance.hidden = YES;
    }
    
    if ([_titleView.text length] == 0) {
        _titleLbl.hidden = NO;
    }else{
        _titleLbl.hidden = YES;
    }
    
}

- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
