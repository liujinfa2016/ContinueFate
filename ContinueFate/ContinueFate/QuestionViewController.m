//
//  QuestionViewController.m
//  ContinueFate
//
//  Created by px on 16/4/17.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "QuestionViewController.h"
#import "QuestionTableViewCell.h"
#import "QuestViewController.h"
#import "QAskViewController.h"
#import "ArticleObject.h"
@interface QuestionViewController (){
    NSString *tiltlename;
    NSString *detailTV;
    NSString *typeLbl;
    NSInteger page;
    NSInteger perPage;
    
    
}
@property (strong,nonatomic)NSMutableArray *objectsForShow;

@end

@implementation QuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _objectsForShow = [NSMutableArray new];
    _tableView.tableFooterView = [[UIView alloc]init];
    page = 1;
    perPage = 5;
    [self requestData];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QuestViewController *tabVC = [Utilities getStoryboardInstanceByIdentity:@"Question" byIdentity:@"questionDetail"];
    [self.navigationController pushViewController:tabVC animated:YES];
}

- (void)requestData{
    NSDictionary *parameters = @{@"type":@"",@"page":@(page),@"perPaeg":@(perPage)};
    [[AppAPIClient sharedClient]POST:@"http://192.168.61.85:8080/XuYuanProject/questionList" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"resultFlag"]integerValue] == 8001) {
            NSDictionary *dict = responseObject[@"result"];
            NSArray *data = dict[@"models"];
            if (page == 1) {
                _objectsForShow = nil;
                _objectsForShow = [NSMutableArray new];
                perPage = 5;
                
            }
            for(NSDictionary *question in data){
                ArticleObject *quest = [[ArticleObject alloc]initWithDictionary:question];
                [_objectsForShow addObject:quest];
                NSLog(@"obj = %@",_objectsForShow);
            }
            [_tableView reloadData];
        }else{
            [Utilities popUpAlertViewWithMsg:@"服务器连接失败，请稍候重试" andTitle:nil onView:self];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.description);
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%lu",(unsigned long)_objectsForShow.count);
    return _objectsForShow.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QuestionTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    ArticleObject *obj = _objectsForShow[indexPath.row];
    NSLog(@"question = %@",obj);
    NSString *titlename = obj.titlename;
    NSString *substance = obj.substance;
    NSString *date = obj.time;
    cell.timeLbl.text = date;
    cell.tiltlename.text = titlename;
    cell.substance.text = substance;
    return cell;
}


- (IBAction)chooseAction:(UIBarButtonItem *)sender {
    
}

- (IBAction)askAction:(UIBarButtonItem *)sender {
    QAskViewController *tabVC = [Utilities getStoryboardInstanceByIdentity:@"Question" byIdentity:@"firstViewController"];
    [self.navigationController pushViewController:tabVC animated:YES];
    
}


@end
