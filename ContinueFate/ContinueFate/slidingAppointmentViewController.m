//
//  slidingAppointmentViewController.m
//  ContinueFate
//
//  Created by 刘金发 on 16/4/19.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "slidingAppointmentViewController.h"

@interface slidingAppointmentViewController ()

@end

@implementation slidingAppointmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self appointmentview];
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

- (IBAction)SegmentAction:(id)sender {
}
- (IBAction)SegmentAction:(UISegmentedControl *)sender forEvent:(UIEvent *)event {
}
@end
