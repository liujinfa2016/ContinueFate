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
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    page = 1;
    perPage = 4;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    self.navigationItem.title = @"专家榜";
    //删除多余的线
    _tableView.tableFooterView = [[UIView alloc]init];
    //删除分隔线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
     self.automaticallyAdjustsScrollViewInsets=NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航条"] forBarMetrics:UIBarMetricsDefault];
    [self requestData];
    
//    if ([Utilities getKeyedArchiver:@"consultion"] == nil){
//        [self requestData];
//    }else{
//        NSArray *dataArr = [Utilities getKeyedArchiver:@"consultion"];
//        for (NSDictionary *dic in dataArr) {
//            [_objArr addObject:dic];
//        }
//        [self.tableView reloadData];
//    }

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
    NSDictionary *parameters = @{@"expertName":@"",@"page":@(page),@"perPage":@(perPage)};
    //菊花
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    //导航条不可用
    self.navigationController.view.self.userInteractionEnabled = NO;
    //POST请求数据

    [RequestAPI postURL:@"/expertsList" withParameters:parameters success:^(id responseObject) {
        //请求成功执行以下方法
        //判断请求是否成功
        //停止
        [MBProgressHUD hideHUDForView:self.view];
        //恢复导航条可用
        self.navigationController.view.self.userInteractionEnabled = YES;
        if ([responseObject[@"resultFlag"]integerValue] == 8001) {
            
            NSDictionary *result = responseObject[@"result"];
            NSArray *models = result[@"models"];
            if (page == 1){
                _objArr = nil;
                _objArr = [NSMutableArray new];
                perPage = 4;
            }
            [Utilities setKeyedArchiver:@"consultion" content:models];
            //遍历models的内容
            for (NSDictionary *dic in models) {
                [_objArr addObject:dic];
                
            }
            //重载表格
            [self.tableView reloadData];
            
            
        }
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error.description);
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CExpertsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    float imageHight = cell.image.frame.size.height;
    float nameHight = cell.Username.frame.size.height;
    float perHight = cell.Personality.frame.size.height;
    float readHight = cell.ReadingN.frame.size.height;
    return imageHight+nameHight+perHight+readHight+100;
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
        
        cell.Edetail.text = [NSString stringWithFormat:@"专家资历：%@", dict[@"longevity"]];
        cell.ReadingN.text= [NSString stringWithFormat:@"咨询人数：%@", dict[@"orderCount"]];
    cell.Personality.text=[NSString stringWithFormat:@"个性签名%@",dict [@"descripition"]];
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
        //设置搜索框的提示语\风格
        _searchController.searchBar.placeholder = @"搜索专家名";
        _searchController.searchBar.searchBarStyle=UISearchBarStyleMinimal;
        _searchController.searchBar.barStyle=UIBarStyleBlackOpaque;
        //签协议
        _searchController.delegate = self;
        _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController. hidesNavigationBarDuringPresentation = NO;
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
