//
//  GlWaterLine.h
//  GlOCDemo
//
//  Created by luoluo on 2019/1/6.
//  Copyright © 2019年 小柠檬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlFountainLineView.h"


@interface GlWaterLine : NSObject
@property (nonatomic, assign) NSInteger maxTraces;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat vx;
@property (nonatomic, assign) CGFloat vy;
@property (nonatomic, assign) CGFloat opacity;
@property (nonatomic, strong) NSMutableArray *traces;

@property (nonatomic, strong) GlFountainLineView *render;

- (instancetype)initWithRender:(GlFountainLineView *)render;
- (BOOL)render:(CGContextRef)context;
@end
