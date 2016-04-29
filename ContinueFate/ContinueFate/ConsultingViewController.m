//
//  ConsultingViewController.m
//  ContinueFate
//
//  Created by px on 16/4/17.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "ConsultingViewController.h"
#import "CExpertsTableViewCell.h"
#import "CEDetailsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ArticleObject.h"


@interface ConsultingViewController ()<UITableViewDataSource,UITableViewDelegate> {
    NSInteger page;
    NSInteger perPage;
   
}
@property (strong ,nonatomic)NSMutableArray *objArr;
@property (strong ,nonatomic)NSArray *cityArr;
@property (strong ,nonatomic)NSArray *areaArr;
@property(nonatomic,strong) NSArray *currentAreaArr;
@property(nonatomic,strong) NSString *name;
@end

@implementation ConsultingViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    perPage = 4;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    self.navigationItem.title = @"专家榜";
    //删除多余的线
    _tableView.tableFooterView = [[UIView alloc]init];
     self.automaticallyAdjustsScrollViewInsets=NO;
    [self requestData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) requestData {
    //NSDictionary *parameters = @{@"name":@"",@"subtype":@"",@"page":@(page),@"perPage":@(perPage)};
    
    // 获取请求地址
    NSString *url = @"http://192.168.61.85:8080/XuYuanProject/expertsList";
    //  UIActivityIndicatorView *avi = [Utilities getCoverOnView:self.view];
    //POST请求数据
    [[AppAPIClient sharedClient] POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功执行以下方法
        //判断请求是否成功
        if ([responseObject[@"resultFlag"]integerValue] == 8001) {
            
            NSDictionary *result = responseObject[@"result"];
            NSArray *models = result[@"models"];
            if (page == 1){
                _objArr = nil;
                _objArr = [NSMutableArray new];
                perPage = 4;
            }
            //遍历models的内容
            for (NSDictionary *dic in models) {
                [_objArr addObject:dic];
            
            }
            //重载表格
            [self.tableView reloadData];
            
            
        }
        //请求失败执行以下方法
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
    }];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _objArr.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

   CExpertsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDictionary *dict = _objArr[indexPath.row];

    cell.Username.text = [NSString stringWithFormat:@"%@",dict[@"name"]];
    
    cell.Edetail.text = [NSString stringWithFormat:@"%@", dict[@"longevity"]];
    cell.ReadingN.text= [NSString stringWithFormat:@"%@", dict[@"orderCount"]];
    NSURL *photoUrl = [NSURL URLWithString:dict[@"headimage"]];
    //结合SDWebImage通过图片路径来实现异步加载和缓存（本案中加载到一个图片视图中）
    [cell.image sd_setImageWithURL:photoUrl placeholderImage:[UIImage imageNamed:@"专家1"]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //页面跳转+传值
    CEDetailsViewController *date = [Utilities getStoryboardInstanceByIdentity:@"Consulting" byIdentity:@"EDetails"];
    date.hidesBottomBarWhenPushed = YES;
    //传值入口
     NSDictionary *dict = _objArr[indexPath.row];
     date.dict = dict;
    //去除跳转后返回按钮的文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
     [self.navigationController pushViewController:date animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//搜索
- (IBAction)SearchAction:(UIBarButtonItem *)sender {


}
@end
