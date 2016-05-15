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
@interface SlidingDataViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate,UITextViewDelegate,UITextFieldDelegate>

@property (strong ,nonatomic)UIDatePicker *datepicker;
@property(strong,nonatomic)UIImagePickerController *imagePc;
@property(strong,nonatomic)NSMutableArray *menuList;
@end

@implementation SlidingDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"请填写资料";


    _ageTF.delegate = self;
    _textView.delegate = self;
    _SCView.delegate = self;
    _SCView.contentSize  = CGSizeMake(UI_SCREEN_W,0);
    _SCView.showsHorizontalScrollIndicator = NO;
    
    //_scrollView.contentOffset=CGPointMake(0, 0);
    _tapTrick.enabled = NO;
    _tapTrick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bgTap:)];
    
    [self.view addGestureRecognizer:_tapTrick];
    //监听键盘打开这一操作，打开后执行keyboardWillShow:方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //监听键盘收起这一操作，收起后执行keyboardWillHide:方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航条"] forBarMetrics:UIBarMetricsDefault];
    
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
@end
