//
//  GlFountainDraw.h
//  GlOCDemo
//
//  Created by luoluo on 2019/1/6.
//  Copyright © 2019年 小柠檬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlWaterLine.h"

@interface GlFountainDraw : NSObject
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, strong) NSMutableArray<GlWaterLine *> *waterLines;
//@property (nonatomic, assign) NSInteger hue;
//@property (nonatomic, assign) NSInteger destinationHue;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) double theta;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) GlFountainLineView *render;

- (instancetype)initWithRender:(GlFountainLineView *)render x:(CGFloat)x y:(CGFloat)y;
- (void)render:(CGContextRef)context;
@end
