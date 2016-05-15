//
//  Utilities.h
//  Utility
//
//  Created by ZIYAO YANG on 15/8/20.
//  Copyright (c) 2015年 Ziyao Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QiniuSDK.h>

@interface Utilities : NSObject

/**
 *根据key获取缓存userDefault
 */
+ (id)getUserDefaults:(NSString *)key;
/**
 *根据key设置userDefault
 */
+ (void)setUserDefaults:(NSString *)key content:(id)value;
/**
 *根据key删除缓存userDefault
 */
+ (void)removeUserDefaults:(NSString *)key;
/**
 *根据key获取数据缓存KeyedArchiver
 */
+ (id)getKeyedArchiver:(NSString *)key;
/**
 *根据key设置KeyedArchiver
 */
+ (void)setKeyedArchiver:(NSString *)key content:(id)value;
/**
 *获得venderID的UUID字符串
 */
+ (NSString *)uniqueVendor;
/**
 *根据id获取控制器实例
 */
+ (id)getStoryboardInstanceByIdentity:(NSString*)storyboard byIdentity:(NSString*)identity;
/**
 *弹出普通提示框
 */
+ (void)popUpAlertViewWithMsg:(NSString *)msg andTitle:(NSString * )title onView:(UIViewController *)vc;
/**
 *获得保护膜
 */
+ (UIActivityIndicatorView *)getCoverOnView:(UIView *)view;
/**
 *将浮点数转化为保留小数点后若干位数的字符串
 */
+ (NSString *)notRounding:(float)price afterPoint:(int)position;
/**
 *根据URL下载图片并缓存
 */
+ (UIImage *)imageUrl:(NSString *)url;

+ (NSString *)intervalSinceNow:(NSString *)dateStr;
+ (NSAttributedString *)getIntervalAttrStr:(NSString *)dateStr;
+ (NSAttributedString *)grayString:(NSString *)string fontName:(NSString *)fontName fontSize:(CGFloat)size;

/**
 *截取文章图片
 */
+ (NSURL *)getImageURL:(NSString *)aricle;

/**
 *带有选择按钮的提示框
 */
+ (void)popUpAlertViewWithMsg:(NSString *)msg andTitle:(NSString *)title onView:(UIViewController *)vc tureAction:(void(^ __nullable)(UIAlertAction * action))action;

/**
 *带有选择按钮的提示框/执行取消操作
 */
+ (void)popUpAlertViewWithMsg:(NSString *)msg andTitle:(NSString *)title onView:(UIViewController *)vc trueStr:(NSString *)trueStr falseStr:(NSString *)falseStr tureAction:(void(^ __nullable)(UIAlertAction * _Nonnull action))action flaseAction:(void(^ __nullable)(UIAlertAction * _Nonnull action))flaseAction;

/**
 *只有确定的提示框
 */
+ (void)popUpAlertViewWithTrue:(NSString *_Nonnull)msg andTitle:(NSString *_Nonnull)title onView:(UIViewController *_Nonnull)vc tureAction:(void(^ __nullable)(UIAlertAction * _Nonnull action))action;
/**
 *自动存储图片至服务器
 */
+ (NSString *)saveHeadImage:(UIImage *)imageData;
/**
 *判断当前是否已经登录
 */
+ (BOOL)loginState;

/**
 *获取textView中文字高度
 */
+ (double)getTextHeight:(NSString *)text textFont:(NSFont *)textFont toViewRange:(int)range;

@end
