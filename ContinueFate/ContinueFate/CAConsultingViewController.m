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
@end

@implementation CAConsultingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    _objectForShow = [NSMutableArray new];
    // Do any additional setup after loading the view.
    
    _name.text = _expertsM[@"name"];
    _identity.text = _expertsM[@"expertlvName"];
    
    NSURL *URL = [NSURL URLWithString:_expertsM[@"headimage"]];
    [_image sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"初始头像"]];
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) requestData {
    NSDictionary *parameters = @{@"expertlvid":_expertsM[@"expertlvId"]};
    
    // 获取请求地址
    NSString *url = @"http://192.168.61.85:8080/XuYuanProject/orderTypeList";
    
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
            //重载表格
            [self.tableView reloadData];
            
            
        }
        //请求失败执行以下方法
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
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
    NSDictionary *dict = _objectForShow[indexPath.row];
    NSURL *photoUrl = [NSURL URLWithString:dict[@"image"]];
    //结合SDWebImage通过图片路径来实现异步加载和缓存（本案中加载到一个图片视图中）
    [cell.image sd_setImageWithURL:photoUrl placeholderImage:[UIImage imageNamed:@"初始头像"]];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CFillInformationViewController *date = [Utilities getStoryboardInstanceByIdentity:@"Consulting" byIdentity:@"Information"];
    
   NSDictionary *dictB = _objectForShow[indexPath.row];
    date.expertsM = _expertsM;
    date.objectForShow = dictB;
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
