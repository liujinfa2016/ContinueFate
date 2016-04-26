//
//  AMArticleViewController.m
//  ContinueFate
//
//  Created by admin2015 on 16/4/19.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "AMArticleViewController.h"
#import "HMSegmentedControl.h"
#import "ArticleObject.h"
#import "AMACellTableViewCell.h"
#import "ArticleDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface AMArticleViewController () <UITableViewDataSource,UITableViewDelegate> {
    NSInteger page;
    NSInteger perPage;
    NSInteger totalPage;
}
@property (strong ,nonatomic)NSMutableArray *objArr;
@property (strong ,nonatomic)NSDictionary *parameters;

@end

@implementation AMArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    page = 1;
    perPage = 4;
    _objArr = [NSMutableArray new];
    [self refreshDownAndUp];
    
     
    
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    //设置分段选择栏内容
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"谈恋爱", @"挽回爱情", @"挽救婚姻", @"星座爱情", @"婚恋讲座", @"实践总结", @"客户心声"]];
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    //设置分段选择的位置
    segmentedControl.frame = CGRectMake(0, 0, viewWidth, 40);
    
    segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 20);
    //设置分段选择栏选中的分格
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    //设置分段选择栏的背景颜色
    segmentedControl.selectionIndicatorColor=UIColorBackground;
    //设置选中时底部横线的高度
    segmentedControl.selectionIndicatorHeight=2.0;
    //设置选中时底部横线的位置（上、下、没有横线）
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.verticalDividerEnabled = YES;
    //设置分段选择栏分隔线的背景颜色
    segmentedControl.verticalDividerColor = UIColorMajor;
    segmentedControl.verticalDividerWidth = 1.0f;
    //设置分段选择栏的背景颜色
    segmentedControl.backgroundColor = UIColorMajor;
    [segmentedControl setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        //设置分段选择栏内字体的风格和属性
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:234.0f/255.0f green:67.0f/255.0f blue:112.0f/255.0f alpha:1.0f],NSFontAttributeName: [UIFont fontWithName:@"Helvetica Neue" size:13]}];
        
        return attString;
    }];
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    [self requestData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//数据请求 设置入参
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            _parameters = @{@"type":@"",@"subtype":@"",@"page":@(page),@"perPage":@(perPage)};
            [self requestData];
            break;
        case 1:
            _parameters = @{@"type":@"谈恋爱",@"subtype":@"如何谈恋爱",@"page":@(page),@"perPage":@(perPage)};
            [self requestData];
            break;
        case 2:
            _parameters = @{@"type":@"挽回爱情",@"subtype":@"挽回爱情的方法",@"page":@(page),@"perPage":@(perPage)};
            [self requestData];
            break;
        case 3:
            _parameters = @{@"type":@"挽救婚姻",@"subtype":@"挽救婚姻的方法",@"page":@(page),@"perPage":@(perPage)};
            [self requestData];
            break;
        case 4:
            _parameters = @{@"type":@"星座爱情",@"subtype":@"星座爱情",@"page":@(page),@"perPage":@(perPage)};
            [self requestData];
            break;
        case 5:
            _parameters = @{@"type":@"婚恋讲座",@"subtype":@"婚恋讲座",@"page":@(page),@"perPage":@(perPage)};
            [self requestData];
            break;
        case 6:
            _parameters = @{@"type":@"实践总结",@"subtype":@"实践总结",@"page":@(page),@"perPage":@(perPage)};
            [self requestData];
            break;
        case 7:
            _parameters = @{@"type":@"客户心声",@"subtype":@"客户心声",@"page":@(page),@"perPage":@(perPage)};
            [self requestData];
            break;
            
        default:
            break;
    }
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
    //  UIActivityIndicatorView *avi = [Utilities getCoverOnView:self.view];
    
    [[AppAPIClient sharedClient] GET: url parameters:_parameters progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
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
    // NSLog(@"_objectForShow = %lu",(unsigned long)_objectForShow.count);
    return _objArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AMACellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
     ArticleObject *artObj = _objArr[indexPath.row];
    NSLog(@"hwwhdiufvhdw = %@",artObj);
    NSString * titlename = artObj.titlename;
    NSString * substance = artObj.substance;
    cell.titleName.text = titlename;
    cell.substance.text = substance;
    
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
 
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self requestData];
    }];
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if (page < totalPage) {
            page ++;
            
            [self requestData];
        } else {
            [_tableView.mj_footer setState:MJRefreshStateNoMoreData];
        }
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

@end
