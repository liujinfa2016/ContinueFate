//
//  SlidingViewController.m
//  ContinueFate
//
//  Created by 刘金发 on 16/4/17.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "SlidingViewController.h"
#import "SlidingTableViewCell.h"

@interface SlidingViewController ()
@property(strong,nonatomic) NSArray *dict;
@property(strong,nonatomic) NSArray *imageBrr;
@end

@implementation SlidingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image1 =[UIImage imageNamed:@"预约咨询"];
    UIImage *image2 =[UIImage imageNamed:@"预约咨询"];
    UIImage *image3 =[UIImage imageNamed:@"预约咨询"];
    UIImage *image4 =[UIImage imageNamed:@"预约咨询"];
    UIImage *image5 =[UIImage imageNamed:@"预约咨询"];
    UIImage *image6 =[UIImage imageNamed:@"预约咨询"];
    _imageBrr =@[image1,image2,image3,image4,image5,image6];
    _dict = @[@"预约管理",@"我的问答",@"我的收藏",@"我的投稿",@"专家入驻",@"建议反馈" ];
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dict.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView  cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SlidingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.Lable.text=_dict[indexPath.row];
    cell.image.image =_imageBrr[indexPath.row];
    return cell;
}
@end
