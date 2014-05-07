//
//  Model.m
//  BaiduVideoDemo
//
//  Created by Ceasarback on 14-1-3.
//  Copyright (c) 2014年 _CompanyName_. All rights reserved.
//

#import "Model.h"

@implementation Model

- (id)initWithData:(NSDictionary *)data
{
    if (self = [super init])
    {
        self.title = [data objectForKey:@"title"];
        self.works_type = [data objectForKey:@"works_type"];
        self.works_id = [data objectForKey:@"works_id"];
        self.url = [data objectForKey:@"url"];
        self.img_url = [data objectForKey:@"img_url"];
        self.duration = [data objectForKey:@"duration"];
        self.brief = [data objectForKey:@"brief"];
    }
    return self;
}

- (void)dealloc
{
    self.title = nil;
    self.works_type = nil;
    self.works_id = nil;
    self.url = nil;
    self.img_url = nil;
    self.duration = nil;
    self.brief = nil;
    
    [super dealloc];
}

@end
