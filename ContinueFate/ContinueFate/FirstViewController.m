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
#import <SDCycleScrollView.h>

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
    perPage = 3;
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSLog(@"%@",_objArr);
    ArticleObject *obj = _objArr[indexPath.row];
    
    cell.datelbe.text = [obj.edittime substringToIndex:19];
    cell.contentLab.text = obj.substance;
    cell.articleTitlelab.text = obj.titlename;
    cell.readQuantitylab.text = [NSString stringWithFormat:@"阅读%d次",obj.hits];
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
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, 20, 24)];
    label2.text = @"";
    label2.font = [UIFont fontWithName:[[UIFont familyNames] objectAtIndex:10] size:20];
    label2.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:67.0f/255.0f blue:112.0f/255.0f alpha:1.0f];
    
    
    [headView addSubview:label2];
    return headView;
}


//下拉刷新及上拉刷新
- (void) refreshDownAndUp {
    /*************动画下拉功能********
    UIImage *image1 = [UIImage imageNamed:@"01"];
    UIImage *image2 = [UIImage imageNamed:@"02"];
    UIImage *image3 = [UIImage imageNamed:@"03"];
    UIImage *image4 = [UIImage imageNamed:@"04"];
    UIImage *image5 = [UIImage imageNamed:@"05"];
    UIImage *image6 = [UIImage imageNamed:@"06"];
    UIImage *image7 = [UIImage imageNamed:@"07"];
    
    NSArray *image = @[image1,image2,image3,image4,image5,image6,image7];
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(netWorkRequest)];
    // 设置普通状态的动画图片
    [header setImages:image forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:image forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [header setImages:image forState:MJRefreshStateRefreshing];
    // 设置header
    self.tableView.mj_header = header;
    ***********************/
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self netWorkRequest];
    }];
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [_tableView.mj_footer endRefreshing];
    }];
    
}

//网络请求 提取数据
- (void) netWorkRequest {
    NSDictionary *parameters = @{@"type":@"",@"subtype":@"",@"page":@(page),@"perPage":@(perPage)};
    
    NSString *url = @"http://192.168.61.154:8080/XY_Project/servlet/showArticle";
    NSString *decodedURL = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[AppAPIClient sharedClient] GET:decodedURL parameters:parameters progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        if ([responseObject[@"resultFlag"]integerValue] == 8001) {
            NSDictionary *result = responseObject[@"result"];
            NSArray *dataArr = result[@"models"];
            NSDictionary *pageDict = result[@"paginginfo"];
            
            if (page == 1){
                _objArr = nil;
                _objArr = [NSMutableArray new];
            }
            
            for (NSDictionary *dict in dataArr) {
                ArticleObject *artObj = [[ArticleObject alloc]initWithDictionary:dict];
                [_objArr addObject:artObj];
            }
            [self.tableView reloadData];
            
            totalPage = [pageDict[@"pageDict"]integerValue];
            
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
                              @"http://g.hiphotos.baidu.com/zhidao/pic/item/cc11728b4710b912f6e3451dc7fdfc0392452236.jpg",
                              @"http://www.6188.com/upload_6188s/flashAll/s800/20121126/1353916278md5Cri.jpg",
                              @"http://pic.6188.com/upload_6188s/flashAll/s800/20120907/1346981960xNARbD.jpg",
                              ];
    //图片所配的图片
    NSArray *titles = @[@"是不是喜欢",
                        @"是不是非常喜欢",
                        @"是不是更喜欢"
                        ];
    
    
    // 网络加载 --- 创建带标题的图片轮播器
    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0,UI_SCREEN_W, UI_SCREEN_W*135/256) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView2.titlesGroup = titles;
    cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    [_scrollView addSubview:cycleScrollView2];
    
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
}

- (IBAction)successAction:(UIButton *)sender forEvent:(UIEvent *)event{
}
- (IBAction)answerAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
