//
//  Utilities.m
//  Utility
//
//  Created by ZIYAO YANG on 15/8/20.
//  Copyright (c) 2015年 Zhong Rui. All rights reserved.
//

#import "Utilities.h"


@implementation Utilities

+ (id)getUserDefaults:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)setUserDefaults:(NSString *)key content:(id)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeUserDefaults:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)uniqueVendor
{
    NSString *uniqueIdentifier = [Utilities getUserDefaults:@"kKeyVendor"];
    if (!uniqueIdentifier || uniqueIdentifier.length == 0) {
        NSUUID *uuid = [[UIDevice currentDevice] identifierForVendor];
        uniqueIdentifier = [uuid UUIDString];
        [Utilities setUserDefaults:@"kKeyVendor" content:uniqueIdentifier];
    }
    return uniqueIdentifier;
}

+ (id)getStoryboardInstanceByIdentity:(NSString*)identity
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    return [storyboard instantiateViewControllerWithIdentifier:identity];
}
+ (id)getStoryboardInstanceByIdentity:(NSString * )storyboard byIdentity:(NSString *) identity{

    UIStoryboard* std = [UIStoryboard storyboardWithName:storyboard bundle:[NSBundle mainBundle]];
    return [std instantiateViewControllerWithIdentifier:identity];

}
+ (void)popUpAlertViewWithMsg:(NSString *)msg andTitle:(NSString* )title onView:(UIViewController *)vc
{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:title == nil ? @"提示" : title message:msg == nil ? @"操作失败" : msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil];
    [alertView addAction:cancelAction];
    [vc presentViewController:alertView animated:YES completion:nil];
}

+ (void)popUpAlertViewWithMsg:(NSString *)msg andTitle:(NSString *)title onView:(UIViewController *)vc tureAction:(void(^ __nullable)(UIAlertAction * _Nonnull action))action{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:title == nil ? @"提示" : title message:msg == nil ? @"操作失败" : msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:action];
    UIAlertAction *falseAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertView addAction:trueAction];
    [alertView addAction:falseAction];
    [vc presentViewController:alertView animated:YES completion:nil];
}
+ (void)popUpAlertViewWithTrue:(NSString *)msg andTitle:(NSString *)title onView:(UIViewController *)vc tureAction:(void(^ __nullable)(UIAlertAction * _Nonnull action))action{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:title == nil ? @"提示" : title message:msg == nil ? @"操作失败" : msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:action];
    
    [alertView addAction:trueAction];
    
    [vc presentViewController:alertView animated:YES completion:nil];
}
+ (UIActivityIndicatorView *)getCoverOnView:(UIView *)view
{
    UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    aiv.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.4];
    aiv.frame = view.bounds;
    [view addSubview:aiv];
    [aiv startAnimating];
    return aiv;
}

+ (NSString *)notRounding:(float)price afterPoint:(int)position
{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

+ (UIImage *)imageUrl:(NSString *)url {
    if ([url isKindOfClass:[NSNull class]] || url == nil) {
        return nil;
    }
    static dispatch_queue_t backgroundQueue;
    if (backgroundQueue == nil) {
        backgroundQueue = dispatch_queue_create("com.beilyton.queue", NULL);
    }
    
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [directories objectAtIndex:0];
    __block NSString *filePath = nil;
    filePath = [documentDirectory stringByAppendingPathComponent:[url lastPathComponent]];
    UIImage *imageInFile = [UIImage imageWithContentsOfFile:filePath];
    if (imageInFile) {
        return imageInFile;
    }
    
    __block NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    if (!data) {
        NSLog(@"Error retrieving %@", url);
        return nil;
    }
    UIImage *imageDownloaded = [[UIImage alloc] initWithData:data];
    dispatch_async(backgroundQueue, ^(void) {
        [data writeToFile:filePath atomically:YES];
        //NSLog(@"Wrote to: %@", filePath);
    });
    return imageDownloaded;
}


+ (NSAttributedString *)grayString:(NSString *)string fontName:(NSString *)fontName fontSize:(CGFloat)size
{
    UIFont *font;
    if (fontName) {
        font = [UIFont fontWithName:fontName size:size];
    } else {
        font = [UIFont systemFontOfSize:size];
    }
    
    UIColor *grayColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    NSAttributedString *grayString = [[NSAttributedString alloc] initWithString:string
                                                                     attributes:@{NSFontAttributeName:font,
                                                                                  NSForegroundColorAttributeName:grayColor}];
    
    return grayString;
}

#pragma mark - 时间间隔显示
+ (NSString *)intervalSinceNow:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *compsPast = [calendar components:unitFlags fromDate:date];
    NSDateComponents *compsNow = [calendar components:unitFlags fromDate:[NSDate date]];
    
    NSInteger years = [compsNow year] - [compsPast year];
    NSInteger months = [compsNow month] - [compsPast month] + years * 12;
    NSInteger days = [compsNow day] - [compsPast day] + months * 30;
    NSInteger hours = [compsNow hour] - [compsPast hour] + days * 24;
    NSInteger minutes = [compsNow minute] - [compsPast minute] + hours * 60;
    
    if (minutes < 1) {
        return @"刚刚";
    } else if (minutes < 60) {
        return [NSString stringWithFormat:@"%ld 分钟前", (long)minutes];
    } else if (hours < 24) {
        return [NSString stringWithFormat:@"%ld 小时前", (long)hours];
    } else if (hours < 48 && days == 1) {
        return @"昨天";
    } else if (days < 30) {
        return [NSString stringWithFormat:@"%ld 天前", (long)days];
    } else if (days < 60) {
        return @"一个月前";
    } else if (months < 12) {
        return [NSString stringWithFormat:@"%ld 个月前", (long)months];
    } else {
        NSArray *arr = [dateStr componentsSeparatedByString:@"T"];
        return [arr objectAtIndex:0];
    }
}

+ (NSAttributedString *)getIntervalAttrStr:(NSString *)dateStr
{
    NSAttributedString *intervalAttrStr = [self grayString:[self intervalSinceNow:dateStr] fontName:nil fontSize:12];
    
    return intervalAttrStr;
}

+ (NSDictionary *)getImageURL:(NSString *)aricle {
    NSRange rangeFirst = [aricle rangeOfString:@"&"];
    NSString *sub = [aricle substringFromIndex:rangeFirst.location+1];
    NSRange rangeLast = [sub rangeOfString:@"&&"];
    NSString *imageURL = [sub substringToIndex:rangeLast.location];
    NSDictionary *dic = @{@"last":sub,@"imageURL":imageURL};
    
    return dic;
}

+ (NSString *)saveHeadImage:(UIImage *)imageData {
    
    NSData *data = [[NSData alloc]init];
    if (UIImagePNGRepresentation(imageData) == nil) {
        
        data = UIImageJPEGRepresentation(imageData,0);
        
    } else {
        
        data = UIImagePNGRepresentation(imageData);
    }
    NSString *key = [NSString stringWithFormat:@"%@.jpg",[[StorageMgr singletonStorageMgr]objectForKey:@"userid"]];
    NSDictionary *parameters = @{@"bucket":@"xyproject",@"key":key};
    NSString *url = [NSString stringWithFormat:@"7xtaye.com1.z0.glb.clouddn.com/%@",key];
    [[AppAPIClient sharedClient]POST:@"http://192.168.61.85:8080/XuYuanProject/getToken" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *token = responseObject[@"Token"];
        QNUploadManager *upManager = [[QNUploadManager alloc]init];
        [upManager putData:data key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        } option:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.description);
    }];
    
    return url;
}

+ (BOOL)loginState {
    NSString *userId = [[StorageMgr singletonStorageMgr] objectForKey:@"UserID"];
    if (userId == NULL && userId.length == 0) {
        return true;
    } else {
        return false;
    }
}

+ (double)getTextHeight:(NSString *)text textFont:(UIFont *)textFont toViewRange:(int)range{
    CGSize maxSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width - range, 1000);
    CGSize contentLabelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:textFont} context:nil].size;
    return contentLabelSize.height;
}

@end
