//
//  slidingAppointmentViewController.m
//  ContinueFate
//
//  Created by 刘金发 on 16/4/19.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "slidingAppointmentViewController.h"
#import "SlidingAppointmentTableViewCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
@interface slidingAppointmentViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>{
    NSString *userid;
}
@property(strong,nonatomic)NSMutableArray *array;//声明一个数组用放预约信息
@property(strong,nonatomic)NSDictionary *dic;

@end

@implementation slidingAppointmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self appointmentview];
    _segment.selectedSegmentIndex = 0;
    userid =[[StorageMgr singletonStorageMgr] objectForKey:@"UserID"];
    _dic = @{@"userid":userid,@"typeid":@1};
    [self Request];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
    _array=[NSMutableArray new];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航条"] forBarMetrics:UIBarMetricsDefault];
    
}
//当没有预约信息，执行的方法
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"您暂时没有预约信息";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)appointmentview{
   

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//请求卡片的所有信息
-(void)Request{
    [_array removeAllObjects];
    [RequestAPI postURL:@"/getOrderList" withParameters:_dic success:^(id responseObject) {
//        if ([responseObject[@"resultFlag"]integerValue]  == 6002) {
//           
//        }
        if ([responseObject[@"resultFlag"]integerValue]  == 8001) {
            NSDictionary *dic = responseObject[@"result"];
            
            NSArray *arr = dic[@"models"];
            for (NSDictionary *dic in arr) {
                [_array addObject:dic];
                
            }
            
        }
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        [Utilities popUpAlertViewWithMsg:@"请保持网络畅通" andTitle:nil onView:self];
       
    }];
    
}
//当按了segmentaction的不同控件时
- (IBAction)SegmentAction:(UISegmentedControl *)sender forEvent:(UIEvent *)event {
    switch (_segment.selectedSegmentIndex) {
           
        case 0:
           
            _dic = @{@"userid":userid,@"typeid":@1};
            [self Request];
            break;
        case 1:
            
            _dic = @{@"userid":userid,@"typeid":@1,@"ordername":@"待回复"};
             [self Request];
            break;
        case 2:
           
            _dic = @{@"userid":userid,@"typeid":@1,@"ordername":@"待付款"};
             [self Request];
            break;
        case 3:
            _dic = @{@"userid":userid,@"typeid":@1,@"ordername":@"已付款待联系"};
             [self Request];
            break;
        default:
            break;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}
//点击去付款获取金额
-(void)buttonPressed:(UIButton *)button{
    NSUInteger index = button.tag;
    NSDictionary *dic = _array[index];
    NSNumber *money =dic[@"orderTypePrice"];
    NSLog(@"金额 ＝ %@",money);
    
    // 根据tag就可以知道哪一个cell上的按钮
}
//点击头像执行跳转
-(void)exbutton:(UIButton *)button{
    NSUInteger index = button.tag;
    NSDictionary *dic = _array[index];
    NSString *exid =dic[@"expertId"];
    NSLog(@"专家id ＝＝ %@",exid);
    [self dismissViewControllerAnimated:[Utilities getStoryboardInstanceByIdentity:@"" byIdentity:@""] completion:^{
        
    }];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    SlidingAppointmentTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //激活点击事件
    tableView.delaysContentTouches = YES;
    NSDictionary *dit = _array[indexPath.row];
    //查询"待付款"的标签
    if ([dit[@"orderStateName"] isEqualToString:@"待付款"]) {
        cell.paybut.hidden = NO;
        cell.paybut.tag = [indexPath row];
        //点击按钮触发事件
        [cell.paybut addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        cell.paybut.hidden = YES;
    }
    
    //专家名字
    cell.ExpertsnameLab.text = dit[@"expertName"];
    //预约状态
    cell.IfSuccessLab.text = dit[@"orderStateName"];
    //卡片类型
    cell.CardLab.text = dit[@"orderTypeName"];
    //卡片的图片
    [cell.cardIM sd_setImageWithURL:dit[@"orderTypeImage"] placeholderImage:[UIImage imageNamed:@"专家入驻"]];
    //添加头像跳转事件
    [cell.exButton addTarget:self action:@selector(exbutton:) forControlEvents:UIControlEventTouchUpInside];
    //  专家头像
    [cell.eximage sd_setImageWithURL:dit[@"expertHeadImage"] placeholderImage:[UIImage imageNamed:@"图1"]];
    //金额
    cell.MoneyLab.text = [NSString stringWithFormat:@"¥%@",dit[@"orderTypePrice"]];
    
    return cell;
    
}
// 返回
- (IBAction)ReturnAction:(UIBarButtonItem *)sender {
    
  [self presentViewController:[Utilities getStoryboardInstanceByIdentity:@"TabBar" byIdentity:@"TabBar"] animated:NO completion:nil];

}
@end
