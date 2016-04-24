//
//  QuestionObject.m
//  ContinueFate
//
//  Created by hua on 16/4/23.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import "QuestionObject.h"

@implementation QuestionObject
- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    self.id = [dict[@"id"]isKindOfClass:[NSNull class]]?@"":dict[@"id"];
    self.titlename = [dict[@"titlename"]isKindOfClass:[NSNull class]]?@"":dict[@"titlename"];
    self.substance = [dict[@"substance"]isKindOfClass:[NSNull class]]?@"":dict[@"substance"];
    self.time = [dict[@"time"]isKindOfClass:[NSNull class]]?@"":dict[@"time"];
    self.hits = [dict[@"hits"]isKindOfClass:[NSNull class]?0:dict[@"hits"]];
    self.type = [dict[@"type"]isKindOfClass:[NSNull class]]?@"":dict[@"type"];
    self.name = [dict[@"name"]isKindOfClass:[NSNull class]]?@"":dict[@"name"];
    self.questionid = [dict[@"questionid"]isKindOfClass:[NSNull class]]?@"":dict[@"questionid"];
    self.userid = [dict[@"userid"]isKindOfClass:[NSNull class]]?@"":dict[@"userid"];
    self.userNickname = [dict[@"userNickname"]isKindOfClass:[NSNull class]]?@"":dict[@"userNickname"];
    self.userHeadImage = [dict[@"userHeadImage"]isKindOfClass:[NSNull class]]?@"":dict[@"userHeadImage"];
    return self;
}


@end
