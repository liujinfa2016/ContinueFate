//
//  QAskViewController.m
//  ContinueFate
//
//  Created by hua on 16/4/19.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "QAskViewController.h"

@interface QAskViewController ()
@property (strong,nonatomic) UILabel *titleLbl;
@property (strong,nonatomic) UILabel *substance;
@property (strong,nonatomic) UIPickerView *pickerview;

@end

@implementation QAskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _titleView.delegate = self;
    _substanceView.delegate = self;
    _titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(3, 3, 200, 20)];
    _titleLbl.enabled = NO;
    _titleLbl.text = @"请输入标题";
    _titleLbl.font = [UIFont systemFontOfSize:13];
    _titleLbl.textColor = [UIColor lightGrayColor];
    [_titleView addSubview:_titleLbl];
    
    
    _substance = [[UILabel alloc]initWithFrame:CGRectMake(3, 3, 300, 20)];
    _substance.enabled = NO;
    _substance.text = @"请详细写出您的问题和感受(不少于60个字)";
    
    _substance.font = [UIFont systemFontOfSize:13];
    _substance.textColor = [UIColor lightGrayColor];
    [_substanceView addSubview:_substance];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航条"] forBarMetrics:UIBarMetricsDefault];
    _tcBtn.layer.borderWidth=1.0;
    _tcBtn.layer.borderColor=[[UIColor whiteColor]CGColor];
    
}

- (void)textViewDidChange:(UITextView *)textView{
    
    if ([_substanceView.text length] == 0) {
        _substance.hidden = NO;
    }else{
        _substance.hidden = YES;
    }
    
    if ([_titleView.text length] == 0) {
        _titleLbl.hidden = NO;
    }else{
        _titleLbl.hidden = YES;
    }
    
}


- (void)addQuestion{
    NSString *userid = [[StorageMgr singletonStorageMgr]objectForKey:@"UserID"];
    NSLog(@"userid = %@",userid);
    NSString *typeChoose = [[StorageMgr singletonStorageMgr]objectForKey:@"type"];
    NSString *titlename = _titleView.text;
    NSString *substance = _substanceView.text;
    
    NSDictionary *parameters = @{@"titlename":titlename,@"substance":substance,@"type":typeChoose,@"userid":userid};
    [RequestAPI postURL:@"/questionAdd" withParameters:parameters success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"resultFlag"]integerValue] == 8001) {
            NSNotification *note = [NSNotification notificationWithName:@"RefreshHome" object:nil];
            [[NSNotificationCenter defaultCenter]performSelectorOnMainThread:@selector(postNotification:) withObject:note waitUntilDone:YES];
        }else{
            NSLog(@"失败");
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error.description);
    }];
}

- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveAction:(UIBarButtonItem *)sender {
    
    [self addQuestion];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createPickerView{
    NSArray *array = @[@[@"女生恋爱",@"男生恋爱",@"挽救爱情",@"拯救婚姻",@"婚姻家庭"]];
    SimplePickerView *pickerView = [[SimplePickerView alloc]initWithDataArray:array];
    [pickerView didFinishSelected:^(NSArray *selected) {
        if (selected) {
            
            NSString *select = selected[0];
            NSString *str = [NSString stringWithFormat:@"%@",select];
            [[StorageMgr singletonStorageMgr]addKey:@"type" andValue:str];
            [_tcBtn setTitle:str forState:UIControlStateNormal];
            
        }
    }];
}

- (IBAction)typeChoose:(UIButton *)sender forEvent:(UIEvent *)event {
    [sender addTarget:self action:@selector(createPickerView) forControlEvents:UIControlEventTouchUpInside];
    
}

//让textView控件实现：当键盘右下角按钮被按下后，收起键盘
//当文本输入视图中文字内容发生变化时调用（返回YES表示同意这个变化发生；返回NO表示不同意）
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(nonnull NSString *)text{
    
    //捕捉到键盘右下角按钮被按下这一事件（键盘右下角按钮被按实际上在文本输入视图中执行的是换行:\n）
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}
/*

///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = (_footview.frame.origin.y+_footview.frame.size.height) - (self.view.frame.size.height - kbHeight);
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}
*/

@end
