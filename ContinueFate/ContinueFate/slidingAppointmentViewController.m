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
#import "CEDetailsViewController.h"
#import "Alipay/Order.h"
#import "DataSigner.h"
#import "Alipay/AlipaySDK.framework/Headers/AlipaySDK.h"

@interface slidingAppointmentViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>{
    NSString *userid;
}
@property(strong,nonatomic)NSMutableArray *array;//声明一个数组用放预约信息
@property(strong,nonatomic)NSDictionary *dic;

@end

@implementation slidingAppointmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view.
    _segment.selectedSegmentIndex = 0;
    userid =[[StorageMgr singletonStorageMgr] objectForKey:@"UserID"];
    _dic = @{@"userid":userid,@"typeid":@1};
    [self Request];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
    _array=[NSMutableArray new];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航条"] forBarMetrics:UIBarMetricsDefault];
     self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
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
    //菊花
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    self.navigationController.view.self.userInteractionEnabled = NO;
    [RequestAPI postURL:@"/getOrderList" withParameters:_dic success:^(id responseObject) {
//        if ([responseObject[@"resultFlag"]integerValue]  == 6002) {
//           
//        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self.navigationController.view.self.userInteractionEnabled = YES;
        
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

//产生随机订单号
- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}
//点击去付款获取金额    点击订单支付行为
-(void)buttonPressed:(UIButton *)button{
    NSUInteger index = button.tag;
    NSDictionary *dic = _array[index];
    NSNumber *money =dic[@"orderTypePrice"];
    NSLog(@"金额 ＝ %@",money);
    NSString *ordername =dic[@"orderType"];
    // 根据tag就可以知道哪一个cell上的按钮
    Product *product = nil;
    product.price =money;
    product.body = ordername;
    product.subject = @"续缘心理咨询";
    product.orderId = [self generateTradeNO];
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088221188008648";
    NSString *seller = @"1326431681@qq.com";
    NSString *privateKey = @"7q91nn9g96bwv64fzh02tvahds1tz5cf";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.sellerID = seller;
    order.outTradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.subject = product.subject; //商品标题
    order.body = product.body; //商品描述
    order.totalFee = [NSString stringWithFormat:@"%@",product.price]; //商品价格
    order.notifyURL =  @"http://www.xxx.com"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showURL = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"xuyuanAlipay";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
//
//    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode

    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    //NSString *signedString = [signer signString:orderSpec];
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }
}
//点击头像执行跳转
-(void)exbutton:(UIButton *)button{
    NSUInteger index = button.tag;
    NSDictionary *dic = _array[index];
    CEDetailsViewController *detailView = [Utilities getStoryboardInstanceByIdentity:@"Consulting" byIdentity:@"EDetails"];
    detailView.expertId = dic[@"expertId"];
    detailView.tags = 1;
    [self.navigationController pushViewController:detailView animated:YES];
  
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
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
    
    [[StorageMgr singletonStorageMgr]addKey:@"back" andValue:@"1"];
    [self presentViewController:[Utilities getStoryboardInstanceByIdentity:@"TabBar" byIdentity:@"TabBar"] animated:NO completion:nil];
    
}
@end
