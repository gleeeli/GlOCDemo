//
//  GlBaseAutoLayoutScrollview.m
//  LemonTeach
//
//  Created by gleeeli on 2018/10/26.
//  Copyright © 2018年 boyue. All rights reserved.
//

#import "GlBaseAutoLayoutScrollview.h"

@implementation GlBaseAutoLayoutScrollview

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initBaseView];
    }
    return self;
}

- (instancetype)initWithType:(GlAutoScrollViewtype)scrollType
{
    self = [super init];
    if (self)
    {
        [self initBaseView];
        self.scrollType = scrollType;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initBaseView];
    }
    return self;
}

- (void)initBaseView
{
    self.contentView = [[UIView alloc] init];
    [self addSubview:self.contentView];
//    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
//        make.centerY.equalTo(self);
//    }];
}

- (void)setScrollType:(GlAutoScrollViewtype)scrollType
{
    _scrollType = scrollType;
    if (scrollType == GlAutoScrollViewHorization)
    {
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
            make.centerY.equalTo(self);
        }];
    }
    else
    {
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
            make.centerX.equalTo(self);
        }];
    }
}

@end
