//
//  slidingAppointmentViewController.h
//  ContinueFate
//
//  Created by 刘金发 on 16/4/19.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface slidingAppointmentViewController : UIViewController


- (IBAction)SegmentAction:(UISegmentedControl *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)ReturnAction:(UIBarButtonItem *)sender;//返回
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;//segment的设置
@end
@interface Product : NSObject{
@private
    float     _price;
    NSString *_subject;
    NSString *_body;
    NSString *_orderId;
}

@property (nonatomic, assign) float price;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *orderId;

@end
