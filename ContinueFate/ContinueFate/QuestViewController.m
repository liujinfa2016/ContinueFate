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
#import "QuestionObject.h"
#import <UIImageView+WebCache.h>
@interface QuestViewController (){
    NSInteger page;
    NSInteger perpage;

}
@property (strong,nonatomic)NSMutableArray *objectsForShow;

@end

@implementation QuestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self dataDataTransfer];
    _objectsForShow = [NSMutableArray new];
    _tableView.tableFooterView = [[UIView alloc]init];
    page = 1;
    perpage = 5;
    [self requestData];
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
    NSURL *URL = [NSURL URLWithString:_detail.userHeadImage];
    [_userImage sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"初始头像"]];
    
    _username.text = [NSString stringWithFormat:@"%@",_detail.userNickname];
    
    NSString *date = [_detail.time substringToIndex:19];
    NSAttributedString *inputDate = [Utilities getIntervalAttrStr:date];
    _timeLbl.attributedText = inputDate;
    
    _titlename.text = [NSString stringWithFormat:@"%@",_detail.titlename];
    
    _substance.text = [NSString stringWithFormat:@"%@", _detail.substance];
    
    _typeLbl.text = [NSString stringWithFormat:@"%@", _detail.type];
    
}


- (void)requestData{
    NSDictionary *parameters = @{@"questionid":_detail.Id,@"usertype":@1};
    [[AppAPIClient sharedClient]POST:@"http://192.168.61.85:8080/XuYuanProject/answerList" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"resultFlag"]integerValue] == 8001) {
            NSDictionary *dict = responseObject[@"result"];
            NSArray *data = dict[@"models"];
            if (page == 1) {
                _objectsForShow = nil;
                _objectsForShow = [NSMutableArray new];
            }

            for(NSDictionary *question in data){
                QuestionObject *quest = [[QuestionObject alloc]initWithDictionary:question];
                [_objectsForShow addObject:quest];
                NSLog(@"obj = %@",_objectsForShow);
            }
            [_tableView reloadData];
        }else{
            [Utilities popUpAlertViewWithMsg:@"服务器连接失败，请稍候重试" andTitle:nil onView:self];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
        [Utilities popUpAlertViewWithMsg:@"服务器连接失败，请稍候重试" andTitle:nil onView:self];

    }];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
   ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%lu",(unsigned long)_objectsForShow.count);
    return  _objectsForShow.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    QuestionObject *question = [_objectsForShow objectAtIndex:indexPath.row];
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    CGSize maxSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width - 30, 1000);
    CGSize substanceSize = [question.time boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:cell.substance.font} context:nil].size;
    return cell.substance.frame.origin.y + substanceSize.height + 16;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    QuestionObject *obj = _objectsForShow[indexPath.row];
    NSLog(@"question = %@",obj);
    NSString *substance = obj.substance;
    NSString *date = [obj.time substringToIndex:19];
    NSAttributedString *inputDate = [Utilities getIntervalAttrStr:date];
    NSString *name = obj.userNickname;
    cell.expertName.text = name;
    cell.substance.text = substance;
    cell.time.attributedText = inputDate;
    
    return cell;
}

@end
