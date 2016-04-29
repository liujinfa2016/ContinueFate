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
    if ([[StorageMgr singletonStorageMgr]objectForKey:@"UserID"] == nil) {
        userid = @"";
        [self exists];
    }else {
        userid = [[StorageMgr singletonStorageMgr]objectForKey:@"UserID"];
        [self exists];
    }
    // Do any additional setup after loading the view.
    
    self.title = @"文章详情";
    NSDictionary *setColor = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes = setColor;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    
    /*****************处理文字***************************/
    NSDictionary *dic = [[Utilities getImageURL:_subStance]copy];
    NSString *imagrURL = dic[@"imageURL"];
    NSURL *photoURL = [NSURL URLWithString:imagrURL];
    NSString *sub = dic[@"last"];
    NSRange rangeFirst = [_subStance rangeOfString:@"&"];
    NSRange rangeLast = [sub rangeOfString:@"&&"];
    
    NSString *str1 = [[[NSString stringWithFormat:@"        %@",[_subStance substringToIndex:rangeFirst.location]]stringByReplacingOccurrencesOfString:@"\\r" withString:@"\r        "] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    UITextView *text1 = [[UITextView alloc]initWithFrame:CGRectMake(8, 110, UI_SCREEN_W-16, 20)];
    text1.text = str1;
    text1.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    text1.scrollEnabled = NO;    text1.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    text1.height = [Utilities getTextHeight:str1 textFont:text1.font.copy toViewRange:20];
    text1.editable = NO;
    text1.textColor = [UIColor darkGrayColor];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(20, 125+text1.height, UI_SCREEN_W-40, (UI_SCREEN_W-40)*0.75)];
    image.contentMode = UIViewContentModeScaleToFill;
    [image sd_setImageWithURL:photoURL placeholderImage:[UIImage imageNamed:@"01"]];
    
    NSString *str2 = [[[[sub substringFromIndex:rangeLast.location]stringByReplacingOccurrencesOfString:@"&&" withString:@"        "]stringByReplacingOccurrencesOfString:@"\\r" withString:@"\r        "] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    UITextView *text2 = [[UITextView alloc]initWithFrame:CGRectMake(8, 110+(UI_SCREEN_W-40)*0.75+text1.height, UI_SCREEN_W-16, 20)];
    text2.text = str2;
    text2.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    text2.scrollEnabled = NO;
    text2.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    text2.height = [Utilities getTextHeight:str2 textFont:text2.font.copy toViewRange:20];
    text2.editable = NO;
    text2.textColor = [UIColor darkGrayColor];

    /*************************************************/
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, UI_SCREEN_W, 30)];
    title.text = _titleName;
    title.font = [UIFont fontWithName:@"Helvetica" size:20];
    title.textColor = [UIColor darkGrayColor];
    
    UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, UI_SCREEN_W/2, 30)];
    time.text = [NSString stringWithFormat:@"发表于%@",[_time substringToIndex:10]];
    time.font = [UIFont fontWithName:@"Arial" size:13];
    time.textColor = [UIColor grayColor];
    
    UILabel *hits = [[UILabel alloc]initWithFrame:CGRectMake(UI_SCREEN_W/2, 40, UI_SCREEN_W/2-10, 30)];
    hits.textAlignment = NSTextAlignmentRight;
    hits.text = _hits;
    hits.font = [UIFont fontWithName:@"Arial" size:13];
    hits.textColor = [UIColor grayColor];
    
    UILabel *writer = [[UILabel alloc]initWithFrame:CGRectMake(10, 75, UI_SCREEN_W/2, 30)];
    writer.text = _writer;
    writer.font = [UIFont fontWithName:@"Arial" size:15];
    writer.textColor = [UIColor grayColor];
    
    
    [_scrollView setupAutoContentSizeWithBottomView:text2 bottomMargin:5];
    
    [_scrollView addSubview:title];
    [_scrollView addSubview:time];
    [_scrollView addSubview:hits];
    [_scrollView addSubview:writer];
    [_scrollView addSubview:text1];
    [_scrollView addSubview:image];
    [_scrollView addSubview:text2];
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
    NSDictionary *parameter = @{@"articleid":_articleId,@"userid":userid};
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
