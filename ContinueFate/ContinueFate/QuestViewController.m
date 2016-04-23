//
//  QuestViewController.m
//  ContinueFate
//
//  Created by hua on 16/4/17.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "QuestViewController.h"
#import "DetailTableViewCell.h"
#import "QuestionTableViewCell.h"
@interface QuestViewController ()
@property (strong,nonatomic)NSMutableArray *objectsForShow;

@end

@implementation QuestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self dataDataTransfer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor =  [UIColor colorWithRed:244.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 100, 15)];
    label.text = @"专家回答";
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:[[UIFont familyNames] objectAtIndex:10] size:17];
    label.backgroundColor =  [UIColor colorWithRed:255.0f green:255.0f blue:255.0f alpha:0.0f];
    [headView addSubview:label];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, 20, 24)];
    label2.text = @"";
    label2.font = [UIFont fontWithName:[[UIFont familyNames] objectAtIndex:10] size:20];
    label2.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:67.0f/255.0f blue:112.0f/255.0f alpha:1.0f];
    
    [headView addSubview:label2];
    return headView;
}

- (void)dataDataTransfer{
    _username.text = [NSString stringWithFormat:@"%@",_detail.name];
    
    NSString *date = [_detail.time substringToIndex:19];
    NSAttributedString *inputDate = [Utilities getIntervalAttrStr:date];
    _timeLbl.attributedText = inputDate;
    
    _titlename.text = [NSString stringWithFormat:@"%@",_detail.titlename];
    
    _substance.text = [NSString stringWithFormat:@"%@", _detail.substance];
    
    _typeLbl.text = [NSString stringWithFormat:@"%@", _detail.type];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%lu",(unsigned long)_objectsForShow.count);
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     DetailTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    return cell;
}

@end
