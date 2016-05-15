//
//  ViewController.m
//  ContinueFate
//
//  Created by 刘金发 on 16/4/16.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD+NJ.h"
#import "TabBarViewController.h"
#import "RegisterViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>

@interface ViewController () <TencentSessionDelegate>  {
    NSString *nickname;
    NSString *address;
    NSString *headImage;
    NSString *gender;
}

@property (strong ,nonatomic) TencentOAuth *tencentOA;
@property (strong ,nonatomic) NSArray *permissions ;
@property (strong ,nonatomic)NSString *accessToken;
@property (strong ,nonatomic)NSString *openId;
@property (strong ,nonatomic)NSDate *expirationDate;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航条"] forBarMetrics:UIBarMetricsDefault];
    //初始化一个bool格式的单例化全局标量来表示是否成功执行了注册  默认为否
    [[StorageMgr singletonStorageMgr] addKey:@"SignUpSuccessfully" andValue:@NO];
//    //显示加载
//    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
//    //加载完成
//    [MBProgressHUD hideHUDForView:self.view];
    NSDictionary *parameters = @{@"deviceId":[Utilities uniqueVendor],@"deviceType":@"9001"};
    [RequestAPI postURL:@"/getKey" withParameters:parameters success:^(id responseObject) {
        NSString *modulus = responseObject[@"modulus"];
        NSString *exponent = responseObject[@"exponent"];
        [[StorageMgr singletonStorageMgr] addKey:@"modulus" andValue:modulus];
        [[StorageMgr singletonStorageMgr] addKey:@"exponent" andValue:exponent];
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error.description);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//登录
- (IBAction)loginAction:(id)sender forEvent:(UIEvent *)event {
    NSString *username = _usernameTF.text;
    NSString *password = _passwordTF.text;
    if (username.length == 0 || password.length == 0) {
        [Utilities popUpAlertViewWithMsg:@"请填写所有信息" andTitle:nil onView:self];
        return;
        
    }
    [self loginWithUsername:username addpassword:password];
}

//记忆用户名
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (![[Utilities getUserDefaults:@"Username"] isKindOfClass:[NSNull class]]) {
        //如果有记忆就把记忆显示在用户名文本输入框中
        _usernameTF.text = [Utilities getUserDefaults:@"Username"];
    }
    
}
//每次这个页面出现的时候都会调用这个方法，并且时机点是页面已然出现以后
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    if ([[[StorageMgr singletonStorageMgr] objectForKey:@"SignUpSuccessfully"] boolValue]) {
        //先将SignUpSuccessfully这个单例化全局变量中的folg删除以保证
        [[StorageMgr singletonStorageMgr] removeObjectForKey:@"SignUpSuccessfully"];
        //初始化一个bool格式的单例化全局标量来表示是否成功执行了注册  默认为否
        [[StorageMgr singletonStorageMgr] addKey:@"SignUpSuccessfully" andValue:@NO];
        //在单例化全局变量中提取用户名和密码
        NSString *username =[[StorageMgr singletonStorageMgr] objectForKey:@"Username"];
        NSString *password =[[StorageMgr singletonStorageMgr] objectForKey:@"Password"];
        
        //清除用完的用户名和密码
        [[StorageMgr singletonStorageMgr] removeObjectForKey:@"Username"];
        [[StorageMgr singletonStorageMgr] removeObjectForKey:@"Password"];
        //执行自动登录
        [self loginWithUsername:username addpassword:password];
    }
    
}
-(void)loginWithUsername:(NSString *)username addpassword:(NSString *)password {
    //菊花
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    self.navigationController.view.self.userInteractionEnabled = NO;
    NSString *modulus = [[StorageMgr singletonStorageMgr] objectForKey:@"modulus"];
    NSString *exponent = [[StorageMgr singletonStorageMgr] objectForKey:@"exponent"];
    if (modulus == NULL || modulus.length == 0 || exponent == NULL || exponent.length == 0) {
        [MBProgressHUD showMessage:@"您当前的网络状态不稳定，请稍后再试！" toView:self.view];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        return ;
    }
    password = [NSString encryptWithPublicKeyFromModulusAndExponent:[password getMD5_32BitString].UTF8String modulus:modulus exponent:exponent];
    NSDictionary *parameters = @{@"code":username,@"pwd":password,@"loginType":@1,@"deviceId":[Utilities uniqueVendor]};
    [RequestAPI postURL:@"/login" withParameters:parameters success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        self.navigationController.view.self.userInteractionEnabled = YES;
        if ([responseObject[@"resultFlag"]integerValue] == 8001) {
            NSDictionary *dic = responseObject[@"result"];
            NSArray *Arr =dic[@"models"];
            NSDictionary *models = Arr[0] ;
            
            
            [[StorageMgr singletonStorageMgr] addKey:@"UserID" andValue:models[@"id"]];
            [[StorageMgr singletonStorageMgr] addKey:@"UserType" andValue:models[@"usertype"]];
          
            [[StorageMgr singletonStorageMgr] addKey:@"Nickname" andValue:models[@"nickname"]];
                //记忆用户名
            [Utilities setUserDefaults:@"Username" content:username];
                //将文本框的内容清除
                _passwordTF.text = @"";
            [self dismissViewControllerAnimated:YES completion:nil];
        } else{
            [MBProgressHUD showError:@"用户名或密码错误" toView:self.view];
        }
    
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error.description);
        [MBProgressHUD showError:@"网络不给力，请稍后再试！" toView:self.view];
        [MBProgressHUD hideHUDForView:self.view];
        self.navigationController.view.self.userInteractionEnabled = YES;
    }];

}

//隐藏键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}
- (IBAction)ReturnAction:(UIBarButtonItem *)sender {
    //[self dismissViewControllerAnimated:YES completion:nil];
    [[StorageMgr singletonStorageMgr]addKey:@"back" andValue:@"1"];
    [self presentViewController:[Utilities getStoryboardInstanceByIdentity:@"TabBar" byIdentity:@"TabBar"] animated:NO completion:nil];
}
//**********************************************************************************************

- (IBAction)QQLoginAction:(UIButton *)sender forEvent:(UIEvent *)event {
    _tencentOA = [[TencentOAuth alloc]initWithAppId:QQ_APPID andDelegate:self];
    _tencentOA.redirectURI = @"www.qq.com";
    _permissions = [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_USER_INFO,kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,kOPEN_PERMISSION_GET_INFO,kOPEN_PERMISSION_ADD_SHARE, nil];
    [_tencentOA authorize:_permissions inSafari:NO];

}

- (void) tencentDidLogin {
    if (_tencentOA.accessToken && _tencentOA.accessToken.length  != 0) {
        
        _accessToken =  [_tencentOA accessToken];
        _openId =  [_tencentOA openId];
        _expirationDate = [_tencentOA expirationDate];
        NSLog(@"success==== %@,%@,%@", [_tencentOA accessToken], [_tencentOA openId], [_tencentOA expirationDate]);
        NSDictionary *parameters  = @{@"tokenId":_accessToken,@"openId":_openId,@"expirationDate":_expirationDate,@"platform":@"QQ"};
        
        //初始化保护膜
        //UIActivityIndicatorView *avi = [Utilities getCoverOnView:self.view];
        [MBProgressHUD showMessage:@"正在加载" toView:self.view];

        
        //将关联用户获取到的数据存到全局变量中
        [[StorageMgr singletonStorageMgr]addKey:@"tokenId" andValue:_accessToken];
        [[StorageMgr singletonStorageMgr]addKey:@"openId" andValue:_openId];
        [[StorageMgr singletonStorageMgr]addKey:@"expirationDate" andValue:_expirationDate];
        
        [_tencentOA setAccessToken:_accessToken];
        [_tencentOA setOpenId:_openId];
        [_tencentOA setExpirationDate:_expirationDate];
        [_tencentOA getUserInfo];
        
        NSLog(@"openid = %@",_openId);
        [RequestAPI postURL:@"/cognateLogin" withParameters:parameters success:^(id responseObject) {
            //停转保护膜
            // [avi stopAnimating];
            [MBProgressHUD hideHUDForView:self.view];
            NSLog(@"responseObject ===== %@",responseObject);
            //判断当前QQ号是否有账号关联
            if ([responseObject[@"resultFlag"]integerValue] == 8001){
                NSDictionary *result = responseObject[@"result"];
                NSArray *model = result[@"models"];
                NSDictionary *dit = model[0];
                //清空openId 、UserID的全局变量
                [[StorageMgr singletonStorageMgr]removeObjectForKey:@"openId"];
                [[StorageMgr singletonStorageMgr]removeObjectForKey:@"UserID"];
                
                //将openId 、UserID、nickname添加到全局变量
                [[StorageMgr singletonStorageMgr] addKey:@"UserID" andValue:dit[@"userId"]];
                [[StorageMgr singletonStorageMgr] addKey:@"UserType" andValue:dit[@"usertype"]];
                [[StorageMgr singletonStorageMgr] addKey:@"Nickname" andValue:dit[@"nickname"]];
                
                //记忆用户名
                [Utilities setUserDefaults:@"Username" content:dit[@"Username"]];
                if ([[[StorageMgr singletonStorageMgr]objectForKey:@"CED"]isEqualToString:@"2"]) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                }else {
                    TabBarViewController *tableBarVC = [Utilities getStoryboardInstanceByIdentity:@"TabBar" byIdentity:@"TabBar"];
                    [self presentViewController:tableBarVC animated:YES completion:nil];
                }
            } else {
                
                [Utilities popUpAlertViewWithMsg:@"是否已有账号" andTitle:nil onView:self trueStr:@"是" falseStr:@"否" tureAction:^(UIAlertAction * _Nonnull action) {
                    
                } flaseAction:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"meiyouzhanghao ");
                    RegisterViewController *registerVC = [Utilities getStoryboardInstanceByIdentity:@"Main" byIdentity:@"Register"];
                    [self.navigationController pushViewController:registerVC animated:YES];
                }];
                
            }
            
        } failure:^(NSError *error) {
            NSLog(@"error ====== %@",error.description);
        }];
        
    }else{
        
    }
}
//退出登录的回调
- (void)tencentDidLogout {
    NSLog(@"tencentDidLogout");
   // [Utilities popUpAlertViewWithMsg:@"" andTitle:<#(NSString *)#> onView:<#(UIViewController *)#>]
}

-(void) tencentDidNotNetWork {
    [Utilities popUpAlertViewWithMsg:@"无网络连接，请设置网络" andTitle:nil onView:self];
}
- (void) tencentDidNotLogin:(BOOL)cancelled {
    if (cancelled) {
        [Utilities popUpAlertViewWithMsg:@"用户取消登录" andTitle:nil onView:self];
    }else {
        [Utilities popUpAlertViewWithMsg:@"登录失败" andTitle:nil onView:self];
    }
}

@end
