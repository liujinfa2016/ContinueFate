//
//  FirstViewController.m
//  ContinueFate
//
//  Created by demon on 16/4/17.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "FirstViewController.h"
#import "FirstTableViewCell.h"
#import "ArticleObject.h"
#import "ConsultingViewController.h"
#import <SDCycleScrollView.h>
#import "ArticleDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface FirstViewController ()<SDCycleScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    NSInteger page;
    NSInteger perPage;
    NSInteger totalPage;
}
@property (strong, nonatomic) NSMutableArray *objArr;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    _objArr = [NSMutableArray new];
    page = 1;
    perPage = 4;
    
    [self cycleScrollBegin];
    [self refreshDownAndUp];
    [self netWorkRequest];

    
    _tableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _objArr.count;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSLog(@"%@",_objArr);
    ArticleObject *obj = _objArr[indexPath.row];
    
    cell.datelbe.attributedText = [Utilities getIntervalAttrStr:[obj.edittime substringToIndex:19]];
    cell.contentLab.text = obj.substance;
    cell.articleTitlelab.text = obj.titlename;
    cell.readQuantitylab.text = [NSString stringWithFormat:@"阅读%d次",obj.hits];
    
    NSDictionary *dic = [[Utilities getImageURL:obj.substance]copy];
    NSString *imagrURL = dic[@"imageURL"];
    NSURL *photoURL = [NSURL URLWithString:imagrURL];
    [cell.headImage sd_setImageWithURL:photoURL placeholderImage:[UIImage imageNamed:@"横线"]];
    cell.headImage.contentMode = UIViewContentModeScaleAspectFill | UIViewContentModeScaleAspectFit;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor =  [UIColor colorWithRed:244.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 6, 100, 15)];
    label.text = @"最新更新";
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:[[UIFont familyNames] objectAtIndex:10] size:17];
    label.backgroundColor =  [UIColor colorWithRed:255.0f green:255.0f blue:255.0f alpha:0.0f];
    [headView addSubview:label];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 25)];
    label2.text = @"";
    label2.font = [UIFont fontWithName:[[UIFont familyNames] objectAtIndex:10] size:20];
    label2.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:67.0f/255.0f blue:112.0f/255.0f alpha:1.0f];
    
    
    [headView addSubview:label2];
    return headView;
}


//下拉刷新及上拉刷新
- (void) refreshDownAndUp {
    //动画下拉功能
    UIImage *image1 = [UIImage imageNamed:@"图1"];
    UIImage *image2 = [UIImage imageNamed:@"图2"];
    UIImage *image3 = [UIImage imageNamed:@"图3"];
  /*  UIImage *image4 = [UIImage imageNamed:@"04"];
    UIImage *image5 = [UIImage imageNamed:@"05"];
    UIImage *image6 = [UIImage imageNamed:@"06"];
    UIImage *image7 = [UIImage imageNamed:@"07"];*/
    
    NSArray *image = @[image1,image2,image3];
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(netWorkRequest)];
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
            
            [self netWorkRequest];
        } else {
            [_tableView.mj_footer setState:MJRefreshStateNoMoreData];
        }
    }];
    
}

//网络请求 提取数据
- (void) netWorkRequest {
    NSDictionary *parameters = @{@"type":@"",@"subtype":@"",@"page":@(page),@"perPage":@(perPage)};
    
    NSString *url = @"http://192.168.61.154:8080/XY_Project/servlet/showArticle";
    NSString *decodedURL = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[AppAPIClient sharedClient] GET:decodedURL parameters:parameters progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
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
            
            for (NSDictionary *dict in dataArr) {
                ArticleObject *artObj = [[ArticleObject alloc]initWithDictionary:dict];
                [_objArr addObject:artObj];
            }
            [self.tableView reloadData];
            
            totalPage = [pageDict[@"totalPage"]integerValue];
            
        } else {
            [Utilities popUpAlertViewWithMsg:@"获取数据失败" andTitle:nil onView:self];
        }
    } failure: ^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"error = %@",error.description);
    }];
    
    
    //    [RequestAPI getURL:@"" withParameters:parameters success:^(id responseObject) {
    //
    //    } failure:^(NSError *error) {
    //
    //    }];
}

//创建图片轮播器
- (void) cycleScrollBegin {
    //设置所需显示的图片网址
    NSArray *imagesURLArr = @[
                              @"http://www.wanhuiaiqing.com/wp-content/themes/wangwang-jssjkj/images/slide1.jpg",
                              @"http://www.wanhuiaiqing.com/wp-content/themes/wangwang-jssjkj/images/slide2.jpg",
                              @"http://www.wanhuiaiqing.com/wp-content/themes/wangwang-jssjkj/images/slide3.jpg",
                              @"http://www.wanhuiaiqing.com/wp-content/themes/wangwang-jssjkj/images/slide4.jpg",
                              ];    //图片所配的图片
    
    
    // 网络加载 --- 创建带标题的图片轮播器
    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0,UI_SCREEN_W, UI_SCREEN_W*135/256) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    cycleScrollView2.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    [_scrollView addSubview:cycleScrollView2];
    cycleScrollView2.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    cycleScrollView2.imageURLStringsGroup = imagesURLArr;
}

#pragma mark - SDCycleScrollViewDelegate
//点击图片后做的操作
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    switch (index) {
        case 0:
            [Utilities popUpAlertViewWithMsg:@"恭喜你点到了第一个妹子" andTitle:nil onView:self];
            break;
        case 1:
            [Utilities popUpAlertViewWithMsg:@"恭喜你点到了第二个妹子" andTitle:nil onView:self];
            break;
        case 2:
            [Utilities popUpAlertViewWithMsg:@"恭喜你点到了第三个妹子" andTitle:nil onView:self];
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:[NSClassFromString(@"DemoVCWithXib") new] animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (IBAction)consulAction:(UIButton *)sender forEvent:(UIEvent *)event {
    self.navigationController.tabBarController.selectedIndex = 3;
}

- (IBAction)successAction:(UIButton *)sender forEvent:(UIEvent *)event{
    self.navigationController.tabBarController.selectedIndex = 1;
}
- (IBAction)answerAction:(UIButton *)sender forEvent:(UIEvent *)event {
    self.navigationController.tabBarController.selectedIndex = 2;
}
@end
