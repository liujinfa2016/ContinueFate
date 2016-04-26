//
//  SimplePickerView.h
//  PickerView
//
//  Created by George on 16/1/18.
//  Copyright © 2016年 George. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height
#define PVH (SCREEN_H*0.35>230 ? 230:(SCREEN_H*0.35<200 ? 200:SCREEN_H*0.35))

typedef void(^SimpleSelect)(NSArray *selected);

@interface SimplePickerView : UIView


@property(nonatomic, strong)NSArray<NSArray *> *dataArray;

@property(nonatomic, strong)SimpleSelect selectBlock;

@property(nonatomic, strong)UIPickerView *pickerView;



-(instancetype)init;

-(instancetype)initWithDataArray:(NSArray<NSArray *> *)array;

-(void)didFinishSelected:(SimpleSelect)select;

@end
