//
//  QuestViewController.m
//  ContinueFate
//
//  Created by hua on 16/4/17.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "QuestViewController.h"
#import "DetailTableViewCell.h"
@interface QuestViewController ()
@property (strong,nonatomic)NSMutableArray *objectsForShow;

@end

@implementation QuestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%lu",(unsigned long)_objectsForShow.count);
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     DetailTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
