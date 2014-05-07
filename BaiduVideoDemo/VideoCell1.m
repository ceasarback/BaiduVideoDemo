//
//  VideoCell1.m
//  BaiduVideoDemo
//
//  Created by Ceasarback on 14-1-3.
//  Copyright (c) 2014年 _CompanyName_. All rights reserved.
//

#import "VideoCell1.h"

@implementation VideoCell1

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    _v1.layer.borderWidth = 2.0f;
    _v1.layer.borderColor = [UIColor whiteColor].CGColor;
    _v1.layer.shadowOpacity = 0.6;
    _v1.layer.shadowOffset = CGSizeZero;
    _v1.userInteractionEnabled = YES;
    
    _v2.layer.borderWidth = 2.0f;
    _v2.layer.borderColor = [UIColor whiteColor].CGColor;
    _v2.layer.shadowOpacity = 0.6;
    _v2.layer.shadowOffset = CGSizeZero;
    _v2.userInteractionEnabled = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_v1 release];
    [_v2 release];
    [_t1 release];
    [_t2 release];
    [_m1 release];
    [_m2 release];
    [super dealloc];
}
@end
