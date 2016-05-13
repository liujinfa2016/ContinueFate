//
//  CAConsultingViewController.m
//  ContinueFate
//
//  Created by admin2015 on 16/4/22.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "CAConsultingViewController.h"
#import "CCDTableViewCell.h"
#import "CFillInformationViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface CAConsultingViewController ()  <UITableViewDelegate,UITableViewDataSource> {
    NSInteger page;
    NSInteger perPage;
}
@property (strong ,nonatomic)NSMutableArray *objectForShow;
@property (strong , nonatomic)NSString *orderId;
@end

@implementation CAConsultingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
     self.navigationItem.title = @"预约咨询";
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    
    //删除分隔线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _objectForShow = [NSMutableArray new];
    // Do any additional setup after loading the view.
   
    _name.text = _expertsM[@"name"];
    _identity.text = _expertsM[@"expertlvName"];
    
    NSURL *URL = [NSURL URLWithString:_expertsM[@"headimage"]];
    [_image sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"文字信息咨询月卡"]];
    [self requestData];
    [self getOrderStateList];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航条"] forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) requestData {
    //入参
    NSDictionary *parameters = @{@"expertlvid":_expertsM[@"expertlvId"]};
    // 获取请求地址
    NSString *url = @"http://192.168.61.249:8080/XuYuanProject/orderTypeList";
    
   UIActivityIndicatorView *avi = [Utilities getCoverOnView:self.view];
    //POST请求数据
    [[AppAPIClient sharedClient] POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功执行以下方法
        [avi stopAnimating];
        //判断请求是否成功
        if ([responseObject[@"resultFlag"]integerValue] == 8001) {
            NSDictionary *result = responseObject[@"result"];
            NSArray *models = result[@"models"];
            if (page == 1){
                _objectForShow = nil;
                _objectForShow = [NSMutableArray new];
                perPage = 4;
            }
            //遍历models的内容
            for (NSDictionary *dic in models) {
                [_objectForShow addObject:dic];
            }
              NSLog(@"_getOrderState ======= %@",_objectForShow);
            //重载表格
            [self.tableView reloadData];
            
            
        }
        //请求失败执行以下方法
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
    }];
}

- (void)getOrderStateList {

    [RequestAPI postURL:@"/getOrderStateList" withParameters:nil success:^(id responseObject) {
        if ([responseObject[@"resultFlag"]integerValue] == 8001) {
            NSLog(@"responseObject == %@",responseObject);
            
            NSDictionary *result = responseObject[@"result"];
            NSArray *models = result[@"models"];
            
            //遍历models的内容
            for (NSDictionary *dic in models) {
                if ([dic[@"name"]isEqualToString:@"待回复"]){
                    _orderId = dic[@"id"];
                }
            }
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error.description);
       
        [MBProgressHUD showError:@"网络不给力，请稍后再试！" toView:self.view];
        [MBProgressHUD hideHUDForView:self.view];
        self.navigationController.view.self.userInteractionEnabled = YES;
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"_objectForShow == %lu",(unsigned long)_objectForShow.count);
    return _objectForShow.count;
}
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CCDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    NSDictionary *dict = _objectForShow[indexPath.row];
    NSURL *photoUrl = [NSURL URLWithString:dict[@"cardimage"]];
    //结合SDWebImage通过图片路径来实现异步加载和缓存（本案中加载到一个图片视图中）
    [cell.image sd_setImageWithURL:photoUrl placeholderImage:[UIImage imageNamed:@"文字信息咨询月卡"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CFillInformationViewController *date = [Utilities getStoryboardInstanceByIdentity:@"Consulting" byIdentity:@"Information"];
    //传值入口
   NSDictionary *dictB = _objectForShow[indexPath.row];
    date.expertsM = _expertsM;
    date.objectForShow = dictB;
    date.getOrderState = _orderId;
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

@end
