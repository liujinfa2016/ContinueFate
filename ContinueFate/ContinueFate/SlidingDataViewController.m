//
//  SlidingDataViewController.m
//  ContinueFate
//
//  Created by demon on 16/4/22.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "SlidingDataViewController.h"
#import "SimplePickerView.h"
#import <MobileCoreServices/MobileCoreServices.h>
@interface SlidingDataViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate,UITextViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate> {
    NSLocale *datelocale;
   
}

@property (strong ,nonatomic)UIDatePicker *datepicker;
@property(strong,nonatomic)UIImagePickerController *imagePc;
@property(strong,nonatomic)NSMutableArray *menuList;

@property (strong ,nonatomic)NSArray *arr;

@property (strong ,nonatomic)UIPickerView *grenderView;


@end

@implementation SlidingDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"请填写资料";


    _ageTF.delegate = self;
    _regionTF.delegate = self;
    _textView.delegate = self;
    _SCView.delegate = self;
   
    _SCView.contentSize  = CGSizeMake(UI_SCREEN_W,0);
    _SCView.showsHorizontalScrollIndicator = NO;
   _arr = [NSArray arrayWithObjects:@"男",@"女", nil];
    //_scrollView.contentOffset=CGPointMake(0, 0);
    _tapTrick.enabled = NO;
    _tapTrick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bgTap:)];
    
    [self.view addGestureRecognizer:_tapTrick];
    //监听键盘打开这一操作，打开后执行keyboardWillShow:方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //监听键盘收起这一操作，收起后执行keyboardWillHide:方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航条"] forBarMetrics:UIBarMetricsDefault];
    [self grenderTFC];
    
     [self creatDate];
    
}
- (void )bgTap: (UITapGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateRecognized) {
        [self.view endEditing:YES];
    }
}

//键盘打开时的操作
- (void)keyboardWillShow:(NSNotification *)notification{
    NSLog(@"jian pan da kai le");
    //获得键盘的位置
    _tapTrick.enabled = YES;
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"jian pan de gao du:%f",keyboardRect.size.height);
    //计算键盘出现后，为确保_scrollView的内容都能显示，它应该滚动到的y轴位置
    CGFloat newOffset = (_SCView.contentSize.height - _SCView.frame.size.height) + keyboardRect.size.height;
    //将_scrollView滚动到上述位置
    [_SCView setContentOffset:CGPointMake(0, newOffset) animated:YES];
}
//键盘收起时的操作
- (void)keyboardWillHide: (NSNotification *)notification{
    NSLog(@"jian pan guan bi le");
    //计算键盘消失后，_scrollView应该滚动回到的y轴位置
    _tapTrick.enabled = NO;
    // CGFloat newOffset = (_scrollView.contentSize.height - _scrollView.frame.size.height);
    CGFloat newOffset = -64;
    //将_scrollView滚动到上述位置
    [_SCView setContentOffset:CGPointMake(0, newOffset) animated:YES];
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//当选择完媒体文件后调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
    //根据UIImagePickerControllerEditedImage这个键去拿我们选中的已经编辑的图片
    UIImage *image =info [UIImagePickerControllerEditedImage];
    //将上面拿到的图片设置为按钮的图片
    [_image setBackgroundImage:image forState:UIControlStateNormal];
    NSString *url = [Utilities saveHeadImage:image];
    NSLog(@"url === %@",url);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    _image.layer.masksToBounds = YES;
}
//当取消选择后调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    // 用model的方式返回上一页
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//图片按钮
- (IBAction)imageAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
    UIAlertController *actionShent = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takephoto = [UIAlertAction actionWithTitle:@"照相" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pickImage:UIImagePickerControllerSourceTypeCamera];
    }];
    UIAlertAction *choosephoto = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self pickImage:UIImagePickerControllerSourceTypePhotoLibrary];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:nil];
    [actionShent addAction:takephoto];
    [actionShent addAction:choosephoto];
    [actionShent addAction:cancelAction];
    [self presentViewController:actionShent animated:YES   completion:nil];

   
}
//确定修改
- (IBAction)modifyAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
}
//修改
- (IBAction)modifyEiet:(UIBarButtonItem *)sender {
    
}
-(void)pickImage:(UIImagePickerControllerSourceType)sourceType{
    //判断图片选择类型是否可用
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        _imagePc =nil;
        //初始化一个图片选择器控制器对象
        _imagePc =[[UIImagePickerController alloc]init];
        _imagePc .delegate =self;
        //设置图片选择器控制类型
        _imagePc.sourceType = sourceType;
        //设置选中的媒体文件是否可以被编辑
        _imagePc.allowsEditing =YES;
        //设置可以选择的媒体文件的类型
        _imagePc.mediaTypes =@[(NSString *)kUTTypeImage];
        [self presentViewController:_imagePc animated:YES completion:nil];
        
    }else{
        
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:sourceType ==UIImagePickerControllerSourceTypeCamera ? @"没有相机" : @"没有相册"  preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertView addAction:confirmAction];
        [self presentViewController:alertView animated:YES completion:nil];
    }
    
}

//返回
- (IBAction)ReturnAction:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) grenderTFC {
    _grenderView = [[UIPickerView alloc] init];
    _grenderView.dataSource = self;
    _grenderView.delegate = self;
    _sexTF.inputView = _grenderView;
   
       
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
    _sexTF.inputAccessoryView = toolBar;

}


- (void)creatDate {
    // 建立 UIDatePicker
    _datepicker = [[UIDatePicker alloc]init];
    // 時區的問題請再找其他協助 不是本篇重點
    datelocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
    _datepicker.locale = datelocale;
    _datepicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    _datepicker.datePickerMode = UIDatePickerModeDate;
    _ageTF.inputView = _datepicker;
    // 建立 UIToolbar
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    // 选取日期完成钮并给他一個 selector
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action: nil];
    fixedSpace.width = self.view.frame.size.width - 80;
    
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(ordertimeActionDatePicka)];
    
    // UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(ordertimeActionDatePick)];
    right.width = 80;
    // 把按钮加进 UIToolbar
    toolBar.items = [NSArray arrayWithObjects:fixedSpace,right,nil];
    // 以下這行也是重點 (螢光筆畫兩行)
    // 原本應該是鍵盤上方附帶內容的區塊 改成一個 UIToolbar 並加上完成鈕
    _ageTF.inputAccessoryView = toolBar;
    
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
         _sexTF.text = [_arr objectAtIndex:row];
    }
}

-(void)ordertimeActionDatePicka {
    
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
        NSLog(@"%@",formatter);
        NSString *strTime = [chooseTimeS stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
        NSLog(@"%@",strTime);
        _ageTF.text = strTime;
        
    }
}




//点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//点击屏幕空白处去掉键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view resignFirstResponder];
}





@end
