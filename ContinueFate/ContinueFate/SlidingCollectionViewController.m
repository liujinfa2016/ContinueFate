//
//  SlidingCollectionViewController.m
//  ContinueFate
//
//  Created by demon on 16/4/25.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "SlidingCollectionViewController.h"
#import "SlidingCollectionTableViewCell.h"
#import "ArticleObject.h"
#import "ArticleDetailViewController.h"
#import "CollectionObject.h"

@interface SlidingCollectionViewController ()<UITableViewDelegate>{
    NSInteger page;
    NSInteger perPage;
    NSInteger totalPage;
    NSString *userid;
    BOOL flag;
    NSInteger index;
}
@property (strong, nonatomic) NSMutableArray *objArr;

@end

@implementation SlidingCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _objArr = [NSMutableArray new];
    index = 0;
    page = 1;
    perPage = 4;
    _tableView.editing = NO;
    flag = false;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航条"] forBarMetrics:UIBarMetricsDefault];
     self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([Utilities loginState]) {
        userid = @"";
    }else {
        userid = [[StorageMgr singletonStorageMgr]objectForKey:@"UserID"];
        [MBProgressHUD showMessage:@"正在加载" toView:self.view];
        [self netWorkRequest];
        [_tableView reloadData];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 刷新
 */
- (void)refreshData {
    [self netWorkRequest];
    [_tableView reloadData];
}

//网络请求 提取数据
- (void) netWorkRequest {
    [_objArr removeAllObjects];
    NSDictionary *parameters = @{@"userid":userid,@"page":@(page),@"perPage":@(perPage)};
    
    NSString *url = @"http://192.168.61.154:8080/XY_Project/servlet/DelCollection";
    NSString *decodedURL = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[AppAPIClient sharedClient] POST:decodedURL parameters:parameters progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"resultFlag"]integerValue] == 8001) {
            NSDictionary *result = responseObject[@"result"];
            NSArray *dataArr = result[@"models"];
            NSDictionary *pageDict = result[@"paginginfo"];
            
            if (page == 1){
                _objArr = nil;
                _objArr = [NSMutableArray new];
                perPage = 4;
            }
            
            for (NSDictionary *dict in dataArr) {
                CollectionObject *collObj = [[CollectionObject alloc]initWithDictionary:dict];
                [_objArr addObject:collObj];
            }
            [self.tableView reloadData];
            
            totalPage = [pageDict[@"totalPage"]integerValue];
            
        } else {
            
            [Utilities popUpAlertViewWithMsg:@"暂无收藏,快去寻找喜欢的文章吧" andTitle:nil onView:self];
        }
    } failure: ^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"error = %@",error.description);
        [MBProgressHUD hideHUDForView:self.view];
    }];
    
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _objArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    SlidingCollectionTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CollectionObject *collObj = _objArr[indexPath.row];
    cell.articleLab.text = collObj.titlename;
    cell.writerLab.text = [NSString stringWithFormat:@"作者:%@",collObj.username];
    cell.readNumberLab.text = [NSString stringWithFormat:@"阅读%d次",collObj.hits];
    return cell;
}
/***************
 数据请求 删除数据
 **************/
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CollectionObject *coll = _objArr[indexPath.row];
        
        NSDictionary *parameters = @{@"articleid":coll.articleid,@"userid":userid};
        
        NSString *url = @"http://192.168.61.154:8080/XY_Project/servlet/DelCollection";
        NSString *decodedURL = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [[AppAPIClient sharedClient] GET:decodedURL parameters:parameters progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view];
            if ([responseObject[@"resultFlag"]integerValue] == 8001) {
                [MBProgressHUD showSuccess:@"删除成功" toView:self.view];
            } else {
                [MBProgressHUD showError:@"删除失败,请重试" toView:self.view];
            }
            
            [self refreshData];
            
            
        } failure: ^(NSURLSessionDataTask *operation, NSError *error) {
            NSLog(@"error = %@",error.description);
            [MBProgressHUD hideHUDForView:self.view];
        }];
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (flag) {
        index ++;
        NSLog(@"+%ld",(long)index);
        _rightBut.title = @"删除";
    }else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Article" bundle:nil];
        ArticleDetailViewController *actView = [storyboard instantiateViewControllerWithIdentifier:@"detailArticle"];
        ArticleObject *obj = _objArr[indexPath.row];
        CollectionObject *coll = _objArr[indexPath.row];
        actView.articleId = coll.articleid;
        actView.titleName = obj.titlename;
        actView.subStance = obj.substance;
        actView.time = obj.edittime;
        actView.hits = [NSString stringWithFormat:@"阅读%d次",obj.hits];
        actView.writer = [NSString stringWithFormat:@"作者:%@",obj.username];
        [self.navigationController pushViewController:actView animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    index--;
    NSLog(@"-%ld",(long)index);
    if (index == 0) {
        _rightBut.title = @"取消";
    }
    
}


- (IBAction)Return:(UIBarButtonItem *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)rightButAction:(UIBarButtonItem *)sender {
    flag = true;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    [self.tableView setEditing:YES animated:YES];
    
    if ([sender.title isEqualToString: @"取消"]) {
        [self.tableView setEditing:NO animated:YES];
        flag = NO;
        sender.title = @"编辑";
    }else if ([sender.title isEqualToString: @"删除"]){
        // 选中的行
        NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
        NSLog(@"selectedRows = %@",selectedRows);
        [Utilities popUpAlertViewWithMsg:@"是否确认删除?" andTitle:@"提示" onView:self tureAction:^(UIAlertAction *action) {
            NSString *collids = @"";
            for (NSIndexPath *obj in selectedRows){
                NSLog(@"obj = %ld",(long)obj.row);
                CollectionObject *coll = _objArr[obj.row];
                NSLog(@"coll = %@",coll);
                collids = [NSString stringWithFormat:@"%@|%@",collids,coll.id];
                NSLog(@"collids = %@",collids);
                
            }
            
            NSDictionary *parameters = @{@"collid":collids};
            
            NSString *url = @"http://192.168.61.154:8080/XY_Project/servlet/collectionRemoves";
            NSString *decodedURL = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [[AppAPIClient sharedClient] POST:decodedURL parameters:parameters progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
                if ([responseObject[@"resultFlag"]integerValue] == 8001) {
                    [MBProgressHUD showSuccess:@"删除成功" toView:self.view];
                } else {
                    [MBProgressHUD showError:@"删除失败,请重试" toView:self.view];
                }
                sender.title = @"编辑";
                index = 0;
                flag = NO;
                [self refreshData];
                
            } failure: ^(NSURLSessionDataTask *operation, NSError *error) {
                NSLog(@"error = %@",error.description);
                
            }];
        } flaseAction:^(UIAlertAction * _Nonnull action) {
            sender.title = @"编辑";
        }];
        
        
        [self.tableView setEditing:NO animated:YES];
        
        self.tableView.allowsMultipleSelectionDuringEditing = NO;
        
    }else{
        sender.title = @"取消";
    }
    
    
    
    
    
}
@end
