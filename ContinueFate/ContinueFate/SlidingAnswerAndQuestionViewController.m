//
//  SlidingAnswerAndQuestionViewController.m
//  ContinueFate
//
//  Created by demon on 16/5/15.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "SlidingAnswerAndQuestionViewController.h"
#import "SlidingangerTableViewCell.h"
#import <SDAutoLayout/UITableView+SDAutoTableViewCellHeight.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
@interface SlidingAnswerAndQuestionViewController (){
    BOOL flag;
}


@end

@implementation SlidingAnswerAndQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    flag = true;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航条"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}
//当没有预约信息，执行的方法
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    if (flag) {
        NSString *text = @"您暂时没有预约信息";
        
        NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        paragraph.alignment = NSTextAlignmentCenter;
        
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0f],
                                     NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                     NSParagraphStyleAttributeName: paragraph};
        
        return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    } else {
        return nil;
    }
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
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//SlidingangerTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SlidingangerTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
//    if (cell == nil) {
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SlidingangerTableViewCell" owner:self options:nil];
//        for (id oneObject in nib) {
//            if ([oneObject isKindOfClass:[SlidingangerTableViewCell class]]) {
//                cell = (SlidingangerTableViewCell *)oneObject;
//            }
//        }
//    }
    return cell;
}

- (IBAction)backAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//segement控件事件
- (IBAction)segmentAction:(UISegmentedControl *)sender forEvent:(UIEvent *)event {
    switch (_Segment.selectedSegmentIndex) {
            
        case 0:
            NSLog(@"000000");
            break;
        case 1:
            NSLog(@"111111");
            break;
            
    }

}
@end
