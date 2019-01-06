//
//  GlFountainLineView.h
//  GlOCDemo
//
//  Created by luoluo on 2019/1/6.
//  Copyright © 2019年 小柠檬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GlFountainLineView : UIView
@property (nonatomic, assign) CGFloat gravity;//重力
@property (nonatomic, assign) CGFloat baseRate;
@property (nonatomic, assign) CGFloat offsetRate;
@property (nonatomic, assign) CGFloat praticleCount;
@property (nonatomic, assign) CGFloat velocity;

- (CGFloat)getRandomValueWithMin:(CGFloat) min max:(CGFloat)max;
+ (UIColor *)rgbFromHue:(float)hue andStaturation:(float)staturation andLightness:(float)lightness andAlpha:(float)alpha;
@end

NS_ASSUME_NONNULL_END
