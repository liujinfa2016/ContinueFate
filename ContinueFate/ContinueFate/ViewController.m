//
//  ViewController.m
//  ContinueFate
//
//  Created by 刘金发 on 16/4/16.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD+NJ.h"
#import "HomeTabViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化一个bool格式的单例化全局标量来表示是否成功执行了注册  默认为否
    [[StorageMgr singletonStorageMgr] addKey:@"SignUpSuccessfully" andValue:@NO];
    //显示加载
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    //加载完成
    [MBProgressHUD hideHUDForView:self.view];



}

-(void)popUpHome{
     HomeTabViewController*tabVc =[Utilities  getStoryboardInstanceByIdentity:@"Main" byIdentity:@"HomeTab"];
    
    [self presentViewController:tabVc animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![[Utilities getUserDefaults:@"Username"] isKindOfClass:[NSNull class]]) {
        //如果有记忆就把记忆显示在用户名文本输入框中
        _usernameTF.text = [Utilities getUserDefaults:@"Username"];
    }
    
}


//每次这个页面出现的时候都会调用这个方法，并且时机点是页面已然出现以后
-(void)viewDidAppear:(BOOL)animated{
    
//    [super viewDidAppear:animated];
//    if ([[[StorageMgr singletonStorageMgr] objectForKey:@"SignUpSuccessfully"] boolValue]) {
//        //先将SignUpSuccessfully这个单例化全局变量中的folg删除以保证
//        [[StorageMgr singletonStorageMgr] removeObjectForKey:@"SignUpSuccessfully"];
//        //初始化一个bool格式的单例化全局标量来表示是否成功执行了注册  默认为否
//        [[StorageMgr singletonStorageMgr] addKey:@"SignUpSuccessfully" andValue:@NO];
//        //在单例化全局变量中提取用户名和密码
//        NSString *username =[[StorageMgr singletonStorageMgr] objectForKey:@"Username"];
//        
//        NSString *password =[[StorageMgr singletonStorageMgr] objectForKey:@"Password"];
//        
//        //清除用完的用户名和密码
//        [[StorageMgr singletonStorageMgr] removeObjectForKey:@"Username"];
//        [[StorageMgr singletonStorageMgr] removeObjectForKey:@"Password"];
        //执行自动登录
//        [self signInWithUsername:username addpassword:password];
//    }
    
}
- (IBAction)loginAction:(id)sender forEvent:(UIEvent *)event {
    NSString *username = _usernameTF.text;
    NSString *password = _passwordTF.text;
    if (username.length == 0 || password.length == 0) {
        [Utilities popUpAlertViewWithMsg:@"请填写所有信息" andTitle:nil onView:self];
        return;
    }
//    [self signInWithUsername:username addpassword:password];
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
