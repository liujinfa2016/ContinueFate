//
//  TabBarViewController.m
//  ContinueFate
//
//  Created by 刘金发 on 16/4/17.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "TabBarViewController.h"
#import "XZMTabbarExtension.h"
#import "FirstViewController.h"
#import "ArticleViewController.h"
#import "QuestionViewController.h"
#import "ConsultingViewController.h"

@interface TabBarViewController ()<XZMTabbarExtensionDelegate>
@property (nonatomic, strong)NSMutableArray *itemArray;
@end

@implementation TabBarViewController

- (NSMutableArray *)itemArray
{
    if (_itemArray == nil) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    FirstViewController *home = [Utilities getStoryboardInstanceByIdentity:@"Main" byIdentity:@"Home"];
    [self tabBarChildViewController:home norImage:[UIImage imageNamed:@"tabBar_0"] selImage:[UIImage imageNamed:@"tabBar_0_on"]];
    ArticleViewController *article = [Utilities getStoryboardInstanceByIdentity:@"Article" byIdentity:@"Article"];
    [self tabBarChildViewController:article norImage:[UIImage imageNamed:@"tabBar_1"] selImage:[UIImage imageNamed:@"tabBar_1_on"]];
    QuestionViewController *question = [Utilities getStoryboardInstanceByIdentity:@"Question" byIdentity:@"Question"];
    [self tabBarChildViewController:question norImage:[UIImage imageNamed:@"tabBar_2"] selImage:[UIImage imageNamed:@"tabBar_2_on"]];
    ConsultingViewController *consulting = [Utilities getStoryboardInstanceByIdentity:@"Consulting" byIdentity:@"Consulting"];
    [self tabBarChildViewController:consulting norImage:[UIImage imageNamed:@"tabBar_3"] selImage:[UIImage imageNamed:@"tabBar_3_on"]];
    [self setTatBar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/** View激将显示时 */
- (void)viewWillAppear:(BOOL)animated
{   [super viewWillAppear:animated];
    for (UIView *childView in self.tabBar.subviews) {
        if (![childView isKindOfClass:[XZMTabbarExtension class]]) {
            [childView removeFromSuperview];
        }
    }
}

- (void)setTatBar
{
    /** 创建自定义tabbar */
    XZMTabbarExtension *tabBar = [[XZMTabbarExtension alloc] init];
    tabBar.backgroundColor = [UIColor whiteColor];
    tabBar.frame = self.tabBar.bounds;
    /** 传递模型数组 */
    tabBar.items = self.itemArray;
    //    [tabBar xzm_setShadeItemBackgroundColor:[UIColor redColor]];
    /** 设置代理 */
    tabBar.delegate = self;
    
    [self.tabBar addSubview:tabBar];
}

- (void)tabBarChildViewController:(UIViewController *)vc norImage:(UIImage *)norImage selImage:(UIImage *)selImage
{
    /** 创建导航控制器 */
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    /** 创建模型 */
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] init];
    tabBarItem.image = norImage;
    tabBarItem.selectedImage = selImage;
    /** 添加到模型数组 */
    [self.itemArray addObject:tabBarItem];
    [self addChildViewController:nav];
}

/** 代理方法 */
- (void)xzm_tabBar:(XZMTabbarExtension *)tabBar didSelectItem:(NSInteger)index{
    self.selectedIndex = index;
}

@end

