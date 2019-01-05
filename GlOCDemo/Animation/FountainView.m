//
//  FountainView.m
//  GlOCDemo
//
//  Created by 小柠檬 on 2019/1/5.
//  Copyright © 2019年 小柠檬. All rights reserved.
//

#import "FountainView.h"
#import "FountainModel.h"

@interface FountainView()
@property (nonatomic, strong) NSMutableArray<FountainModel *> *particles;
@property (nonatomic, assign) NSInteger particleCount;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) CGRect myFrame;
@end
@implementation FountainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.myFrame = frame;
        [self initBaseInfo];
    }
    
    return self;
}

- (void)initBaseInfo{
    self.scale = 1.0;
    CGSize size = self.myFrame.size;
    CGFloat cx = size.width * 0.5;
    //CGFloat cy = size.height * 0.5;
    
    self.particleCount = 500;
    self.particles = [NSMutableArray array];
    for (int i = 0; i < 250; i++) {
        FountainModel *model = [[FountainModel alloc] initWithX:cx y:size.height vx:([FountainModel getRandom] * 2 - 1) vy:([FountainModel getRandom] * - 50)];
        model.W = size.width;
        model.H = size.height;
        [self.particles addObject:model];
    }
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(loopAnimation)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)loopAnimation {
    
    if ([self.particles count] < self.particleCount) {
        CGSize size = self.myFrame.size;
        CGFloat cx = size.width * 0.5;
        FountainModel *model = [[FountainModel alloc] initWithX:cx y:size.height vx:([FountainModel getRandom] * 2 - 1) vy:([FountainModel getRandom] * - 50)];
        model.W = size.width;
        model.H = size.height;
        [self.particles addObject:model];
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    NSLog(@"draw----");
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetBlendMode(context, kCGBlendModeLighten);
    CGContextClearRect(context, rect);
    CGContextBeginPath(context);
    
    for (int i = 0; i < self.particles.count; i ++) {
        FountainModel *model = self.particles[i];
        model.maxHeightPercent = self.scale;
        [model update];
        [model render:context];
    }
//    CGContextRestoreGState(context);
}

- (void)stopAnimation
{
    
    if (self.displayLink)
    {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}
@end
