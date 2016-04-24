//
//  ArticleDetailViewController.h
//  ContinueFate
//
//  Created by jdld on 16/4/24.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleDetailViewController : UIViewController
@property(strong, nonatomic) NSString *articleId;
@property(strong, nonatomic) NSString *titleName;
@property(strong, nonatomic) NSString *subStance;
@property(strong, nonatomic) NSString *time;
@property(strong, nonatomic) NSString *hits;
@end
