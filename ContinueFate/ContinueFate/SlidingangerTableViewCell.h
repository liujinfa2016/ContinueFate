//
//  SlidingangerTableViewCell.h
//  ContinueFate
//
//  Created by ZIYAO YANG on 23/05/2016.
//  Copyright © 2016 XuYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlidingangerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;//头像
@property (weak, nonatomic) IBOutlet UILabel *nameLable;//发布者昵称
@property (weak, nonatomic) IBOutlet UILabel *tilteLable;//标题
@property (weak, nonatomic) IBOutlet UILabel *tilteview;//内容
-(void)cellAutoLayoutHeight:(NSString *)str; //这个方法就是用来更新cell高度的
@end
