//
//  QuestionViewController.m
//  ContinueFate
//
//  Created by px on 16/4/17.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "QuestionViewController.h"
#import "QuestionTableViewCell.h"
#import "QuestViewController.h"
#import "QuestionObject.h"
#import "QTranfViewController.h"
#import "FSDropDownMenu.h"
#import "ViewController.h"

@interface QuestionViewController (){
    NSInteger page;
    NSInteger perPage;
    NSInteger totalPage;
    
}
@property (strong,nonatomic)NSMutableArray *objectsForShow;
@property (strong,nonatomic)NSArray *questArr;

@end

@implementation QuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _objectsForShow = [NSMutableArray new];
    _tableView.tableFooterView = [[UIView alloc]init];
    page = 1;
    perPage = 5;
    [self requestData];
    [self refreshDownAndUp];
    [self screening];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestData) name:@"RefreshHome" object:nil];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航条"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}

- (void)screening{
    UIButton *activityBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,30, 30)];
    activityBtn.titleLabel.font = [UIFont systemFontOfSize:B_Font];
    [activityBtn setTitle:@"筛选" forState: UIControlStateNormal];
    [activityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [activityBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityBtn];
    _questArr = @[@"女生恋爱",@"男生恋爱",@"挽救爱情",@"拯救婚姻",@"婚姻家庭"];
    FSDropDownMenu *menu = [[FSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:176];
    
    menu.tag = 1001;
    menu.dataSource = self;
    menu.delegate = self;
    [self.view addSubview:menu];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"EnableGesture" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DisableGesture" object:nil];
}


-(void)btnPressed:(id)sender{
    FSDropDownMenu *menu = (FSDropDownMenu*)[self.view viewWithTag:1001];
    [UIView animateWithDuration:1.f animations:^{
        
    } completion:^(BOOL finished) {
        [menu menuTapped];
    }];
}


#pragma mark - FSDropDown datasource & delegate

- (NSInteger)menu:(FSDropDownMenu *)menu tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return _questArr.count;
}
- (NSString *)menu:(FSDropDownMenu *)menu tableView:(UITableView*)tableView titleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _questArr[indexPath.row];
}

- (void)menu:(FSDropDownMenu *)menu tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //  [menu.leftTableView reloadData];
    [_tableView reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    QuestViewController *quest = [Utilities getStoryboardInstanceByIdentity:@"Question" byIdentity:@"quest"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detail"]) {
        NSIndexPath *indexPath = _tableView.indexPathForSelectedRow;
        QuestViewController *bdVC = segue.destinationViewController;
        bdVC.detail = _objectsForShow[indexPath.row];
    }
}

- (void)requestData{
    
    NSDictionary *parameters = @{@"type":@"",@"page":@(page),@"perPage":@(perPage)};
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    self.navigationController.view.userInteractionEnabled = NO;
    [RequestAPI postURL:@"/questionList" withParameters:parameters success:^(id responseObject) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        self.navigationController.view.userInteractionEnabled = YES;
        [MBProgressHUD hideHUDForView:self.view];
        NSLog(@"%@",responseObject);
        if ([responseObject[@"resultFlag"]integerValue] == 8001) {
            NSDictionary *dict = responseObject[@"result"];
            NSArray *data = dict[@"models"];
            NSDictionary *pageDict = dict[@"paginginfo"];
            totalPage = [pageDict[@"totalPage"]integerValue];
            if (page == 1) {
                _objectsForShow = nil;
                _objectsForShow = [NSMutableArray new];
                perPage = 5;
            }
            for(NSDictionary *question in data){
                QuestionObject *quest = [[QuestionObject alloc]initWithDictionary:question];
                [_objectsForShow addObject:quest];
            }
            
            [_tableView reloadData];
        }else{
            [Utilities popUpAlertViewWithMsg:@"服务器连接失败，请稍候重试" andTitle:nil onView:self];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
        [MBProgressHUD hideHUDForView:self.view];
        
    }];
}

- (void)refreshDownAndUp {
    
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%lu",(unsigned long)_objectsForShow.count);
    return _objectsForShow.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    QuestionTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    //将留白设置为0
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    QuestionObject *obj = _objectsForShow[indexPath.row];
    
    NSString *titlename = obj.titlename;
    NSString *substance = obj.substance;
    NSString *date = [obj.time substringToIndex:19];
    NSAttributedString *inputDate = [Utilities getIntervalAttrStr:date];
    NSString *type = obj.type;
    
    NSString *name = obj.userNickname;
    NSURL *URL = [NSURL URLWithString:obj.userHeadImage];
    [cell.userImage sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"初始头像"]];
    cell.username.text = name;
    cell.type.text = type;
    cell.time.attributedText = inputDate;
    cell.tiltlename.text = titlename;
    cell.substance.text = substance;
    return cell;
}

//自适应高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    QuestionObject *question = [_objectsForShow objectAtIndex:indexPath.row];
    QuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    CGSize maxSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width - 30, 1000);
    CGSize timeSize = [question.time boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:cell.time.font} context:nil].size;
    return cell.time.frame.origin.y + timeSize.height;
 
}

- (IBAction)askAction:(UIBarButtonItem *)sender {
    if ([Utilities loginState]){
        NSString *msg = [NSString stringWithFormat:@"您当前未登录，是否立即前往"];
        
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            ViewController *alert = [Utilities getStoryboardInstanceByIdentity:@"Main" byIdentity:@"Login"];
            [self presentViewController:alert animated:YES completion:nil];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertView addAction:confirmAction];
        [alertView addAction:cancelAction];
        [self presentViewController:alertView animated:YES completion:nil];
    }
    QTranfViewController *tabVC =  [Utilities getStoryboardInstanceByIdentity:@"Question" byIdentity:@"tranf"];
    [self presentViewController:tabVC animated:YES completion:nil];
}
@end
