//
//  SimplePickerView.m
//  PickerView
//
//  Created by George on 16/1/18.
//  Copyright © 2016年 George. All rights reserved.
//

#import "SimplePickerView.h"

@interface SimplePickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSMutableArray *arr;
}
@end

@implementation SimplePickerView
@synthesize selectBlock, dataArray, pickerView;

-(instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismisSimplePickerView)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
    
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_H, SCREEN_W, PVH)];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [self addSubview:self.pickerView];
    
    [self performSelector:@selector(showSimplePickerView) withObject:nil afterDelay:0.1];
    
    arr = [NSMutableArray array];
    
    return self;
}

-(instancetype)initWithDataArray:(NSArray<NSArray *> *)array {
    
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismisSimplePickerView)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
    
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_H, SCREEN_W, PVH)];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [self addSubview:self.pickerView];
    
    [self performSelector:@selector(showSimplePickerView) withObject:nil afterDelay:0.1];
    
    arr = [NSMutableArray array];
    self.dataArray = array;
    
    return self;
}




-(void)dismisSimplePickerView {
    [UIView animateWithDuration:0.2 animations:^{
        self.pickerView.frame = CGRectMake(0, SCREEN_H, SCREEN_W, PVH);
        self.alpha = 0.2;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)showSimplePickerView {
    self.pickerView.frame = CGRectMake(0, SCREEN_H, SCREEN_W, PVH);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.alpha = 0.2;
    self.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.4];
    [UIView animateWithDuration:0.2 animations:^{
        self.pickerView.frame = CGRectMake(0, SCREEN_H - PVH, SCREEN_W, PVH);
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}
-(void)didFinishSelected:(SimpleSelect)select {
    if (select) {
        selectBlock = select;
    }
}

-(void)setDataArray:(NSArray<NSArray *> *)Array {
    
    if (Array != nil) {
        for (id var in Array) {
            if ([var isKindOfClass:[NSArray class]]) {
                dataArray = Array;
            }
            else {
                dataArray = nil;
            }
        }
    }
    
    
    if (dataArray != nil) {
        for (int i = 0; i < dataArray.count; i++) {
            [arr addObject:@""];
        }
    }
    
}

#pragma mark- 设置数据
//一共多少列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.dataArray.count;
}

//每列对应多少行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //1.获取当前的列
    NSArray *arayM= self.dataArray[component];
    //2.返回当前列对应的行数
    return arayM.count;
}

//每列每行对应显示的数据是什么
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //1.获取当前的列
    NSArray *arayM= self.dataArray[component];
    //2.获取当前列对应的行的数据
    NSString *name=arayM[row];
    return name;
}

#pragma mark-设置下方的数据刷新
// 当选中了pickerView的某一行的时候调用
// 会将选中的列号和行号作为参数传入
// 只有通过手指选中某一行的时候才会调用
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //获取对应列，对应行的数据
    //NSString *name=self.dataArray[component][row];
    [arr replaceObjectAtIndex:component withObject:self.dataArray[component][row]];
    //赋值
    if (self.selectBlock) {
        self.selectBlock(arr);
    }
}

@end







