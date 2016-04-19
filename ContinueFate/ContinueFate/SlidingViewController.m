//
//  SlidingViewController.m
//  ContinueFate
//
//  Created by 刘金发 on 16/4/17.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "SlidingViewController.h"
#import "SlidingTableViewCell.h"
#import <MobileCoreServices/MobileCoreServices.h>
@interface SlidingViewController ()
@property(strong,nonatomic) NSArray *dict;
@property(strong,nonatomic) NSArray *imageBrr;
@property(strong,nonatomic)UIImagePickerController *imagePc;
@end

@implementation SlidingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self According];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//设置tableviewCell里面的图片和文字
-(void)According{
    UIImage *image1 =[UIImage imageNamed:@"预约咨询"];
    UIImage *image2 =[UIImage imageNamed:@"预约咨询"];
    UIImage *image3 =[UIImage imageNamed:@"预约咨询"];
    UIImage *image4 =[UIImage imageNamed:@"预约咨询"];
    UIImage *image5 =[UIImage imageNamed:@"预约咨询"];
    UIImage *image6 =[UIImage imageNamed:@"预约咨询"];
    _imageBrr =@[image1,image2,image3,image4,image5,image6];
    _dict = @[@"预约管理",@"我的问答",@"我的收藏",@"我的投稿",@"专家入驻",@"建议反馈" ];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dict.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView  cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SlidingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.Lable.text=_dict[indexPath.row];
    cell.image.image =_imageBrr[indexPath.row];
    return cell;
}
//当选择完媒体文件后调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //根据UIImagePickerControllerEditedImage这个键去拿我们选中的已经编辑的图片
    UIImage *image =info [UIImagePickerControllerEditedImage];
    //将上面拿到的图片设置为按钮的图片
    [_imageLable setBackgroundImage:image forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//当取消选择后调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    // 用model的方式返回上一页
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)PhotoAction:(UIButton *)sender forEvent:(UIEvent *)event {
    //提示框
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
    [self presentViewController:actionShent animated:YES completion:nil];
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

- (IBAction)SetUpAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
