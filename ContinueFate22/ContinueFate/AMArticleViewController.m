//
//  AMArticleViewController.m
//  ContinueFate
//
//  Created by admin2015 on 16/4/19.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "AMArticleViewController.h"
#import "HMSegmentedControl.h"
#import "ArticleObject.h"
#import "AMACellTableViewCell.h"
@interface AMArticleViewController () <UITableViewDataSource,UITableViewDelegate> {
    NSInteger page;
    NSInteger perPage;
}
@property (strong ,nonatomic)NSMutableArray *objArr;

@end

@implementation AMArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    page = 1;
    perPage = 4;
    _objArr = [NSMutableArray new];
    
    
    
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"One", @"Two", @"Three", @"Four", @"Five", @"Six", @"Seven", @"Eight"]];
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    segmentedControl.frame = CGRectMake(0, 0, viewWidth, 40);
    segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.verticalDividerEnabled = YES;
    segmentedControl.verticalDividerColor = [UIColor redColor];
    segmentedControl.verticalDividerWidth = 1.0f;
    segmentedControl.backgroundColor = [UIColor redColor];
    [segmentedControl setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor blueColor]}];
        return attString;
    }];
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    [self requestData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void)requestData {
    NSDictionary *parameters = @{@"type":@"",@"subtype":@"",@"page":@(page),@"perPage":@(perPage)};
    
    NSString *url = @"http://192.168.61.154:8080/XY_Project/servlet/showArticle";
    //  UIActivityIndicatorView *avi = [Utilities getCoverOnView:self.view];
    
    [[AppAPIClient sharedClient] GET: url parameters:parameters progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        //[avi stopAnimating];
        if ([responseObject[@"resultFlag"]integerValue] == 8001) {
            NSDictionary *result = responseObject[@"result"];
            NSArray *dataArr = result[@"models"];
            //NSDictionary *pageDict = result[@"paginginfo"];
            
            if (page == 1){
                _objArr = nil;
                _objArr = [NSMutableArray new];
                
                perPage = 4;
            }
            for  (NSDictionary *art in dataArr) {
                ArticleObject *artObj = [[ArticleObject alloc]initWithDictionary:art];
                
                [_objArr addObject:artObj];
                
                NSLog(@"_objectForShow = %@",_objArr);
            }
            
            [_tableView reloadData];
        }else {
            [Utilities popUpAlertViewWithMsg:@"亲 ，请保持网络畅通" andTitle:nil onView:self];
        }
        
        
    } failure: ^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"%@",error.description);
    }];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // NSLog(@"_objectForShow = %lu",(unsigned long)_objectForShow.count);
    return _objArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AMACellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
     ArticleObject *artObj = _objArr[indexPath.row];
    NSLog(@"hwwhdiufvhdw = %@",artObj);
    NSString * titlename = artObj.titlename;
    NSString * substance = artObj.substance;
    cell.titleName.text = titlename;
    cell.substance.text = substance;
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
