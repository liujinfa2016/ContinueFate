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

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    SlidingAppointmentTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *dit = _array[indexPath.row];
     NSLog(@"66666===%@",dit);
    if ([dit[@"orderStateName"] isEqual: @"待付款"]) {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(cell.bounds.size.width-85, cell.bounds.size.height-60, 75, 75);
    [button setTitle:@"去付款" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        //给button添加委托方法，即点击触发的事件。
//        [button addTarget:selfaction:@selector(touchButton1:)  forControlEvents :UIControl EventTouchUp Inside];
      [cell addSubview:button];
        
    }
   
    //专家名字
    cell.ExpertsnameLab.text = dit[@"expertName"];
    //预约状态
    cell.IfSuccessLab.text = dit[@"orderStateName"];
    //卡片类型
    cell.CardLab.text = dit[@"orderTypeName"];
    //卡片的图片
    [cell.cardIM sd_setImageWithURL:dit[@"orderTypeImage"] placeholderImage:[UIImage imageNamed:@"专家入驻"]];
//  专家头像
    [cell.photo.imageView sd_setImageWithURL:dit[@"expertHeadImage"] placeholderImage:[UIImage imageNamed:@"图1"]];
    //金额
    cell.MoneyLab.text = [NSString stringWithFormat:@"¥%@",dit[@"orderTypePrice"]];
    
    return cell;
    
}
// 返回
- (IBAction)ReturnAction:(UIBarButtonItem *)sender {
    
  [self presentViewController:[Utilities getStoryboardInstanceByIdentity:@"TabBar" byIdentity:@"TabBar"] animated:NO completion:nil];

}
@end
