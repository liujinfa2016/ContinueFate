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
    NSString *type;
    NSString *subtype;
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
    perPage = 6;
    type = @"";
    subtype = @"";
    _objArr = [NSMutableArray new];
    [self refreshDownAndUp];
    
     
    
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    //设置分段选择栏内容
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"全部",@"谈恋爱", @"挽回爱情", @"挽救婚姻", @"星座爱情", @"婚恋讲座", @"实践总结", @"客户心声"]];
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    //设置分段选择的位置
    segmentedControl.frame = CGRectMake(0, 0, viewWidth, 40);
    
    segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 20);
    //设置分段选择栏选中的分格
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    //设置分段选择栏的背景颜色
    segmentedControl.selectionIndicatorColor=UIColorMajor;
    //设置选中时底部横线的高度
    segmentedControl.selectionIndicatorHeight=2.0;
    //设置选中时底部横线的位置（上、下、没有横线）
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.verticalDividerEnabled = YES;
    //设置分段选择栏分隔线的背景颜色
    segmentedControl.verticalDividerColor = UIColorBackground;
    segmentedControl.verticalDividerWidth = 1.0f;
    //设置分段选择栏的背景颜色
    segmentedControl.backgroundColor = UIColorBackground;
    [segmentedControl setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        //设置分段选择栏内字体的风格和属性
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0.0f/255.0f green:199.0f/255.0f blue:255.0f/255.0f alpha:1.0f],NSFontAttributeName: [UIFont fontWithName:@"Helvetica Neue" size:13]}];
        
        return attString;
    }];
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    [MBProgressHUD showMessage:@"数据加载" toView:self.view];
    [self requestData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//数据请求 设置入参
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    [MBProgressHUD showMessage:@"数据加载" toView:self.view];
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            type = @"";
            subtype = @"";
            [self requestData];
            break;
        case 1:
            page = 1;
            type = @"谈恋爱";
            subtype = @"如何谈恋爱";
            [self requestData];
            break;
        case 2:
            page = 1;
            type = @"挽回爱情";
            subtype = @"挽回爱情的方法";
            [self requestData];
            break;
        case 3:
            page = 1;
            type = @"挽救婚姻";
            subtype = @"挽救婚姻的方法";
            [self requestData];
            break;
        case 4:
            page = 1;
            type = @"星座爱情";
            subtype = @"星座爱情";
            [self requestData];
            break;
        case 5:
            page = 1;
            type = @"婚恋讲座";
            subtype = @"婚恋讲座";
            [self requestData];
            break;
        case 6:
            page = 1;
            type = @"实践总结";
            subtype = @"实践总结";
            [self requestData];
            break;
        case 7:
            page = 1;
            type = @"客户心声";
            subtype = @"客户心声";
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
    _parameters = @{@"type":type,@"subtype":subtype,@"page":@(page),@"perPage":@(perPage)};
    NSString *url = @"http://192.168.61.154:8080/XY_Project/servlet/showArticle";
    //  UIActivityIndicatorView *avi = [Utilities getCoverOnView:self.view];
    [[AppAPIClient sharedClient] GET: url parameters:_parameters progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"resultFlag"]integerValue] == 8001) {
            NSDictionary *result = responseObject[@"result"];
            NSArray *dataArr = result[@"models"];
            NSDictionary *pageDict = result[@"paginginfo"];
            
            if (page == 1){
                _objArr = nil;
                _objArr = [NSMutableArray new];
                
                perPage = 6;
            }
            for  (NSDictionary *art in dataArr) {
                ArticleObject *artObj = [[ArticleObject alloc]initWithDictionary:art];
                
                [_objArr addObject:artObj];
                
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
    AMACellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
     ArticleObject *artObj = _objArr[indexPath.row];

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
