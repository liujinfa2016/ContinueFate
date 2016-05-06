//
//  slidingAppointmentViewController.m
//  ContinueFate
//
//  Created by 刘金发 on 16/4/19.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "slidingAppointmentViewController.h"
#import "SlidingAppointmentTableViewCell.h"

@interface slidingAppointmentViewController ()

@end

@implementation slidingAppointmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self appointmentview];
    _segment.selectedSegmentIndex = 0;
    [self Request];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)appointmentview{
   

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)Request{
    NSString *userid =[[StorageMgr singletonStorageMgr] objectForKey:@"UserID"];
    NSDictionary *dic =@{@"userid":userid,@"typeid":@1};
    [RequestAPI postURL:@"/getOrderList" withParameters:dic success:^(id responseObject) {
        NSLog(@"000000000000 = %@",responseObject);
        NSLog(@"111112====%@",userid);
    } failure:^(NSError *error) {
        NSLog(@"111111====%@",error.description);
         NSLog(@"111112====%@",userid);
    }];

}

- (IBAction)SegmentAction:(UISegmentedControl *)sender forEvent:(UIEvent *)event {
   
    switch (_segment.selectedSegmentIndex) {
        case 0:
            NSLog(@"00000");
         
            break;
        case 1:
            NSLog(@"11111");
            break;
        case 2:
            NSLog(@"22222");
            break;
        case 3:
            NSLog(@"33333");
            break;
            
        default:
            break;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    return cell;
    
}
// 返回
- (IBAction)ReturnAction:(UIBarButtonItem *)sender {
   
   [self.navigationController dismissViewControllerAnimated:YES completion:nil];

}
@end
