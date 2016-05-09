//
//  QuestViewController.m
//  ContinueFate
//
//  Created by hua on 16/4/17.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "QuestViewController.h"
#import "DetailTableViewCell.h"
#import "QuestionTableViewCell.h"
#import "QuestionObject.h"
#import "ViewController.h"


@interface QuestViewController ()<UITableViewDelegate>{
    NSInteger page;
    NSInteger perpage;
    NSInteger total;
    NSInteger type;
    NSInteger answerid;
}
@property (strong,nonatomic)NSMutableArray *experts;
@property (strong,nonatomic)NSMutableArray *customer;
@property (strong,nonatomic)NSMutableArray *objectsForShow;
@property (strong,nonatomic)UIButton *save;
@property (strong,nonatomic)UIButton *cancel;
@property (strong,nonatomic)UIView *ansview;
@property (strong,nonatomic)UITextView *comment;
@property (strong,nonatomic)UIView *footerView;
@property (strong,nonatomic)UIButton *myComment;

@end

@implementation QuestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self dataDataTransfer];
    _objectsForShow = [NSMutableArray new];
    _experts = [NSMutableArray new];
    _customer = [NSMutableArray new];
    _tableView.tableFooterView = [[UIView alloc]init];
    page = 1;
    perpage = 10;
    
    [self requestData];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航条"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DisableGesture" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dataDataTransfer{
    _objectsForShow = [NSMutableArray new];
    NSURL *URL = [NSURL URLWithString:_detail.userHeadImage];
    [_userImage sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"初始头像"]];
    _username.text = [NSString stringWithFormat:@"%@",_detail.userNickname];
    
    NSString *date = [_detail.time substringToIndex:19];
    NSAttributedString *inputDate = [Utilities getIntervalAttrStr:date];
    _timeLbl.attributedText = inputDate;
    
    _titlename.text = [NSString stringWithFormat:@"%@",_detail.titlename];
    
    _substance.text = [NSString stringWithFormat:@"%@", _detail.substance];
    
    _typeLbl.text = [NSString stringWithFormat:@"%@", _detail.type];
    
}

- (void)requestData{
    NSDictionary *parameters = @{@"questionid":_detail.Id,@"usertype":@"usertype"};
    [MBProgressHUD showMessage:@"正在刷新" toView:self.view];
    [RequestAPI postURL:@"/answerList" withParameters:parameters success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"resultFlag"]integerValue] == 8001) {
            NSDictionary *dict = responseObject[@"result"];
            NSArray *data = dict[@"models"];
            NSDictionary *totalData = dict[@"paginginfo"];
            total = [totalData[@"total"]integerValue];
            _ansNumber.text = [NSString stringWithFormat:@"回答数:%ld",(long)total];
            
            if (page == 1) {
                _objectsForShow = nil;
                _objectsForShow = [NSMutableArray new];
            }
            
            for(NSDictionary *question in data){
                if ([question[@"usertype"]  isEqual: @1]) {
                    QuestionObject *quest = [[QuestionObject alloc]initWithDictionary:question];
                    [_customer addObject:quest];
                    
                }
                if ([question[@"usertype"]  isEqual: @2]) {
                    QuestionObject *quest = [[QuestionObject alloc]initWithDictionary:question];
                    [_experts addObject:quest];
                }
                
                NSDictionary *dic1 = @{@"group":@"用户回答",@"usertype":_customer};
                NSDictionary *dic2 = @{@"group":@"专家回答",@"usertype":_experts};
                _objectsForShow = [[NSMutableArray alloc] initWithObjects:dic2, dic1, nil];
                
            }
            
            [_tableView reloadData];
        }else{
            NSLog(@"暂无更多评论！");
            _ansNumber.text = [NSString stringWithFormat:@"暂无更多评论"];
            [self createTableFooter];
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error.description);
        
        [Utilities popUpAlertViewWithMsg:@"服务器连接失败，请稍候重试" andTitle:nil onView:self];
    }];
}

- (void)createTableFooter{
    
    _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, UI_SCREEN_H - 114, UI_SCREEN_W, 50)];
    _footerView.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:248.0f/255.0f blue:254.0f/255.0f alpha:1.0f];
    ;
    _myComment = [[UIButton alloc]initWithFrame:CGRectMake(10, _footerView.frame.size.height - 42, _footerView.frame.size.width - 20, 35)];
    _myComment.layer.cornerRadius = 5;
    _myComment.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:199.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    
    [_myComment setTitle:@"我来回答" forState:UIControlStateNormal];
    [_myComment addTarget:self action:@selector(addAnswer) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:_myComment];
    
    [self.view addSubview:_footerView];
}

- (void)addAnswer{
    
    if ([Utilities loginState]) {
        [self isLogin];
    }else{
        [self answerView];
        [_cancel addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [_save addTarget:self action:@selector(saveData) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)saveData{
    _ansview.hidden = YES;
    NSString *sub = [NSString stringWithFormat:@"%@",_comment.text];
    NSString *userid = [[StorageMgr singletonStorageMgr]objectForKey:@"UserID"];
    NSDictionary *parameters = @{@"sustance":sub,@"usertype":@1,@"questionid":_detail.Id,@"id":userid};
    [RequestAPI postURL:@"/answerAppend" withParameters:parameters success:^(id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        if ([responseObject[@"resultFlag"]integerValue] == 8001) {
            NSDictionary *dict = responseObject[@"result"];
            NSDictionary *totalData = dict[@"paginginfo"];
            total = [totalData[@"total"]integerValue];
            _ansNumber.text = [NSString stringWithFormat:@"回答数:%ld",(long)total];
            NSLog(@"sub = %@",sub);
            NSLog(@"id = %@",userid);
            NSLog(@"questionid = %@",_detail.Id);
            
            [_tableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error.description);
        [Utilities popUpAlertViewWithMsg:@"服务器连接失败，请稍候重试" andTitle:nil onView:self];
    }];
}

- (NSString *)answeridForTag:(NSInteger)section row:(NSInteger)row {
    NSString *answerId = @"";
    NSDictionary *dic1 = _objectsForShow[1];
    NSDictionary *dic2 = _objectsForShow[0];
    if (section == 0) {
        NSArray *arr = dic2[@"usertype"];
        QuestionObject *quest = arr[(long)row];
        answerId = quest.Id;
    }else{
        NSArray *arr = dic1[@"usertype"];
        QuestionObject *quest = arr[(long)row];
        answerId = quest.Id;
    }
    return answerId;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _objectsForShow.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dic = _objectsForShow[section];
    
    NSArray *arr = dic[@"usertype"];
    
    return arr.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    //根据当前渲染的细胞的组号，获得该组所对应字典信息
    NSDictionary *dict = _objectsForShow[section];
    //根据上述字典信息获得“group”键所对应的值并返回
    return dict[@"group"];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _objectsForShow[indexPath.section];
    NSArray *arr = dic[@"usertype"];
    QuestionObject *question = arr[indexPath.row];
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    CGSize maxSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width - 30, 1000);
    CGSize substanceSize = [question.time boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:cell.substance.font} context:nil].size;
    return cell.substance.frame.origin.y + substanceSize.height + 15;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    NSDictionary *dic = _objectsForShow[indexPath.section];
    //    NSLog(@"question = %@",obj);
    NSArray *arr = dic[@"usertype"];
    
    QuestionObject *obj = arr[indexPath.row];
    if (obj.usertype.integerValue == 1) {
        cell.actBtn.hidden = YES;
    }
    
    //    [[StorageMgr singletonStorageMgr]addKey:@"answerID" andValue:obj.answerID];
    NSString *substance = obj.substance;
    NSString *date = [obj.time substringToIndex:19];
    NSAttributedString *inputDate = [Utilities getIntervalAttrStr:date];
    NSString *name = obj.expertName;
    NSURL *url = [NSURL URLWithString:obj.expertHeadImage];
    [cell.expertImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"初始头像"]];
    cell.expertName.text = name;
    cell.substance.text = substance;
    cell.time.attributedText = inputDate;
    NSString  *tag = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.row,(long)indexPath.section];
    
    cell.answer.tag = tag.intValue;
    
    return cell;
}

- (IBAction)convention:(UIButton *)sender forEvent:(UIEvent *)event {
    
    self.navigationController.tabBarController.selectedIndex = 3;
    
}

- (void)addAnswerView{
    [self answerView];
    [_cancel addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [_save addTarget:self action:@selector(ansRequest) forControlEvents:UIControlEventTouchUpInside];
}


- (void)answerView{
    _ansview = [[UIView alloc]initWithFrame:CGRectMake(0, UI_SCREEN_H - 190, UI_SCREEN_W, 190)];
    _ansview.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:248.0f/255.0f blue:254.0f/255.0f alpha:1.0f];
    ;
    _cancel = [[UIButton alloc]initWithFrame:CGRectMake(5, _ansview.frame.size.height - 180, 60, 20)];
    [_cancel setTitleColor:[UIColor colorWithRed:0.0f/255.0f green:199.0f/255.0f blue:255.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [_cancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [_ansview addSubview:_cancel];
    
    _save = [[UIButton alloc]initWithFrame:CGRectMake(UI_SCREEN_W - 60, _ansview.frame.size.height - 180, 60, 20)];
    [_save setTitleColor:[UIColor colorWithRed:0.0f/255.0f green:199.0f/255.0f blue:255.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [_save setTitle:@"OK" forState:UIControlStateNormal];
    [_ansview addSubview:_save];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake((UI_SCREEN_W - 30)/ 2 , _ansview.frame.size.height - 180, 60, 20)];
    title.text = @"评论";
    title.textColor = [UIColor blackColor];
    title.font = [UIFont systemFontOfSize:B_Font];
    [_ansview addSubview:title];
    
    _comment = [[UITextView alloc]initWithFrame:CGRectMake(10, _ansview.frame.size.height - 155, UI_SCREEN_W - 20, 85)];
    [_ansview addSubview:_comment];
    
    [self.view addSubview:_ansview];
}

- (void)cancelAction{
    _ansview.hidden = YES;
    NSLog(@"取消");
}

- (void)ansRequest{
    NSString *userid = [[StorageMgr singletonStorageMgr]objectForKey:@"UserID"];
    
    NSString *sub = [NSString stringWithFormat:@"%@",_comment.text];
    NSString *answer = [self answeridForTag:answerid % 10 row:answerid / 10];
    [[StorageMgr singletonStorageMgr]addKey:@"answerID" andValue:answer];
    
    NSDictionary * parameters = @{@"substance":sub,@"usertype":@1,@"answerid":answer,@"id":userid};
    if (sub.length == 0) {
        NSLog(@"您当前并未输入评论内容");
    }else{
        [RequestAPI postURL:@"/probingAppend" withParameters:parameters success:^(id responseObject) {
            NSLog(@"responseObject = %@",responseObject);
            
            [self queryData];
        } failure:^(NSError *error) {
            NSLog(@"error = %@",error.description);
        }];
    }
    _ansview.hidden = YES;
}


- (void)isLogin{
    NSString *msg = [NSString stringWithFormat:@"您当前未登录账号，无法评论，是否立即前往"];
    
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

- (IBAction)comment:(UIButton *)sender forEvent:(UIEvent *)event {
    answerid = sender.tag;
    if ([Utilities loginState]){
        [self isLogin];
    }else{
        [self addAnswerView];
    }
}

- (void)queryData{
    NSString *answer = [[StorageMgr singletonStorageMgr]objectForKey:@"answerID"];
    
    NSDictionary *parameters = @{@"answerid":answer};
    [RequestAPI postURL:@"/probingList" withParameters:parameters success:^(id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error.description);
    }];
}
@end
