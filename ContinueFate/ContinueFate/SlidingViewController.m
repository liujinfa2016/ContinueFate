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



@interface SlidingViewController ()
@property(strong,nonatomic) NSArray *dict;
@property(strong,nonatomic) NSArray *imageBrr;



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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            if ([Utilities loginState]) {
                [Utilities popUpAlertViewWithMsg:@"您当前还未登录，请问您是否要登录！" andTitle:nil onView:self tureAction:^(UIAlertAction *action) {
                    UIViewController *loginVc =[Utilities  getStoryboardInstanceByIdentity:@"Main" byIdentity:@"Login"];
                    [self presentViewController:loginVc animated:YES completion:nil];
                }];
            } else {
                [self presentViewController:[Utilities getStoryboardInstanceByIdentity:@"Sliding" byIdentity:@"Appointment"] animated:YES completion:nil];
            }
            break;
         case 1:
            if ([Utilities loginState]) {
                [Utilities popUpAlertViewWithMsg:@"您当前还未登录，请问您是否要登录！" andTitle:nil onView:self tureAction:^(UIAlertAction *action) {
                    UIViewController *loginVc =[Utilities  getStoryboardInstanceByIdentity:@"Main" byIdentity:@"Login"];
                    [self presentViewController:loginVc animated:YES completion:nil];
                }];
            } else {
                [self presentViewController:[Utilities getStoryboardInstanceByIdentity:@"Sliding" byIdentity:@"Appointment"] animated:YES completion:nil];
            }
            break;
        case 2:
            if ([Utilities loginState]) {
                [Utilities popUpAlertViewWithMsg:@"您当前还未登录，请问您是否要登录！" andTitle:nil onView:self tureAction:^(UIAlertAction *action) {
                    UIViewController *loginVc =[Utilities  getStoryboardInstanceByIdentity:@"Main" byIdentity:@"Login"];
                    [self presentViewController:loginVc animated:YES completion:nil];
                }];
            } else {
                [self presentViewController:[Utilities getStoryboardInstanceByIdentity:@"Sliding" byIdentity:@"Collection"] animated:YES completion:nil];
            }
            break;
        case 3:
            if ([Utilities loginState]) {
                [Utilities popUpAlertViewWithMsg:@"您当前还未登录，请问您是否要登录！" andTitle:nil onView:self tureAction:^(UIAlertAction *action) {
                    UIViewController *loginVc =[Utilities  getStoryboardInstanceByIdentity:@"Main" byIdentity:@"Login"];
                    [self presentViewController:loginVc animated:YES completion:nil];
                }];
            } else {
                [self presentViewController:[Utilities getStoryboardInstanceByIdentity:@"Sliding" byIdentity:@"Contribute"] animated:YES completion:nil];
            }
            break;
        case 4:
            [self presentViewController:[Utilities getStoryboardInstanceByIdentity:@"Sliding" byIdentity:@"ExpertsJoin"] animated:YES completion:nil];
            break;
        case 5:
            [self presentViewController:[Utilities getStoryboardInstanceByIdentity:@"Sliding" byIdentity:@"Appointment"] animated:YES completion:nil];
            break;
        default:
            break;
    }
    
}

- (IBAction)PhotoAction:(UIButton *)sender forEvent:(UIEvent *)event {
//    [self :subView animated:YES];
    NSString *userid = [[StorageMgr singletonStorageMgr] objectForKey:@"UserID"];
    //提示框
    if (userid == nil && userid.length == 0) {
        
        UIViewController *tabVc =[Utilities  getStoryboardInstanceByIdentity:@"Main" byIdentity:@"Login"];
       
        [self presentViewController:tabVc animated:YES completion:nil];
        
    }else{
        
        [self presentViewController:[Utilities getStoryboardInstanceByIdentity:@"Sliding" byIdentity:@"Data"] animated:YES completion:nil];
      
    }
    
 }





@end
