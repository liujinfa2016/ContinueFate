//
//  QuestionObject.h
//  ContinueFate
//
//  Created by hua on 16/4/23.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionObject : NSObject
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *titlename;
@property (strong, nonatomic) NSString *substance;
@property (strong,nonatomic)NSString *time;
@property (strong,nonatomic)NSString *type;
@property (strong,nonatomic)NSString *name;
@property (nonatomic) int hits;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
