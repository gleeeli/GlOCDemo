//
//  UIImage+Additions.h
//  MyLive
//
//  Created by amiee on 15/7/8.
//  Copyright (c) 2015年 Amiee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Additions)

+ (instancetype)imageWithColor:(UIColor *)color;
+ (instancetype)stretchableImageWithColor:(UIColor *)color borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius;
+ (instancetype)imageWithColor:(UIColor *)color borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth dashLength:(CGFloat)dashLength dashPadding:(CGFloat)dashPadding cornerRadius:(CGFloat)cornerRadius inRect:(CGRect)rect;
+ (instancetype)roundedMaskImageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius inRect:(CGRect)rect;


- (instancetype)scaleToSize:(CGSize)size;

- (instancetype)aspectFitToSize:(CGSize)size;

- (void)saveWithPath:(NSString *)path name:(NSString *)name compressionQuality:(CGFloat)compressionQuality completion:(void (^)(void))completion;
- (void)saveToPNGWithPath:(NSString *)path name:(NSString *)name completion:(void (^)(void))completion;
- (instancetype)fixedOrientation;
- (instancetype)maskedImageWithMask:(UIImage *)maskImage;
- (instancetype)flippedHorizontally;
- (CGRect)transparentRect;
- (instancetype)scaleToBytes:(NSUInteger)bytes sizeCompress:(CGFloat)sizeCompress bytesCompress:(CGFloat)bytesCompress;
- (instancetype)tintedImageWithColor:(UIColor *)color;

//毛玻璃效果
/**
 *  这个太丑了 Radius:3
 *
 *  @return <#return value description#>
 */
- (UIImage *)applySubtleEffect;

/**
 *  透明模糊
 *
 *  @return <#return value description#>
 */
- (UIImage *)applyLightEffect;

/**
 *  白色模糊
 *
 *  @return <#return value description#>
 */
- (UIImage *)applyExtraLightEffect;

/**
 *  黑色模糊
 *
 *  @return <#return value description#>
 */
- (UIImage *)applyDarkEffect;

/**
 *  指定颜色模糊
 *
 *  @param tintColor 模糊背景色
 *
 *  @return <#return value description#>
 */
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;


- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;



//base64
- (NSString *)base64String;
- (NSString *)base64StringWithCompressionQuality:(CGFloat)compressionQuality;

+ (UIImage *)imageWithBase64String:(NSString *)base64;

@end
