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
#import "Colours.h"
#import <UIImageView+WebCache.h>
@interface QuestionViewController (){
    NSInteger page;
    NSInteger perPage;

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
    perPage = 10;
    [self requestData];
    
    
    UIButton *activityBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,30, 30)];
    activityBtn.titleLabel.font = [UIFont systemFontOfSize:A_Font];
    [activityBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [activityBtn setTitleColor:[UIColor infoBlueColor] forState:UIControlStateNormal];
    [activityBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityBtn];
    _questArr = @[@"女生恋爱",@"男生恋爱",@"挽救爱情",@"拯救婚姻",@"婚姻家庭"];
    FSDropDownMenu *menu = [[FSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:180];
    menu.tag = 1001;
    menu.dataSource = self;
    menu.delegate = self;
    [self.view addSubview:menu];
    
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
    [menu.leftTableView reloadData];
    [self requestData];
    [_tableView reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detail"]) {
        NSIndexPath *indexPath = _tableView.indexPathForSelectedRow;
        QuestViewController *bdVC = segue.destinationViewController;
        bdVC.detail = _objectsForShow[indexPath.row];
    }
}

- (void)requestData{
    NSDictionary *parameters = @{@"type":@"",@"page":@(page),@"perPaeg":@(perPage)};
    [[AppAPIClient sharedClient]POST:@"http://192.168.61.85:8080/XuYuanProject/questionList" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        if ([responseObject[@"resultFlag"]integerValue] == 8001) {
            NSDictionary *dict = responseObject[@"result"];
            NSArray *data = dict[@"models"];
            if (page == 1) {
                _objectsForShow = nil;
                _objectsForShow = [NSMutableArray new];
                perPage = 5;
                
            }
            for(NSDictionary *question in data){
                QuestionObject *quest = [[QuestionObject alloc]initWithDictionary:question];
                [_objectsForShow addObject:quest];
            }
            NSLog(@"obj = %@",_objectsForShow);
            [_tableView reloadData];
        }else{
            [Utilities popUpAlertViewWithMsg:@"服务器连接失败，请稍候重试" andTitle:nil onView:self];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.description);
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
    NSLog(@"question = %@",obj);
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
    return cell.time.frame.origin.y + timeSize.height + 16;
}

- (IBAction)askAction:(UIBarButtonItem *)sender {
    QTranfViewController *tabVC = [Utilities getStoryboardInstanceByIdentity:@"Question" byIdentity:@"tranf"];
    [self presentViewController:tabVC animated:YES completion:nil];
}

@end
