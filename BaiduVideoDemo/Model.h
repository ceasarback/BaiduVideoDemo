//
//  Model.h
//  BaiduVideoDemo
//
//  Created by Ceasarback on 14-1-3.
//  Copyright (c) 2014年 _CompanyName_. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

@property (nonatomic, retain)   NSString *title;
@property (nonatomic, retain)   NSString *works_type;
@property (nonatomic, retain)   NSString *works_id;
@property (nonatomic, retain)   NSString *url;
@property (nonatomic, retain)   NSString *img_url;
@property (nonatomic, retain)   NSString *duration;
@property (nonatomic, retain)   NSString *brief;

- (id)initWithData:(NSDictionary *)data;

@end
