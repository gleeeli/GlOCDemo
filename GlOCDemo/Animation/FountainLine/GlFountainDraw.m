//
//  GlFountainDraw.m
//  GlOCDemo
//
//  Created by luoluo on 2019/1/6.
//  Copyright © 2019年 小柠檬. All rights reserved.
//

#import "GlFountainDraw.h"

@implementation GlFountainDraw
- (instancetype)initWithRender:(GlFountainLineView *)render x:(CGFloat)x y:(CGFloat)y
{
    self = [super init];
    if (self)
    {
        self.render = render;
        self.x = x;
        self.y = y;
        [self initBaseInfo];
    }
    return self;
}

- (void)initBaseInfo {
    self.waterLines = [[NSMutableArray alloc] init];
    self.count = 0;
    self.theta = 0;
    self.status = 0;
}

- (void)render:(CGContextRef)context {
    CGContextSaveGState(context);
    CGContextSetRGBFillColor(context, 1.0, 0, 0, 1.0);
    CGContextTranslateCTM(context, self.x, self.y);
    CGContextScaleCTM(context, 1, 0.3);
    CGContextBeginPath(context);
    CGContextAddArc(context, 0, 0, 10, 0, M_PI, NO);
    CGContextFillPath(context);
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.x, self.y);
    for (long i = [self.waterLines count] - 1; i >= 0; i--) {
        if (![self.waterLines[i] render:context]) {
            [self.waterLines removeObjectAtIndex:i];
        }
    }
    CGContextRestoreGState(context);
    [self.waterLines addObject:[[GlWaterLine alloc] initWithRender:self.render]];
}


@end
