//
//  BaseAutoLayoutScrollView.m
//  xiaoningmeng
//
//  Created by zqh on 2018/3/13.
//  Copyright © 2018年 gleeeli. All rights reserved.
//

#import "BaseAutoLayoutScrollView.h"

@implementation BaseAutoLayoutScrollView
- (instancetype)init{
    self = [super init];
    if (self){
        [self initBaseView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self initBaseView];
    }
    return self;
}

- (void)initBaseView{
//    self.scrollType =  AutoScrollViewHorization;
    self.contentView = [[UIView alloc] init];
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.centerY.equalTo(self);
    }];
}

- (void)setScrollType:(AutoScrollViewtype)scrollType{
    _scrollType = scrollType;
    if (scrollType == AutoScrollViewHorization){
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
            make.centerY.equalTo(self);
        }];
    }
    else
    {
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
            make.centerX.equalTo(self);
        }];
    }
}
@end
