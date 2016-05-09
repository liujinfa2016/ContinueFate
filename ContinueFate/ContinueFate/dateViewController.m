//
//  dateViewController.m
//  ContinueFate
//
//  Created by demon on 16/4/23.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "dateViewController.h"

@interface dateViewController ()

@end

@implementation dateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setImageButtonStyle];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航条"] forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setImageButtonStyle{
    
    
    _veiw.layer.borderColor = [[UIColor colorWithRed:234.0f/255.0f green:67.0f/255.0f blue:112.0f/255.0f alpha:0.5f] CGColor];
    
    _veiw.layer.opacity = 1.0;
    
    /* _imageLable.layer.shadowColor = [UIColor colorWithRed:234.0f/255.0f green:67.0f/255.0f blue:112.0f/255.0f alpha:1.0f].CGColor;//shadowColor阴影颜色
     _imageLable.layer.shadowOffset = CGSizeMake(-2,-2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
     _imageLable.layer.shadowOpacity = 0.8;//阴影透明度，默认0
     _imageLable.layer.shadowRadius = 3;//阴影半径，默认3
     
     
     _imageLable.layer.shadowColor = [UIColor blueColor].CGColor;//shadowColor阴影颜色
     _imageLable.layer.shadowOffset = CGSizeMake(0,-3);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
     _imageLable.layer.shadowOpacity = 1;//阴影透明度，默认0
     _imageLable.layer.shadowRadius = 3;//阴影半径，默认3
     _imageLable.layer.masksToBounds = NO;
     */
    
    
    
    
    
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
