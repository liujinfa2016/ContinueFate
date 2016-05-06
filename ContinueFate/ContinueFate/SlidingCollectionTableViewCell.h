//
//  SlidingCollectionTableViewCell.h
//  ContinueFate
//
//  Created by demon on 16/4/25.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlidingCollectionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *articleLab;
@property (weak, nonatomic) IBOutlet UILabel *writerLab;
@property (weak, nonatomic) IBOutlet UILabel *readNumberLab;

@end
