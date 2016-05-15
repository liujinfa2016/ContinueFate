//
//  AMSuccessAViewController.m
//  ContinueFate
//
//  Created by admin2015 on 16/4/19.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "AMSuccessAViewController.h"
#import "ArticleObject.h"
#import "AMASucCellTableViewCell.h"
#import "ArticleDetailViewController.h"
#import "JRSegmentControl.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface AMSuccessAViewController ()<UITableViewDataSource,UITableViewDelegate> {
    NSInteger page;
    NSInteger perPage;
    NSInteger totalPage;
}
@property (strong ,nonatomic)NSMutableArray *objArr;

@end

@implementation AMSuccessAViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView.dataSource = self;
    _tableView.delegate = self;
    page = 1;
    perPage = 4;
    _objArr = [NSMutableArray new];
    [self refreshDownAndUp];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航条"] forBarMetrics:UIBarMetricsDefault];
    
    if ([Utilities getKeyedArchiver:@"successArticle"] == nil){
        [self requestData];
    }else{
        NSArray *dataArr = [Utilities getKeyedArchiver:@"ArticleShow"];
        for (NSDictionary *dict in dataArr) {
            ArticleObject *artObj = [[ArticleObject alloc]initWithDictionary:dict];
            [_objArr addObject:artObj];
        }
        [self.tableView reloadData];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
//数据请求
- (void)requestData {
    
    NSString *url = @"http://192.168.61.154:8080/XY_Project/servlet/showArticle";
    
    NSDictionary *parameters = @{@"type":@"成功案例",@"subtype":@"成功案例",@"page":@(page),@"perPage":@(perPage)};
    [[AppAPIClient sharedClient] GET: url parameters:parameters progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        //[avi stopAnimating];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if ([responseObject[@"resultFlag"]integerValue] == 8001) {
            NSDictionary *result = responseObject[@"result"];
            NSArray *dataArr = result[@"models"];
            NSDictionary *pageDict = result[@"paginginfo"];
            
            if (page == 1){
                _objArr = nil;
                _objArr = [NSMutableArray new];
                
                perPage = 4;
            }
            [Utilities setKeyedArchiver:@"successArticle" content:dataArr];
            for  (NSDictionary *art in dataArr) {
                ArticleObject *artObj = [[ArticleObject alloc]initWithDictionary:art];
                
                [_objArr addObject:artObj];
                
                NSLog(@"_objectForShow = %@",_objArr);
            }
            totalPage = [pageDict[@"totalPage"]integerValue];
            
            [_tableView reloadData];
        }else {
            [Utilities popUpAlertViewWithMsg:@"亲 ，请保持网络畅通" andTitle:nil onView:self];
        }
        
        
    } failure: ^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"%@",error.description);
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _objArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AMASucCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    ArticleObject *artObj = _objArr[indexPath.row];
    NSLog(@"qqqqqqqq = %@",artObj.titlename);
    NSString * titlename = artObj.titlename;
    NSString * substance = artObj.substance;
    cell.titleName.text = titlename;
    cell.substance.text = substance;
    cell.dateLab.attributedText = [Utilities getIntervalAttrStr:[artObj.edittime substringToIndex:19]];
    cell.readnumLab.text = [NSString stringWithFormat:@"阅读%d次",artObj.hits];
    cell.readnumLab.textColor = [UIColor grayColor];
    
    NSDictionary *dic = [[Utilities getImageURL:artObj.substance]copy];
    NSString *imagrURL = dic[@"imageURL"];
    NSURL *photoURL = [NSURL URLWithString:imagrURL];
    [cell.image sd_setImageWithURL:photoURL placeholderImage:[UIImage imageNamed:@"横线"]];
    cell.image.contentMode = UIViewContentModeScaleAspectFill | UIViewContentModeScaleAspectFit;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Article" bundle:nil];
    ArticleDetailViewController *actView = [storyboard instantiateViewControllerWithIdentifier:@"detailArticle"];
    ArticleObject *obj = _objArr[indexPath.row];
    actView.articleId = obj.id;
    actView.titleName = obj.titlename;
    actView.subStance = obj.substance;
    actView.time = obj.edittime;
    actView.hits = [NSString stringWithFormat:@"阅读%d次",obj.hits];
    actView.writer = [NSString stringWithFormat:@"作者:%@",obj.username];
    [self.navigationController pushViewController:actView animated:YES];
}

//下拉刷新及上拉刷新
- (void) refreshDownAndUp {
    
//    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        page = 1;
//        [self requestData];
//    }];
    //动画下拉功能
    UIImage *image1 = [UIImage imageNamed:@"图1"];
    UIImage *image2 = [UIImage imageNamed:@"图2"];
    UIImage *image3 = [UIImage imageNamed:@"图3"];
    /*  UIImage *image4 = [UIImage imageNamed:@"04"];
     UIImage *image5 = [UIImage imageNamed:@"05"];
     UIImage *image6 = [UIImage imageNamed:@"06"];
     UIImage *image7 = [UIImage imageNamed:@"07"];*/
    
    NSArray *image = @[image1,image2,image3];
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshRequest)];
    // 设置普通状态的动画图片
    [header setImages:image forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:image forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [header setImages:image forState:MJRefreshStateRefreshing];
    // 设置header
    self.tableView.mj_header = header;
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if (page < totalPage) {
            page ++;
            
            [self requestData];
        } else {
            [_tableView.mj_footer setState:MJRefreshStateNoMoreData];
        }
    }];
    
}

- (void)refreshRequest{
    page = 1;
    [self requestData];
}

@end
