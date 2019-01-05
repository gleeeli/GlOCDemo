//
//  FountainModel.h
//  GlOCDemo
//
//  Created by 小柠檬 on 2019/1/5.
//  Copyright © 2019年 小柠檬. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FountainModel : NSObject
@property (nonatomic, assign) CGFloat W;
@property (nonatomic, assign) CGFloat H;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat ox;
@property (nonatomic, assign) CGFloat oy;
@property (nonatomic, assign) CGFloat vx;
@property (nonatomic, assign) CGFloat vy;
@property (nonatomic, assign) CGFloat alpha;
@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, assign) CGFloat maxHeightPercent;

- (instancetype)initWithX:(CGFloat)x y:(CGFloat)y vx:(CGFloat)vx vy:(CGFloat)vy;

- (void)update;

- (void)render:(CGContextRef)context;

+ (CGFloat)getRandom;
@end

NS_ASSUME_NONNULL_END
