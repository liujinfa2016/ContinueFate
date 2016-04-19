//
//  QAskViewController.h
//  ContinueFate
//
//  Created by hua on 16/4/19.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QAskViewController : UIViewController
@property (nonatomic, copy) NSArray *viewControllers;
@property (nonatomic, copy) NSArray *titles;

/** 指示视图的颜色 */
@property (nonatomic, strong) UIColor *indicatorViewColor;
/** segment的背景颜色 */
@property (nonatomic, strong) UIColor *segmentBgColor;
/**
 *  segment每一项的文字颜色
 */
@property (nonatomic, strong) UIColor *titleColor;
/** segment每一项的宽 */
@property (nonatomic, assign) CGFloat itemWidth;
/** segment每一项的高 */
@property (nonatomic, assign) CGFloat itemHeight;

@end
