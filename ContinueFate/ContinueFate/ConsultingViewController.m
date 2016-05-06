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


@interface ConsultingViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchControllerDelegate,UISearchResultsUpdating> {
    NSInteger page;
    NSInteger perPage;
    BOOL flag;
}
@property (strong ,nonatomic)NSMutableArray *objArr;
@property (strong ,nonatomic)NSMutableArray *searchArr;
@property (strong ,nonatomic)NSArray *cityArr;
@property (strong ,nonatomic)NSArray *areaArr;
@property(nonatomic,strong) NSArray *currentAreaArr;
@property(nonatomic,strong) NSString *name;
@property (strong ,nonatomic) UISearchController  *searchController;//声明一个搜索框

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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航条"] forBarMetrics:UIBarMetricsDefault];

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.searchController.active) {
        self.searchController.active = NO;
        [self.searchController.searchBar removeFromSuperview];
    }
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
    if (!_searchController.active) {
        NSLog(@"1");
        return [_objArr count];
    }else{
        NSLog(@"2");
        return [_searchArr count];
    }
       // return _objArr.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

   CExpertsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *dict = [[NSDictionary alloc]init];
       dict = _objArr[indexPath.row];
    if (!_searchController.active) {
        dict = _objArr[indexPath.row];
    }else {
        dict = _searchArr[indexPath.row];
    }
        
        cell.Username.text = [NSString stringWithFormat:@"%@",dict[@"name"]];
        
        cell.Edetail.text = [NSString stringWithFormat:@"%@", dict[@"longevity"]];
        cell.ReadingN.text= [NSString stringWithFormat:@"%@", dict[@"orderCount"]];
        NSURL *photoUrl = [NSURL URLWithString:dict[@"headimage"]];
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

//搜索
- (IBAction)SearchAction:(UIBarButtonItem *)sender {

    if (flag == NO) {
        //设置搜索框的提示语
        _searchController.searchBar.placeholder = @"搜索专家名";
        //签协议
        _searchController.delegate = self;
        _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.hidesNavigationBarDuringPresentation = NO;
        _searchController.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
        _tableView.tableHeaderView = _searchController.searchBar;
        flag = YES;
       
    } else {
        _tableView.tableHeaderView = [[UIView alloc]init];
        flag = NO;
        
    }
   
    
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchControlle {
    
    [_searchArr removeAllObjects];
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", self.searchController.searchBar.text];
    _searchArr = [[_objArr filteredArrayUsingPredicate:searchPredicate] mutableCopy];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        
        
    });
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
