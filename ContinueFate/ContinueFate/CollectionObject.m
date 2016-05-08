//
//  CollectionObject.m
//  ContinueFate
//
//  Created by jdld on 16/5/8.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "CollectionObject.h"

@implementation CollectionObject

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    self.id = [dict[@"id"]isKindOfClass:[NSNull class]]?@"":dict[@"id"];
    self.number = [dict[@"number"]isKindOfClass:[NSNull class]?0:dict[@"number"]];
    self.articleid = [dict[@"articleid"]isKindOfClass:[NSNull class]]?@"":dict[@"articleid"];
    self.titlename = [dict[@"titlename"]isKindOfClass:[NSNull class]]?@"":dict[@"titlename"];
    self.substance = [dict[@"substance"]isKindOfClass:[NSNull class]]?@"":dict[@"substance"];
    self.edittime = [dict[@"edittime"]isKindOfClass:[NSNull class]]?@"":dict[@"edittime"];
    self.hits = [dict[@"hits"]isKindOfClass:[NSNull class]?0:dict[@"hits"]];
    self.usertype = [dict[@"usertype"]isKindOfClass:[NSNull class]?0:dict[@"usertype"]];
    self.username = [dict[@"nickname"]isKindOfClass:[NSNull class]]?@"":dict[@"nickname"];
    
    return self;
}

@end
