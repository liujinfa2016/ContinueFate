//
//  CEDetailsViewController.m
//  ContinueFate
//
//  Created by admin2015 on 16/4/19.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "CEDetailsViewController.h"
#import "CAConsultingViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CEDetailsViewController () {
    NSInteger page;
    NSInteger perPage;
}
@property (strong ,nonatomic)NSMutableArray *objArr;

@property (strong , nonatomic)UITapGestureRecognizer *tapTrick;
@end

@implementation CEDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    page = 1;
    perPage = 4;
    _DetailsTV.userInteractionEnabled = NO;
    self.hidesBottomBarWhenPushed = true;
    _scrollView.scrollEnabled = YES;
   self.navigationItem.title = _dict[@"name"];
    [self constant];
    NSLog(@"_dict = %@",_dict);
    //显示服务咨询
    _DetailsTV.text = [NSString stringWithFormat:@"%@",_dict[@"expertlv"]];
    //显示咨询过的人数
    _ConsultantLab.text = [NSString stringWithFormat:@"有%@个人咨询过",_dict[@"orderCount"]];
    //显示专家上传的照片若无则显示默认图
    NSURL *photoUrl = [NSURL URLWithString:_dict[@"headimage"]];
    //结合SDWebImage通过图片路径来实现异步加载和缓存（本案中加载到一个图片视图中）
    [_EImage sd_setImageWithURL:photoUrl placeholderImage:[UIImage imageNamed:@"初始头像"]];

   
}

- (void)constant {
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
    CAConsultingViewController *data = [Utilities getStoryboardInstanceByIdentity:@"Consulting" byIdentity:@"CCarda"];
    [self.navigationController pushViewController:data animated:YES];
}
@end
