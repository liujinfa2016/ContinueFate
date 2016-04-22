//
//  onePasswordResetViewController.m
//  ContinueFate
//
//  Created by demon on 16/4/22.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "onePasswordResetViewController.h"

@interface onePasswordResetViewController ()

@end

@implementation onePasswordResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)testGetCodeAction:(UIButton *)sender forEvent:(UIEvent *)event {
    NSString *telTF = _telTF.text;
    if (telTF.length != 11 ) {
        [Utilities popUpAlertViewWithMsg:@"请输入11位手机号" andTitle:nil onView:self];
        return;
    }

}

- (IBAction)nextAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
//隐藏键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}
@end
