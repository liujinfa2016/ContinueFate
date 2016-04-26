//
//  SlidingViewController.m
//  ContinueFate
//
//  Created by 刘金发 on 16/4/17.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "SlidingViewController.h"
#import "SlidingTableViewCell.h"
#import "slidingAppointmentViewController.h"
#import "SlidingAppointmentTableViewCell.h"
#import <MobileCoreServices/MobileCoreServices.h>


@interface SlidingViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(strong,nonatomic) NSArray *dict;
@property(strong,nonatomic) NSArray *imageBrr;
@property(strong,nonatomic)UIImagePickerController *imagePc;
@property(strong,nonatomic)NSMutableArray *menuList;


@end

@implementation SlidingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self According];
    [self setImageButtonStyle];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *name = [[StorageMgr singletonStorageMgr] objectForKey:@"Nickname"];
    _nameLbl.text = name;
    NSLog(@"username%@",name);
    
}

-(void)setImageButtonStyle{
    
   
    _imageLable.layer.borderColor = [[UIColor colorWithRed:234.0f/255.0f green:67.0f/255.0f blue:112.0f/255.0f alpha:0.5f] CGColor];
    
     _imageLable.layer.opacity = 1.0;
    
    /* _imageLable.layer.shadowColor = [UIColor colorWithRed:234.0f/255.0f green:67.0f/255.0f blue:112.0f/255.0f alpha:1.0f].CGColor;//shadowColor阴影颜色
     _imageLable.layer.shadowOffset = CGSizeMake(-2,-2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
     _imageLable.layer.shadowOpacity = 0.8;//阴影透明度，默认0
     _imageLable.layer.shadowRadius = 3;//阴影半径，默认3
    
    
    _imageLable.layer.shadowColor = [UIColor blueColor].CGColor;//shadowColor阴影颜色
    _imageLable.layer.shadowOffset = CGSizeMake(0,-3);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    _imageLable.layer.shadowOpacity = 1;//阴影透明度，默认0
    _imageLable.layer.shadowRadius = 3;//阴影半径，默认3
    _imageLable.layer.masksToBounds = NO;
    */
    
   
    
    
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//设置tableviewCell里面的图片和文字


-(void)According{
    
    UIImage *image1 =[UIImage imageNamed:@"预约管理"];
    UIImage *image2 =[UIImage imageNamed:@"我的问答"];
    UIImage *image3 =[UIImage imageNamed:@"我的收藏"];
    UIImage *image4 =[UIImage imageNamed:@"我的投稿"];
    UIImage *image5 =[UIImage imageNamed:@"专家入驻"];
    UIImage *image6 =[UIImage imageNamed:@"意见反馈"];
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    UIViewController * TV0 = [Utilities getStoryboardInstanceByIdentity:@"Sliding" byIdentity:@"Appointment"];
    UITableViewController * TV1 = [Utilities getStoryboardInstanceByIdentity:@"Sliding" byIdentity:@"Appointment"];
    UIViewController * TV2 = [Utilities getStoryboardInstanceByIdentity:@"Sliding" byIdentity:@"Collection"];
    UITableViewController * TV3 = [Utilities getStoryboardInstanceByIdentity:@"Sliding" byIdentity:@"Contribute"];
    UITableViewController * TV4 = [Utilities getStoryboardInstanceByIdentity:@"Sliding" byIdentity:@"ExpertsJoin"];
    UITableViewController * TV5 = [Utilities getStoryboardInstanceByIdentity:@"Sliding" byIdentity:@"Appointment"];
    switch (indexPath.row) {
        case 0:
            [self.navigationController presentViewController:TV0 animated:YES completion:nil];
            NSLog(@"%ld",(long)indexPath.row);
            break;
         case 1:[self.navigationController pushViewController:TV1 animated:YES];
            break;
        case 2:[self.navigationController pushViewController:TV2 animated:YES];
            break;
        case 3:[self.navigationController pushViewController:TV3 animated:YES];
            break;
        case 4:[self.navigationController pushViewController:TV4 animated:YES];
            break;
        case 5:[self.navigationController pushViewController:TV5 animated:YES];
            break;
        default:
            break;
    }
    
    
    
//    if(indexPath.row==0)
//    {
//        slidingAppointmentViewController *sdf = [Utilities getStoryboardInstanceByIdentity:@"Sliding" byIdentity:@"Appointment"];
//        
//        [self presentViewController:sdf animated:YES completion:nil];
//        
//    }else if(indexPath.row==2)
//    {
//        
//        
//    }
    
}
//当选择完媒体文件后调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
  
    
    //根据UIImagePickerControllerEditedImage这个键去拿我们选中的已经编辑的图片
    UIImage *image =info [UIImagePickerControllerEditedImage];
    //将上面拿到的图片设置为按钮的图片
    [_imageLable setBackgroundImage:image forState:UIControlStateNormal];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    _imageLable.layer.masksToBounds = YES;
}
//当取消选择后调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    // 用model的方式返回上一页
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)PhotoAction:(UIButton *)sender forEvent:(UIEvent *)event {
//    [self :subView animated:YES];
    NSString *userid = [[StorageMgr singletonStorageMgr] objectForKey:@"UserID"];
    NSLog(@"id = %@",userid);
    //提示框
    if (userid == Nil) {
        
        UIViewController*tabVc =[Utilities  getStoryboardInstanceByIdentity:@"Main" byIdentity:@"Login"];
       
        [self presentViewController:tabVc animated:YES completion:nil];
    }else{
        
        
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


@end
