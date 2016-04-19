//
//  CEDetailsViewController.m
//  ContinueFate
//
//  Created by admin2015 on 16/4/19.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "CEDetailsViewController.h"

@interface CEDetailsViewController ()
@property (strong , nonatomic)UITapGestureRecognizer *tapTrick;
@end

@implementation CEDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _DetailsTV.userInteractionEnabled = NO;
    self.hidesBottomBarWhenPushed = true;
    _scrollView.scrollEnabled = YES;
   self.navigationItem.title = @"专家主页";
    //获得文字内容
    NSString *content = _DetailsTV.text;
    //获得文字的尺寸
    CGSize maxSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width - 20, 10000);//设定文字的宽度及高度
    //获得文字字体
    UIFont *conttentFont = _DetailsTV.font;
    
    ////根据上述文字三元素，获得文字应得尺寸（主要是获得文字应得高度）
    CGSize contentSize = [content boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:conttentFont}context:nil].size;
    CGFloat contentHeight = contentSize.height;
    //将文本视图的高度约束设置为文字内容高度加上文本视图默认的上下留白长度（8）
    _tvHeight.constant = contentHeight + 17;
    _tapTrick.enabled = NO;
    _tapTrick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bgTap:)];
    
    [self.view addGestureRecognizer:_tapTrick];

}
- (void )bgTap: (UITapGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateRecognized) {
        [self.view endEditing:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)ConsultingAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
}
@end
