//
//  ArticleViewController.m
//  ContinueFate
//
//  Created by px on 16/4/17.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "ArticleViewController.h"
#import "JRSegmentControl.h"
#import "AMArticleViewController.h"
#import "AMSuccessAViewController.h"
@interface ArticleViewController () <UIScrollViewDelegate, JRSegmentControlDelegate> {
    CGFloat vcWidth;  // 每个子视图控制器的视图的宽
    CGFloat vcHeight; // 每个子视图控制器的视图的高
    
    JRSegmentControl *segment;
    
    BOOL _isDrag;
}
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AMArticleViewController *firstVC = [Utilities getStoryboardInstanceByIdentity:@"Article" byIdentity:@"SuccessA"];
    AMSuccessAViewController *secondVC = [Utilities getStoryboardInstanceByIdentity:@"Article" byIdentity:@"AMArticle"];
    
    _viewControllers = @[secondVC,firstVC];
    _titles = @[@"文章", @"成功案例"];
 
    [self setupScrollView];
    [self setupViewControllers];
    [self setupSegmentControl];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航条"] forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGFloat)itemWidth
{
    if (_itemWidth == 0) {
        _itemWidth = 64.0f;
    }
    return _itemWidth;
}

- (CGFloat)itemHeight
{
    if (_itemHeight == 0) {
        _itemHeight = 30.0f;
    }
    return _itemHeight;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

/** 设置scrollView */
- (void)setupScrollView
{
    CGFloat Y = 0.0f;
    if (self.navigationController != nil && ![self.navigationController isNavigationBarHidden]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        Y = 60.0f;
    }
    
    vcWidth = self.view.frame.size.width;
    vcHeight = self.view.frame.size.height - Y;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, Y, vcWidth, vcHeight)];
    scrollView.contentSize = CGSizeMake(vcWidth * self.viewControllers.count, vcHeight);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator   = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate      = self;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}

/** 设置子视图控制器，这个方法必须在viewDidLoad方法里执行，否则子视图控制器各项属性为空 */
- (void)setupViewControllers
{
    int cnt = (int)self.viewControllers.count;
    for (int i = 0; i < cnt; i++) {
        UIViewController *vc = self.viewControllers[i];
        [self addChildViewController:vc];
        
        vc.view.frame = CGRectMake(vcWidth * i, 0, vcWidth, vcHeight);
        [self.scrollView addSubview:vc.view];
    }
}

/** 设置segment */
- (void)setupSegmentControl
{
    _itemWidth = 55.0f;
    // 设置titleView
    segment = [[JRSegmentControl alloc] initWithFrame:CGRectMake(0, 0, _itemWidth * 3, 30.0f)];
    segment.titles = self.titles;
    segment.cornerRadius = 5.0f;
    //导航条标题字体颜色
    segment.titleColor = UIColorBackground;
    
    
    
    
    //导航条标题选中颜色
    segment.indicatorViewColor = UIColorBackground;
    //导航条标题未选中颜色
    segment.backgroundColor = [UIColor whiteColor];
    
    //设置导航条标题边框
    segment.layer.borderColor = [[UIColor whiteColor] CGColor];
    segment.layer.borderWidth=2.0;
    segment.layer.opacity = 1.0;
    
    
    segment.delegate = self;
    self.navigationItem.titleView = segment;
    
    
   

    
    
    /* _imageLable.layer.shadowColor = [UIColor colorWithRed:234.0f/255.0f green:67.0f/255.0f blue:112.0f/255.0f alpha:1.0f].CGColor;//shadowColor阴影颜色
     _imageLable.layer.shadowOffset = CGSizeMake(-2,-2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
     _imageLable.layer.shadowOpacity = 0.8;//阴影透明度，默认0
     _imageLable.layer.shadowRadius = 3;//阴影半径，默认3
     
     
     _imageLable.layer.shadowColor = [UIColor blueColor].CGColor;//shadowColor阴影颜色
     _imageLable.layer.shadowOffset = CGSizeMake(0,-3);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
     _imageLable.layer.shadowOpacity = 1;//阴影透明度，默认0
     _imageLable.layer.shadowRadius = 3;//阴影半径，默认3
     _imageLable.layer.masksToBounds = NO;
     */
    
    
    
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [segment selectedBegan];
    _isDrag = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_isDrag) {
        CGFloat percent = scrollView.contentOffset.x / scrollView.contentSize.width;
        
        [segment setIndicatorViewPercent:percent];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate == NO) {
        [segment selectedEnd];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    [segment setSelectedIndex:index];
    _isDrag = NO;
}

#pragma mark - JRSegmentControlDelegate

- (void)segmentControl:(JRSegmentControl *)segment didSelectedIndex:(NSInteger)index {
    CGFloat X = index * self.view.frame.size.width;
    [self.scrollView setContentOffset:CGPointMake(X, 0) animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
