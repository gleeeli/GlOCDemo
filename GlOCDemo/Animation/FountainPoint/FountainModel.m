//
//  FountainModel.m
//  GlOCDemo
//
//  Created by gleeeli on 2019/1/5.
//  Copyright © 2019年 gleeeli. All rights reserved.
//

#import "FountainModel.h"

@implementation FountainModel
- (instancetype)initWithX:(CGFloat)x y:(CGFloat)y vx:(CGFloat)vx vy:(CGFloat)vy
{
    self = [super init];
    if (self) {
        
        self.x = x;
        self.y = y;
        self.ox = x;
        self.oy = y;
        self.vx = vx;
        self.vy = vy;
        self.maxHeightPercent = 1.0;
        
        self.alpha = [FountainModel getRandom];
        
        self.lineWidth = [FountainModel getRandom] * 4;
    }
    
    return self;
}

+ (CGFloat)getRandom {
    int x = arc4random() % 100;
    return x / 100.0;
}

- (CGFloat)getCX {
    return self.W * 0.5;
}

- (void)update {
    self.vx += [FountainModel getRandom] * 0.5 - 0.25;
    self.vy += 0.8;
    self.alpha *= 0.95;
    self.ox = self.x;
    self.oy = self.y;
    self.x += self.vx;
    self.y += self.vy;
    
    CGFloat minY = self.H - self.H * self.maxHeightPercent;
    if (self.y < 0 || self.y < minY || self.y > self.H || self.alpha < 0.1) {
        self.vx = [FountainModel getRandom] * 2 - 1;
        self.vy = [FountainModel getRandom] * - 50;
        self.ox = self.x = [self getCX];
        self.oy = self.y = self.H;
        self.alpha = [FountainModel getRandom];
    }
}

- (void)render:(CGContextRef)context {
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetRGBStrokeColor(context, 1.0, 107/255.0, 0, self.alpha);
    CGContextMoveToPoint(context, self.ox, self.oy);
    CGContextAddLineToPoint(context, self.x, self.y);
    
//    if (self.vy > 0) {
//        CGContextStrokePath(context);
//       
//        CGContextAddArc(context, self.x, self.y, 10.0, 0, M_PI * 2, YES);
//        CGContextSetRGBFillColor(context, 1.0, 0, 0, 0.5);
//        CGContextFillPath(context);
//        CGContextStrokePath(context);
//    }
    
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}
@end
