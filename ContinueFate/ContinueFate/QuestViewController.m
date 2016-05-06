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
#import "CEDetailsViewController.h"

@interface QuestViewController (){
    NSInteger page;
    NSInteger perpage;
    NSInteger total;
    NSInteger type;
    
}
@property (strong,nonatomic)NSMutableArray *experts;
@property (strong,nonatomic)NSMutableArray *customer;
@property (strong,nonatomic)NSMutableArray *objectsForShow;

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
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error.description);
        
        [Utilities popUpAlertViewWithMsg:@"服务器连接失败，请稍候重试" andTitle:nil onView:self];
    }];
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


//-(void)layoutSubviews{
//
//}

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    static NSString *cellIndentifiter = @"CellIndentifiter";
//
//    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
//
//    if (cell == nil) {
//        //cell的自定义绘制
//    }
//
//    //cell的属性设置
//
//    return cell;
//}


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
    NSString *substance = obj.substance;
    NSString *date = [obj.time substringToIndex:19];
    NSAttributedString *inputDate = [Utilities getIntervalAttrStr:date];
    NSString *name = obj.expertName;
    NSURL *url = [NSURL URLWithString:obj.expertHeadImage];
    [cell.expertImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"初始头像"]];
    cell.expertName.text = name;
    cell.substance.text = substance;
    cell.time.attributedText = inputDate;
    
    return cell;
}

- (IBAction)convention:(UIButton *)sender forEvent:(UIEvent *)event {
    
    self.navigationController.tabBarController.selectedIndex = 3;
    
}

- (IBAction)comment:(UIButton *)sender forEvent:(UIEvent *)event {
   
}
@end
