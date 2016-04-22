//
//  QAskViewController.m
//  ContinueFate
//
//  Created by hua on 16/4/19.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "QAskViewController.h"
#import "QProblemViewController.h"
#import "QDetailViewController.h"
#import "JRSegmentControl.h"
@interface QAskViewController ()<UIScrollViewDelegate, JRSegmentControlDelegate>
{
    CGFloat vcWidth;  // 每个子视图控制器的视图的宽
    CGFloat vcHeight; // 每个子视图控制器的视图的高
    
    JRSegmentControl *segment;
    
    BOOL _isDrag;
}
@property (nonatomic, strong) UIScrollView *scrollView;


@end

@implementation QAskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   // QProblemViewController *first = [Utilities getStoryboardInstance:@"Main" byIdentity:@"first"];
    QProblemViewController *first = [Utilities getStoryboardInstanceByIdentity:@"Question" byIdentity:@"first"];
    QDetailViewController *detail = [Utilities getStoryboardInstanceByIdentity:@"Question" byIdentity:@"detail"];
    
    _viewControllers = @[first, detail];
    
    _titles = @[@"提问", @"回答"];
    [self setupScrollView];
    [self setupViewControllers];
    [self setupSegmentControl];

}
- (CGFloat)itemWidth
{
    if (_itemWidth == 0) {
        _itemWidth = 60.0f;
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
        Y = 64.0f;
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
    _itemWidth = 60.0f;
    // 设置titleView
    segment = [[JRSegmentControl alloc] initWithFrame:CGRectMake(0, 0, _itemWidth * 3, 30.0f)];
    segment.titles = self.titles;
    segment.cornerRadius = 5.0f;
    //导航条标题字体颜色
    segment.titleColor = [UIColor blackColor];
    //导航条标题选中颜色
    segment.indicatorViewColor = [UIColor whiteColor];
    //导航条标题未选中颜色
    segment.backgroundColor = [UIColor colorWithRed:255.f/255 green:170.f/255 blue:255.f/255 alpha:1.0f];
    
    segment.delegate = self;
    self.navigationItem.titleView = segment;
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segmentedControlSelected{
    
}

@end
