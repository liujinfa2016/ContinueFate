//
//  ArticleDetailViewController.m
//  ContinueFate
//
//  Created by jdld on 16/4/23.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "ArticleDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDAutoLayout/UIView+SDAutoLayout.h>

@interface ArticleDetailViewController (){
    UILabel *_autoWidthLabel;
    NSString *userid;
    Boolean flag;
}

@property (strong, nonatomic) UIBarButtonItem *barBut;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ArticleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    userid = @"145987302766822";
    // Do any additional setup after loading the view.
    
    self.title = @"文章详情";
    
    
    /*****************处理文字***************************/
    NSDictionary *dic = [[Utilities getImageURL:_subStance]copy];
    NSString *imagrURL = dic[@"imageURL"];
    NSURL *photoURL = [NSURL URLWithString:imagrURL];
    NSString *sub = dic[@"last"];
    NSRange rangeFirst = [_subStance rangeOfString:@"&"];
    NSRange rangeLast = [sub rangeOfString:@"&&"];
    
    
    UILabel *text1 = [[UILabel alloc]init];
    text1.text = [[[NSString stringWithFormat:@"        %@",[_subStance substringToIndex:rangeFirst.location]]stringByReplacingOccurrencesOfString:@"\\r" withString:@"\r        "] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    text1.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    
    UIImageView *image = [[UIImageView alloc]init];
    [image sd_setImageWithURL:photoURL placeholderImage:[UIImage imageNamed:@"01"]];
    
    UILabel *text2 = [[UILabel alloc]init];
    text2.text = [[[[sub substringFromIndex:rangeLast.location]stringByReplacingOccurrencesOfString:@"&&" withString:@"        "]stringByReplacingOccurrencesOfString:@"\\r" withString:@"\r        "] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    text2.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    /*************************************************/
    UILabel *title = [[UILabel alloc]init];
    title.text = _titleName;
    title.font = [UIFont fontWithName:@"Helvetica" size:20];
    
    UILabel *time = [[UILabel alloc]init];
    time.text = [NSString stringWithFormat:@"发表于%@",[_time substringToIndex:10]];
    UILabel *hits = [[UILabel alloc]init];
    hits.text = _hits;
    UILabel *writer = [[UILabel alloc]init];
    writer.text = _writer;
    time.font = [UIFont fontWithName:@"Arial" size:13];
    hits.font = [UIFont fontWithName:@"Arial" size:13];
    writer.font = [UIFont fontWithName:@"Arial" size:13];
    
    UIView *fristView = [UIView new];
    [_scrollView addSubview:fristView];
    [fristView sd_addSubviews:@[title,time,writer,hits,text1,image,text2]];
    
    [_scrollView setupAutoContentSizeWithBottomView:fristView bottomMargin:10];
    
    title.sd_layout
    .rightSpaceToView(fristView,0)
    .topSpaceToView(fristView,10)
    .autoHeightRatio(0);
    
    time.sd_layout
    .leftSpaceToView(fristView,0)
    .topSpaceToView(title,10).widthIs(250)
    .autoHeightRatio(0);
    
    hits.sd_layout
    .rightSpaceToView(fristView,10)
    .topSpaceToView(title,10).widthIs(80)
    .autoHeightRatio(0);
    
    writer.sd_layout
    .leftSpaceToView(fristView,0)
    .topSpaceToView(time,10).widthIs(80)
    .autoHeightRatio(0);
    
    text1.sd_layout
    .rightSpaceToView(fristView,10)
    .leftSpaceToView(fristView,10)
    .topSpaceToView(writer,10)
    .autoHeightRatio(0);
    
    image.sd_layout.topSpaceToView(text1,10).rightSpaceToView(fristView,20).leftSpaceToView(fristView,20).autoHeightRatio(0.75);
    
    text2.sd_layout
    .rightSpaceToView(fristView,10)
    .leftSpaceToView(fristView,10)
    .topSpaceToView(image,10)
    .autoHeightRatio(0);
    
    fristView.sd_layout
    .leftSpaceToView(_scrollView,10)
    .rightSpaceToView(_scrollView,10)
    .topSpaceToView(_scrollView,10);
    [fristView setupAutoHeightWithBottomView:text1 bottomMargin:10];
    [fristView setupAutoHeightWithBottomView:text2 bottomMargin:10];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self exists];
    
}

- (void)setupAutoWidthLabel
{
    UILabel *autoWidthlabel = [UILabel new];
    autoWidthlabel.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.5];
    _autoWidthLabel = autoWidthlabel;
    autoWidthlabel.font = [UIFont systemFontOfSize:12];
    autoWidthlabel.text = @"宽度自适应(距离父view右边距10)";
    
    [self.view addSubview:autoWidthlabel];
    
    autoWidthlabel.sd_layout
    .rightSpaceToView(self.view, 10)
    .heightIs(20)
    .bottomSpaceToView(self.view, 50);
    
    [autoWidthlabel setSingleLineAutoResizeWithMaxWidth:180];
}

//点击收藏按钮后触发的方法
- (void) judegFlag {
    if (flag) {
        [Utilities popUpAlertViewWithMsg:@"确认取消收藏?" andTitle:@"提示" onView:self tureAction:^(UIAlertAction * _Nonnull action) {
            [self delCollection];
        }];
        
    }else {
        [Utilities popUpAlertViewWithMsg:@"确认收藏?" andTitle:@"提示" onView:self tureAction:^(UIAlertAction * _Nonnull action) {
            [self addCollection];
        }];
    }
}

//网络请求 提取数据
- (void) addCollection {
    
    NSDictionary *parameters = @{@"articleid":_articleId,@"usertype":@1,@"userid":userid};
    
    NSString *url = @"http://192.168.61.154:8080/XY_Project/servlet/Collection";
    NSString *decodedURL = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [[AppAPIClient sharedClient] POST:decodedURL parameters:parameters progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"add = %ld",[responseObject[@"resultFlag"]integerValue]);
        if ([responseObject[@"resultFlag"]integerValue] == 8001) {
            [Utilities popUpAlertViewWithMsg:@"收藏成功" andTitle:nil onView:self];
            flag = YES;
            [self exists];
        }else{
            [Utilities popUpAlertViewWithMsg:@"请保持网络通畅" andTitle:nil onView:self];
            flag = NO;
        }
    } failure: ^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"error = %@",error.description);
    }];
    
}
//网络请求 删除数据
- (void) delCollection {
    
    NSDictionary *parameters = @{@"articleid":_articleId,@"userid":userid};
    
    NSString *url = @"http://192.168.61.154:8080/XY_Project/servlet/DelCollection";
    NSString *decodedURL = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [[AppAPIClient sharedClient] POST:decodedURL parameters:parameters progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"delete = %ld",[responseObject[@"resultFlag"]integerValue]);
        if ([responseObject[@"resultFlag"]integerValue] == 8001) {
            [Utilities popUpAlertViewWithMsg:@"取消成功" andTitle:nil onView:self];
            flag = NO;
            [self exists];
        }else{
            [Utilities popUpAlertViewWithMsg:@"请保持网络通畅" andTitle:nil onView:self];
            flag = YES;
        }
    } failure: ^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"error = %@",error.description);
    }];
    
}
//网络请求 判断是否已收藏当前文章
- (void) exists {
    NSDictionary *parameter = @{@"articleid":_articleId};
    NSString *url = @"http://192.168.61.154:8080/XY_Project/servlet/existsCollection";
    
    NSLog(@"asdssadsadsadsadsa = %@",url);
    [[AppAPIClient sharedClient]GET:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _barBut = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:self action:@selector(judegFlag)];
        if ([responseObject[@"resultFlag"]integerValue] == 8001) {
            [_barBut setImage:[UIImage imageNamed:@"我的收藏"]];
            flag = YES;
        }else {
            [_barBut setImage:[UIImage imageNamed:@"未收藏"]];
            flag = NO;
        }
        
        [self.navigationItem setRightBarButtonItem:_barBut animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"dddd = %@",error.description);
    }];
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

@end
