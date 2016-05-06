//
//  CFillInformationViewController.m
//  ContinueFate
//
//  Created by admin2015 on 16/4/23.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "CFillInformationViewController.h"
#import "SimplePickerView.h"
#import "CAgreementViewController.h"
#import "slidingAppointmentViewController.h"
@interface CFillInformationViewController () <UITextViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate> {
    //统计
    NSInteger statistical;
    BOOL flag;
    // 例子需要的變數
    UIDatePicker *datePicker;
    
    NSLocale *datelocale;
    NSInteger page;
    NSInteger perPage;
    NSInteger totalPage;

}
@property (strong ,nonatomic)UIDatePicker *datepicker;
@property (strong ,nonatomic)NSArray *arr;
@property (strong ,nonatomic)UIPickerView *grenderView;
@end

@implementation CFillInformationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"请填写资料";
    _ordertimeTF.delegate = self;
    _CellTF.delegate = self;
    _PhoneNum.delegate = self;
    _AgeTF.delegate = self;
    _DescribeTV.delegate = self;
    _grenderTF.delegate = self;
    _arr = [NSArray arrayWithObjects:@"男",@"女", nil];
    NSLog(@"_getOrderState = %@ ,_objectForShow = %@,_expertsM = %@",_getOrderState,_objectForShow,_expertsM);
    //将统计字数设为0
    statistical = 0;
    [self requestData];
    [self creatDate];
    [self grenderTFC];
}
- (void) grenderTFC {
    _grenderView = [[UIPickerView alloc] init];
    _grenderView.dataSource = self;
    _grenderView.delegate = self;
    _grenderTF.inputView = _grenderView;
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    // 选取日期完成钮并给他一個 selector
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(textFieldDidEndEditing:)];
    right.width = 80;
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    fixedSpace.width = self.view.frame.size.width - 80;
    // 把按钮加进 UIToolbar
    toolBar.items = [NSArray arrayWithObjects:fixedSpace,right,nil];
    
    
    // 以下這行也是重點 (螢光筆畫兩行)
    // 原本應該是鍵盤上方附帶內容的區塊 改成一個 UIToolbar 並加上完成鈕
    _grenderTF.inputAccessoryView = toolBar;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) requestData {
    NSString *userId = [[StorageMgr singletonStorageMgr] objectForKey:@"UserID"];
    //POST请求数据
    NSDictionary *pararmeters = @{@"userid":userId};
    [RequestAPI postURL:@"/getPersonal" withParameters:pararmeters success:^(id responseObject) {
        if ([responseObject[@"resultFlag"]integerValue] == 8001) {
            
            NSDictionary *result = responseObject[@"result"];
            NSArray *models = result[@"models"];
            for (NSDictionary *dict in models) {
                _CellTF.text = dict[@"nickname"];
                _grenderTF.text = [NSString stringWithFormat:@"%@",dict[@"sex"]];
                _PhoneNum.text = dict[@"mobile"];
                _AgeTF.text = dict[@"birthday"];
            }
            
        }else {
            NSLog(@"shibai");
        }
        
        //请求失败执行以下方法
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error.description);
        [MBProgressHUD showError:@"网络不给力，请稍后再试！" toView:self.view];
        [MBProgressHUD hideHUDForView:self.view];
        self.navigationController.view.self.userInteractionEnabled = YES;
    }];
}
- (void)creatDate {
    // 建立 UIDatePicker
    _datepicker = [[UIDatePicker alloc]init];
    // 時區的問題請再找其他協助 不是本篇重點
    datelocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
    _datepicker.locale = datelocale;
    _datepicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    _datepicker.datePickerMode = UIDatePickerModeDate;
    _ordertimeTF.inputView = _datepicker;
    // 建立 UIToolbar
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    // 选取日期完成钮并给他一個 selector
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    fixedSpace.width = self.view.frame.size.width - 80;

   
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(ordertimeActionDatePick)];
    
   // UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(ordertimeActionDatePick)];
    right.width = 80;
    // 把按钮加进 UIToolbar
    toolBar.items = [NSArray arrayWithObjects:fixedSpace,right,nil];
    // 以下這行也是重點 (螢光筆畫兩行)
    // 原本應該是鍵盤上方附帶內容的區塊 改成一個 UIToolbar 並加上完成鈕
    _ordertimeTF.inputAccessoryView = toolBar;
    
}
-(void)ordertimeActionDatePick {
    
    // endEditing: 是結束編輯狀態的 method
    if ([self.view endEditing:NO]) {
        //获取当前选择的年月日；
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //设置年月日的格式
        NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"yyyy-MM-dd" options:0 locale:datelocale];
        //formatter为有格式的年月日
        [formatter setDateFormat:dateFormat];
        //封装本地化相关的各种信息
        [formatter setLocale:datelocale];
        //NSString *chooseTimeS = [NSString stringWithFormat:@"%@",[formatter stringFromDate:_datepicker.date]];
        NSString *chooseTimeS = [formatter stringFromDate: _datepicker.date];
        NSString *strTime = [chooseTimeS stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
        
        NSDate *choosetimeD = [formatter dateFromString:chooseTimeS];
        NSTimeInterval chooseTime = [choosetimeD timeIntervalSince1970]*1000;
        
        //获取系统的年月日
        NSDateFormatter *sysFormatter =[[NSDateFormatter alloc] init];
        [sysFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *sysDateTimeS = [sysFormatter stringFromDate:[NSDate date]];
        
        NSDate *sysDateTimeD = [sysFormatter dateFromString:sysDateTimeS];
        NSTimeInterval sysDateTime = [sysDateTimeD timeIntervalSince1970]*1000;
        
        if (chooseTime <= sysDateTime) {
            [Utilities popUpAlertViewWithMsg:@"时间过期" andTitle:nil onView:self];
            return;
        }else {
            _ordertimeTF.text = strTime;
        }
        
    }
}

//实现Placeholder属性执行以下方法（用label实现Placeholder，当textView输入内容时隐藏label）
- (void)textViewDidChange:(UITextView *)textView
{
        if (_DescribeTV.text.length==0){
            //textview长度为0
            if ([textView isKindOfClass:nil]) {
                //判断是否为删除键
                _PlaceholderLab.hidden=NO;
                //隐藏文字
            }else{
                _PlaceholderLab.hidden=YES;
            }
        }else{//textview长度不为0
            if (_DescribeTV.text.length==1){
                //textview长度为1时候
                if ([textView isKindOfClass:nil]) {
                    //判断是否为删除键
                    _PlaceholderLab.hidden=NO;
                }else{
                    //不是删除
                    _PlaceholderLab.hidden=YES;
                }
            }else{
                //长度不为1时候
                _PlaceholderLab.hidden=YES;
            }
        }
    //剩余字数
    statistical = 300 - textView.text.length;
    [_LimitWN setText:[NSString stringWithFormat:@"(%ld/300}", (long)statistical]];  //_wordCount是一个显示剩余可输入数字的label
}

//如果输入超过规定的字数100，就不再让输入
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location >= 300)
    {
        [Utilities popUpAlertViewWithMsg:@"您已输入的字数据已达上限" andTitle:nil onView:self];
        return  NO;
    }
    else
    {
        return YES;
    }
}
//创建随机订单号（不确保唯一性）
- (NSString *)generateTradeNO {
    
    NSMutableString *resultStr = [[NSMutableString alloc]init];
    //订单号为15位数
    static int kNO = 15;
    //设置订单号中每一个字符的随机范围；
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    for (int i = 0 ; i < kNO ; i++) {
        
        //获取一个随机整数来表示从上述订单号随机范围字符串中截取第几个字符，该随机整数的获取范围应该从字符串的index0开始一直到字符串最后一个字符的index结束(0~35)
        NSInteger index = arc4random() % sourceStr.length;
        //
        //    NSString *oneStr = [sourceStr substringToIndex: index];
        //    NSString *twoStr = [oneStr substringFromIndex:oneStr.length - 1];
        
        //获取index位置所在的单个字符串的NSRange（范围：在字符串中所在位置和长度）值
        NSRange range = NSMakeRange(index, 1);
        //根据上述NSRange值去截取该单个字符
        NSString *oneStr = [sourceStr substringWithRange:range];
        //在一个可变字符串的结尾续接一个字符串
        [resultStr appendString:oneStr];
        
    }
    
    
    return resultStr;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)CompleteAction:(UIButton *)sender forEvent:(UIEvent *)event {
    //称呼
    NSString *cell = _CellTF.text;
    //年龄
    NSString *age = _AgeTF.text;
    //手机号
    NSString *phoneNum = _PhoneNum.text;
    //描述的问题
    NSString *Describe = _DescribeTV.text;
     //订单号
    NSString *tradeNO = [self generateTradeNO];
    //获取当前用户ID
   NSString *userId = [[StorageMgr singletonStorageMgr] objectForKey:@"UserID"];
    
    NSLog(@"userId == %@",userId);
    // 预约时间
    NSString *ordertime = _ordertimeTF.text;
    
    //性别
    NSString *grender = _grenderTF.text;
    //预约状态
    NSString *orderStateid = [NSString stringWithFormat:@"%@",_getOrderState[@"id"]];
    //获取所选咨询类型
    NSString *orderTypeid = [NSString stringWithFormat:@"%@",_objectForShow[@"id"]];
    
    //判断是否填写完整信息
    if ([grender isKindOfClass:nil] || [cell isEqualToString:@""] ||[age isEqualToString:@""] ||[phoneNum isEqualToString:@""] || [Describe isEqualToString:@""]) {
        [Utilities popUpAlertViewWithMsg:@"请填写完整信息" andTitle:nil onView:self];
    }
    if (flag == NO) {
        [Utilities popUpAlertViewWithMsg:@"亲，您需要同意我们的协议才能更好为您服务哦" andTitle:nil onView:self];
        return;
    }
    //确认信息
    NSString *str = [[NSString alloc]initWithFormat:@"您的称呼：%@\n您的年龄：%@\n您的性别：%@\n您的联系电话：%@\n您预约的时间：%@" ,cell ,age ,grender ,phoneNum,ordertime] ;
    //初始化提示框；
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认基本信息" message:str preferredStyle:  UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSDictionary *parameters = @{@"userid":userId,@"expertid":_expertsM[@"id"],@"orderTypeid":orderTypeid,@"number":tradeNO,@"ordertime":ordertime,@"orderStateid":orderStateid,@"remark":Describe};
        
        //菊花
        [MBProgressHUD showMessage:@"正在加载" toView:self.view];
        //导航条不可用
        self.navigationController.view.self.userInteractionEnabled = NO;
        [RequestAPI postURL:@"/orderAppend" withParameters:parameters success:^(id responseObject) {
            //停止
            [MBProgressHUD hideHUDForView:self.view];
            //恢复导航条可用
            self.navigationController.view.self.userInteractionEnabled = YES;
            if ([responseObject[@"resultFlag"]integerValue] == 8001) {
                NSLog(@"success !!");
                [self saveData];
       
            }else {
                NSLog(@"error !");
            }

        } failure:^(NSError *error) {
            NSLog(@"errorA = %@",error.description);
            [MBProgressHUD showError:@"网络不给力，请稍后再试！" toView:self.view];
            [MBProgressHUD hideHUDForView:self.view];
            self.navigationController.view.self.userInteractionEnabled = NO;
        }];
        slidingAppointmentViewController *toAppointment = [Utilities getStoryboardInstanceByIdentity:@"Sliding" byIdentity:@"Appointment"];
        
        [self presentViewController:toAppointment animated:YES completion:nil];

        NSLog(@"在这里存数据");
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        return ;
    }]];

    //弹出提示框；  CLHSearchBar
    [self presentViewController:alert animated:true completion:nil];


}
- (void) saveData {
    //称呼
    NSString *cell = _CellTF.text;
    //年龄
    NSString *age = _AgeTF.text;
    //手机号
    NSString *phoneNum = _PhoneNum.text;
    //性别
    NSString *grender = _grenderTF.text;

      //获取当前用户ID
      NSString *userId = [[StorageMgr singletonStorageMgr] objectForKey:@"UserID"];
       NSLog(@"userId === %@",userId);
       //POST请求数据
       NSDictionary *pararmeters = @{@"userid":userId,@"cell":cell,@"age":age,@"mobile":phoneNum,@"sex":grender};
        [RequestAPI postURL:@"/userModification" withParameters:pararmeters success:^(id responseObject) {
        if ([responseObject[@"resultFlag"]integerValue] ==8001) {
            NSLog(@"responseObject  =========%@",responseObject);

        }

    } failure:^(NSError *error) {
        NSLog(@"error = %@",error.description);
        [MBProgressHUD showError:@"网络不给力，请稍后再试！" toView:self.view];
        [MBProgressHUD hideHUDForView:self.view];
        self.navigationController.view.self.userInteractionEnabled = YES;

    }];
}

- (IBAction)AgreementFileAction:(UIButton *)sender forEvent:(UIEvent *)event {
  
    CAgreementViewController *data = [Utilities getStoryboardInstanceByIdentity:@"Consulting" byIdentity:@"Agreement"];
   
    [self.navigationController pushViewController:data animated:YES];
    
}

- (IBAction)AgreenmentAction:(UIButton *)sender forEvent:(UIEvent *)event {
  
    [sender setImage:[UIImage imageNamed:@"offA"] forState:UIControlStateNormal];
    if (flag == YES) {
        [sender setImage:[UIImage imageNamed:@"onA"] forState:UIControlStateNormal];
        
        flag = NO;
    }else {
         [sender setImage:[UIImage imageNamed:@"offA"] forState:UIControlStateSelected];
        flag = YES;
    }

}
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _arr.count;
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED {
    return _arr[row];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ([self.view endEditing:NO]) {
        NSInteger row = [_grenderView selectedRowInComponent:0];
        _grenderTF.text = [_arr objectAtIndex:row];
    }
    
}

@end
