//
//  GlFountainLineView.m
//  GlOCDemo
//
//  Created by luoluo on 2019/1/6.
//  Copyright © 2019年 小柠檬. All rights reserved.
//

#import "GlFountainLineView.h"
#import "GlFountainDraw.h"

@interface GlFountainLineView()

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) GlFountainDraw *fountain;
@property (nonatomic, strong) CADisplayLink *displayLink;
@end

@implementation GlFountainLineView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.width = frame.size.width;
        self.height = frame.size.height;
        [self initBaseInfo];
    }
    return self;
}

- (void) initBaseInfo {
    self.gravity = 0.05;
    self.baseRate = 0.6;
    self.offsetRate = 1 / 50.0;
    self.praticleCount = 30;
    self.velocity = 5.0;
    
    self.fountain = [[GlFountainDraw alloc] initWithRender:self x:(self.width * 0.5) y:(self.height * 0.5)];
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(loopAnimation)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)loopAnimation {
    //NSLog(@"***重绘***");
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetBlendMode(context, kCGBlendModeLighten);
    CGContextClearRect(context, rect);

    [self.fountain render:context];
}

- (CGFloat)getRandomValueWithMin:(CGFloat) min max:(CGFloat)max {
    long minL = min * 1000;
    long maxL = max * 1000;
    long x = arc4random() % (maxL - minL) + minL;
    
    return x / 1000.0;
}

+ (UIColor *)rgbFromHue:(float)hue andStaturation:(float)staturation andLightness:(float)lightness andAlpha:(float)alpha {
    return [UIColor colorWithHue:hue / 360.0f saturation:staturation / 100.0f  brightness:lightness / 100.0f  alpha:1.0];
    
    //ios 有专门针对hsv，hsl，hsb转换的接口，但是必须注意保证参数都是float型，否则显示的颜色有问题。如果传递的值不符合要求就必须先转换，原则是h/360.0f s/100.0f v,l,b / 100.0f 而且上面也有根据标准算法做的hsv到rgb的转换
}
@end
