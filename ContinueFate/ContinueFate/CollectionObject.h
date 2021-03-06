//
//  CollectionObject.h
//  ContinueFate
//
//  Created by jdld on 16/5/8.
//  Copyright © 2016年 XuYuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionObject : NSObject

@property (strong, nonatomic) NSString *id;
@property (nonatomic) int number;
@property (strong, nonatomic) NSString *articleid;
@property (strong, nonatomic) NSString *titlename;
@property (strong, nonatomic) NSString *substance;
@property (strong, nonatomic) NSString *edittime;
@property (nonatomic) int hits;
@property (nonatomic) int usertype;
@property (strong, nonatomic) NSString *username;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
