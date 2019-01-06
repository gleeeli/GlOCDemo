//
//  GlWaterLine.m
//  GlOCDemo
//
//  Created by luoluo on 2019/1/6.
//  Copyright © 2019年 小柠檬. All rights reserved.
//

#import "GlWaterLine.h"

@implementation GlWaterLine
- (instancetype)initWithRender:(GlFountainLineView *)render
{
    self = [super init];
    if (self)
    {
        self.render = render;
        [self initBaeInfo];
    }
    return self;
}

- (void)initBaeInfo {
    self.maxTraces = 80;
    CGFloat theta = [self.render getRandomValueWithMin:(- M_PI / 20.0) max:M_PI / 20.0];
    CGFloat rate = [self.render getRandomValueWithMin:0.8 max:1];
    self.x = [self.render getRandomValueWithMin:-2 max:2];
    self.y = 0;
    
    self.vx = self.render.velocity * sin(theta) * rate;
    self.vy = -self.render.velocity * cos(theta * [self.render getRandomValueWithMin:3 max:6]) * rate;
    self.opacity = 1;
    self.traces = [NSMutableArray array];
}

- (BOOL)render:(CGContextRef)context{
    [self.traces addObject:@{@"x":[NSNumber numberWithFloat:self.x],@"y":[NSNumber numberWithFloat:self.y]}];
    
    if ([self.traces count] > self.maxTraces) {
        [self.traces removeObjectAtIndex:0];
    }
    
    CGContextSaveGState(context);
    CGContextSetRGBStrokeColor(context, 0, 1, 0, self.opacity);
    CGContextBeginPath(context);
    CGContextSetBlendMode(context, kCGBlendModeLighten);
    CGFloat x = [[self.traces[0] objectForKey:@"x"] doubleValue];
    CGFloat y = [[self.traces[0] objectForKey:@"y"] doubleValue];
    CGContextMoveToPoint(context, x, y);
    NSInteger count = [self.traces count];
    for (int i = 1; i < count; i++) {
        CGFloat tx = [[self.traces[i] objectForKey:@"x"] doubleValue];
        CGFloat ty = [[self.traces[i] objectForKey:@"y"] doubleValue];
        CGContextAddLineToPoint(context, tx, ty);
    }
    
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    self.x += self.vx;
    self.y += self.vy;
    self.vy += self.render.gravity;
    
    if (self.vy > 0) {
        self.opacity -= 0.02;
    }
    
    return self.opacity > 0;
}
@end
