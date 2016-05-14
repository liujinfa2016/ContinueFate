//
//  Constants.h
//  Zhong Rui
//
//  Created by Ziyao on 15/9/8.
//  Copyright (c) 2015年 Ziyao. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

//字体
#define S_Font 27
#define A_Font 17
#define B_Font 15
#define C_Font 13
#define D_Font 11

//颜色函数
#define UIColorFromRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define UIColorFromRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/1.0]
#define UIColorMajor [UIColor colorWithRed:0.0f/255.0f green:199.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
#define UIColorBackground [UIColor colorWithRed:240.0f/255.0f green:248.0f/255.0f blue:254.0f/255.0f alpha:1.0f];


//屏幕尺寸
#define UI_SCREEN_W [[UIScreen mainScreen] bounds].size.width
#define UI_SCREEN_H [[UIScreen mainScreen] bounds].size.height

//iOS版本
#define Earlier_Than_IOS_8 ([[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue] < 8.0)
#define Later_Than_IOS_8 ([[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >= 8.0)

//清理内存
#define FRelease(x) {[x removeFromSuperview]; x = nil;}

//关联登录
#define QQ_APPID @"222222"

#endif
