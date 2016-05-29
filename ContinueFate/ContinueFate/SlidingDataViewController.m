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
#import <SDWebImage/UIImageView+WebCache.h>
@interface SlidingDataViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate,UITextViewDelegate,UITextFieldDelegate>

@property (strong ,nonatomic)UIDatePicker *datepicker;
@property(strong,nonatomic)UIImagePickerController *imagePc;
@property(strong,nonatomic)NSMutableArray *menuList;
@property(strong,nonatomic)NSMutableArray *array;//声明一个可变数组
@property(strong,nonatomic)NSDictionary *dic;//声明一个字典

@end

@implementation SlidingDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"请填写资料";
    _neckName.enabled = NO;
    _nameTF.enabled = NO;
    _ageTF.enabled = NO;
    _telTF.enabled = NO;
    _textView.editable = NO;
    
    _image.enabled = NO;
    _regionTF.enabled = NO;
    _sexTF.enabled = NO;
    _modifytv.hidden = YES;

    _ageTF.delegate = self;
    _textView.delegate = self;
    _SCView.delegate = self;
    _SCView.contentSize  = CGSizeMake(UI_SCREEN_W,0);
    _SCView.showsHorizontalScrollIndicator = NO;
    
    //_scrollView.contentOffset=CGPointMake(0, 0);
    _tapTrick.enabled = NO;
    _tapTrick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bgTap:)];
    _array=[NSMutableArray new];
    [self.view addGestureRecognizer:_tapTrick];
    //监听键盘打开这一操作，打开后执行keyboardWillShow:方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //监听键盘收起这一操作，收起后执行keyboardWillHide:方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航条"] forBarMetrics:UIBarMetricsDefault];
    [self Request];
    
}
-(void)Request{
    [_array removeAllObjects];
   NSString *userID =[[StorageMgr singletonStorageMgr]objectForKey:@"UserID"];
    NSLog(@"userID = %@",userID);
    NSDictionary *ditarr = @{@"userid":userID};
    [RequestAPI postURL:@"/getPersonal" withParameters:ditarr success:^(id responseObject) {
         NSLog(@"%@",responseObject);
        NSLog(@"fhdshfhashdfahdfafad");
         if ([responseObject[@"resultFlag"]integerValue] == 8001){
             NSDictionary *dic = responseObject[@"result"];
                     NSArray *arr = dic[@"models"];
                     for (NSDictionary *dic in arr) {
             
                         _neckName.text = [NSString stringWithFormat:@"%@",dic[@"nickname"]];
                         _nameTF.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
                         _telTF.text = [NSString stringWithFormat:@"%@",dic[@"mobile"]];
                         _sexTF.text = [NSString stringWithFormat:@"%@",dic[@"sex"]];
                         _textView.text = [NSString stringWithFormat:@"%@",dic[@"descripition"]];
                         
    NSURL *URL = [NSURL URLWithString:dic[@"headimage"]];
    [_image.imageView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"专家入驻"]];

                         
                         if ([_ageTF.text isEqualToString:@""] || [_regionTF.text isEqualToString:@""]) {
                             _ageTF.text = @"";
                             _regionTF.text = @"";
                         }else{
                             _ageTF.text = [NSString stringWithFormat:@"%@",dic[@"birthday"]];
                             _regionTF.text = [NSString stringWithFormat:@"%@",dic[@"address"]];

                         }
                }

         }else{
             NSLog(@"f123");
         }
           } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
        [Utilities popUpAlertViewWithMsg:@"数据请求失败，请保持网络畅通" andTitle:nil onView:self];
    }];
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
    NSString *userid =[[StorageMgr singletonStorageMgr]objectForKey:@"UserID"];
    NSLog(@"userid =  %@",userid);
    


_dic=@{@"userid":userid,@"nickname":_neckName.text,@"name":_nameTF.text,@"sex":_sexTF.text,@"headimage":_image,@"birthday":_ageTF.text,@"mobile":_telTF.text,@"address":_regionTF.text,@"email":@0,@"descripition":_textView.text};
    //菊花
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    self.navigationController.view.self.userInteractionEnabled = NO;
    [RequestAPI postURL:@"/userModification" withParameters:_dic success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        self.navigationController.view.self.userInteractionEnabled = YES;
        [Utilities popUpAlertViewWithMsg:@"修改成功" andTitle:nil onView:self];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        self.navigationController.view.self.userInteractionEnabled = YES;
        [Utilities popUpAlertViewWithMsg:@"修改失败，请检查你的网络" andTitle:nil onView:self];
        NSLog(@"error = %@",error.description);
    }];
   [self Request];
    self.navigationItem.rightBarButtonItem.enabled =YES;
}
//修改
- (IBAction)modifyEiet:(UIBarButtonItem *)sender {
    _neckName.enabled = YES;
    _nameTF.enabled = YES;
    _ageTF.enabled = YES;
    _telTF.enabled = YES;
    _textView.editable = YES;
    _image.enabled = YES;
    _regionTF.enabled = YES;
    _sexTF.enabled = YES;
    _modifytv.hidden = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
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
