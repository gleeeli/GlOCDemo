//
//  UIImage+Additions.m
//  MyLive
//
//  Created by amiee on 15/7/8.
//  Copyright (c) 2015年 Amiee. All rights reserved.
//

#import "UIImage+Additions.h"
#import <CoreGraphics/CoreGraphics.h>
#import <float.h>
#import <Accelerate/Accelerate.h>
//#import "MF_Base64Additions.h"


@implementation UIImage (Additions)

+ (instancetype)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIImage *image = nil;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(rect.size.width, rect.size.height), NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    [color setFill];
    [path fill];
    
    CGContextRestoreGState(ctx);
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (instancetype)stretchableImageWithColor:(UIColor *)color borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius {
    UIImage *image = nil;
    CGFloat size = 0;
    CGFloat cap = 0;
    if (cornerRadius <=0 && borderWidth <= 0) {
        return [[UIImage imageWithColor:color] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    } else if (cornerRadius <= 0 && borderWidth > 0) {
        size = borderWidth * 2 + 1;
        cap = borderWidth;
    } else if (cornerRadius > 0 && borderWidth <= 0) {
        size = cornerRadius * 2 + 1;
        cap = cornerRadius;
    } else {
        if (cornerRadius > borderWidth) {
            size = cornerRadius * 2 + 1;
            cap = cornerRadius;
        } else {
            size = borderWidth * 2 + 1;
            cap = borderWidth;
        }
    }
    
    CGRect rect = CGRectMake(0, 0, size, size);
    
    if (borderWidth > 0) {
        rect = CGRectInset(rect, borderWidth / 2, borderWidth / 2);
    }
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size, size), NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    
    if (color) {
        [color setFill];
        [path fill];
    }
    
    if (borderWidth > 0) {
        [borderColor setStroke];
        path.lineWidth = borderWidth;
        [path stroke];
    }
    
    CGContextRestoreGState(ctx);
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [image stretchableImageWithLeftCapWidth:cap topCapHeight:cap];
}

+ (instancetype)imageWithColor:(UIColor *)color borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth dashLength:(CGFloat)dashLength dashPadding:(CGFloat)dashPadding cornerRadius:(CGFloat)cornerRadius inRect:(CGRect)rect {
    UIImage *image = nil;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(rect.size.width, rect.size.height), NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    CGRect fixedRect = rect;
    if (borderWidth > 0) {
        fixedRect = CGRectInset(rect, borderWidth / 2, borderWidth / 2);
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:fixedRect cornerRadius:cornerRadius];
    
    if (color) {
        [color setFill];
        [path fill];
    }
    
    if (borderWidth > 0) {
        [borderColor setStroke];
        path.lineWidth = borderWidth;
        
        if (dashLength > 0) {
            CGFloat rectanglePattern[] = {dashLength, dashPadding};
            [path setLineDash: rectanglePattern count: 2 phase: 0];
        }
        
        [path stroke];
    }
    
    CGContextRestoreGState(ctx);
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (instancetype)roundedMaskImageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius  inRect:(CGRect)rect {
    UIImage *image = nil;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(rect.size.width, rect.size.height), NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:rect];
    [color setFill];
    [rectPath fill];
    
    UIBezierPath *roundedRectPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    CGContextSetBlendMode(ctx, kCGBlendModeClear);
    [[UIColor clearColor] set];
    [roundedRectPath fill];
    
    CGContextRestoreGState(ctx);
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (instancetype)scaleToSize:(CGSize)targetSize {
    //If scaleFactor is not touched, no scaling will occur
    CGFloat scaleFactor = 2.0;
    
    //Deciding which factor to use to scale the image (factor = targetSize / imageSize)
    if (self.size.width > targetSize.width || self.size.height > targetSize.height)
        if (!((scaleFactor = (targetSize.width / self.size.width)) > (targetSize.height / self.size.height))) //scale to fit width, or
            scaleFactor = targetSize.height / self.size.height; // scale to fit heigth.
    
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0);
    
    //Creating the rect where the scaled image is drawn in
    CGRect rect = CGRectMake((targetSize.width - self.size.width * scaleFactor) / 2,
                             (targetSize.height -  self.size.height * scaleFactor) / 2,
                             self.size.width * scaleFactor, self.size.height * scaleFactor);
    
    //Draw the image into the rect
    [self drawInRect:rect];
    
    //Saving the image, ending image context
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

- (instancetype)aspectFitToSize:(CGSize)size {
    CGSize imgsize = self.size;
    CGFloat scale = 2.0;
    if (imgsize.width > size.width || imgsize.height > size.height) {
        CGFloat widthScale = size.width / imgsize.width;
        CGFloat heightScale = size.height / imgsize.height;
        scale = MIN(widthScale, heightScale);
    }
    CGFloat width = imgsize.width;
    CGFloat height = imgsize.height;
    CGFloat scaledWidth = width * scale;
    CGFloat scaledHeight = height * scale;
    CGSize secSize =CGSizeMake(scaledWidth, scaledHeight);
    UIGraphicsBeginImageContext(secSize); // this will crop
    [self drawInRect:CGRectMake(0,0,scaledWidth,scaledHeight)];
    UIImage* newImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)saveWithPath:(NSString *)path name:(NSString *)name compressionQuality:(CGFloat)compressionQuality completion:(void (^)(void))completion {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *data = [NSData dataWithData:UIImageJPEGRepresentation(self, compressionQuality)];
        if (data) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if (![fileManager fileExistsAtPath:path]) {
                [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
            }
            
            NSString *filePath = [path stringByAppendingPathComponent:name];
            NSURL *fileURL = [NSURL fileURLWithPath:filePath];
            [fileManager createFileAtPath:filePath contents:data attributes:nil];
            [fileURL setResourceValue:@YES forKey:NSURLIsExcludedFromBackupKey error:nil];
            
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), completion);
            }
        }
    });
}

- (void)saveToPNGWithPath:(NSString *)path name:(NSString *)name completion:(void (^)(void))completion {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *data = [NSData dataWithData:UIImagePNGRepresentation(self)];
        if (data) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if (![fileManager fileExistsAtPath:path]) {
                [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
            }
            
            NSString *filePath = [path stringByAppendingPathComponent:name];
            NSURL *fileURL = [NSURL fileURLWithPath:filePath];
            [fileManager createFileAtPath:filePath contents:data attributes:nil];
            [fileURL setResourceValue:@YES forKey:NSURLIsExcludedFromBackupKey error:nil];
            
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), completion);
            }
        }
    });
}

- (UIImage*)maskImageWithMask:(UIImage *)maskImage {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGImageRef maskImageRef = [maskImage CGImage];
    
    // create a bitmap graphics context the size of the image
    CGContextRef mainViewContentContext = CGBitmapContextCreate (NULL, maskImage.size.width, maskImage.size.height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    
    if (mainViewContentContext==NULL)
        return NULL;
    
    CGFloat ratio = 0;
    
    ratio = maskImage.size.width/ self.size.width;
    
    if(ratio * self.size.height < maskImage.size.height) {
        ratio = maskImage.size.height/ self.size.height;
    }
    
    CGRect rect1  = { {0, 0}, {maskImage.size.width, maskImage.size.height} };
    CGRect rect2  = { {-((self.size.width*ratio)-maskImage.size.width)/2 , -((self.size.height*ratio)-maskImage.size.height)/2}, {self.size.width*ratio, self.size.height*ratio} };
    
    
    CGContextClipToMask(mainViewContentContext, rect1, maskImageRef);
    CGContextDrawImage(mainViewContentContext, rect2, self.CGImage);
    
    
    // Create CGImageRef of the main view bitmap content, and then
    // release that bitmap context
    CGImageRef newImage = CGBitmapContextCreateImage(mainViewContentContext);
    CGContextRelease(mainViewContentContext);
    
    UIImage *theImage = [UIImage imageWithCGImage:newImage];
    
    CGImageRelease(newImage);
    
    // return the image
    return theImage;
}

- (instancetype)fixedOrientation {
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp)
        return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.height, self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (instancetype)maskedImageWithMask:(UIImage *)maskImage {
    CGImageRef maskRef = maskImage.CGImage;
    CGImageRef imageRef = [self CGImage];
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, true);
    
    CGImageRef maskImageRef = CGImageCreateWithMask(imageRef, mask);
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGRectMake(0, 0, self.size.width, self.size.height), maskImageRef);
    UIImage *maskedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(mask);
    CGImageRelease(maskImageRef);
    
    return maskedImage;
}

- (instancetype)flippedHorizontally {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), self.size.width, 0);
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), -1.0, 1.0);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (CGRect)transparentRect {
    CGImageRef cgImage = self.CGImage;
    NSUInteger cols = CGImageGetWidth(cgImage);
    NSUInteger rows = CGImageGetHeight(cgImage);
    
    NSUInteger bytesPerRow = cols * sizeof(uint8_t);
    
    //allocate array to hold alpha channel
    uint8_t *bitmapData = calloc(rows * cols, sizeof(uint8_t));
    
    //create alpha-only bitmap context
    CGContextRef contextRef = CGBitmapContextCreate(bitmapData, cols, rows, 8, bytesPerRow, NULL, kCGImageAlphaOnly);
    
    //draw our image on that context
    CGRect rect = CGRectMake(0, 0, cols, rows);
    CGContextDrawImage(contextRef, rect, cgImage);
    
    //summ all non-transparent pixels in every row and every column
    uint16_t *rowSum = calloc(rows, sizeof(uint16_t));
    uint16_t *colSum = calloc(cols, sizeof(uint16_t));
    
    //enumerate through all pixels
    for ( int row = 0; row < rows; row++) {
        for ( int col = 0; col < cols; col++) {
            //found transparent pixel
            if (bitmapData[row * bytesPerRow + col] == 0) {
                rowSum[row]++;
                colSum[col]++;
            }
        }
    }
    
    //initialize crop insets and enumerate cols/rows arrays until we find empty columns or row
    UIEdgeInsets crop = UIEdgeInsetsMake(0, 0, 0, 0);
    
    //top
    for (NSInteger i = 0; i < rows; i++) {
        if (rowSum[i] != 0) {
            crop.top = i;
            break;
        }
    }
    
    //bottom
    for (NSInteger i = rows; i >= 0; i--) {
        if (rowSum[i] != 0) {
            crop.bottom = MAX(0, rows - i - 1);
            break;
        }
    }
    
    //left
    for (NSInteger i = 0; i < cols; i++) {
        if (colSum[i] != 0) {
            crop.left = i;
            break;
        }
    }
    
    //right
    for (NSInteger i = cols; i >= 0; i--) {
        if (colSum[i] != 0) {
            crop.right = MAX(0, cols - i - 1);
            break;
        }
    }
    
    free(bitmapData);
    free(colSum);
    free(rowSum);
    
    if (crop.top == 0 && crop.bottom == 0 && crop.left == 0 && crop.right == 0) {
        //no cropping needed
        return rect;
    } else {
        //calculate new crop bounds
        rect.origin.x += crop.left;
        rect.origin.y += crop.top;
        rect.size.width -= crop.left + crop.right;
        rect.size.height -= crop.top + crop.bottom;
        
        return rect;
    }
}

- (instancetype)scaleToBytes:(NSUInteger)bytes sizeCompress:(CGFloat)sizeCompress bytesCompress:(CGFloat)bytesCompress {
    NSData *data = UIImageJPEGRepresentation(self, 1.0);
    UIImage *scaledImage = [self copy];
    
    if (data.length >= bytes) {
        while (data.length >= bytes) {
            CGSize currentSize = CGSizeMake(scaledImage.size.width, scaledImage.size.height);
            scaledImage = [scaledImage resizedImage:CGSizeMake(roundf((currentSize.width * sizeCompress)), roundf((currentSize.height * sizeCompress))) interpolationQuality:bytesCompress];
            data = UIImageJPEGRepresentation(scaledImage, bytesCompress);
            scaledImage = [UIImage imageWithData:data];
        }
    }
    
    return scaledImage;
}

- (instancetype)tintedImageWithColor:(UIColor *)color {
    UIImage *tintedImage = [self imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [color set];
    [tintedImage drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tintedImage;
}

#pragma mark - Private methods

- (instancetype)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality {
    BOOL drawTransposed;
    
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;
        default:
            drawTransposed = NO;
    }
    
    return [self resizedImage:newSize transform:[self transformForOrientation:newSize] drawTransposed:drawTransposed interpolationQuality:quality];
}

- (UIImage *)resizedImage:(CGSize)newSize transform:(CGAffineTransform)transform drawTransposed:(BOOL)transpose interpolationQuality:(CGInterpolationQuality)quality {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;
    
    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(imageRef),
                                                0,
                                                CGImageGetColorSpace(imageRef),
                                                CGImageGetBitmapInfo(imageRef));
    
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}

- (CGAffineTransform)transformForOrientation:(CGSize)newSize {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    return transform;
}

#pragma mark - 毛玻璃效果

/**
 *  这个太丑了 Radius:3
 *
 *  @return <#return value description#>
 */
- (UIImage *)applySubtleEffect
{
    UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    return [self applyBlurWithRadius:3 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}

/**
 *  透明模糊
 *
 *  @return <#return value description#>
 */
- (UIImage *)applyLightEffect
{
    UIColor *tintColor = [UIColor colorWithWhite:0.3 alpha:0.2];
    return [self applyBlurWithRadius:7 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}

/**
 *  白色模糊
 *
 *  @return <#return value description#>
 */
- (UIImage *)applyExtraLightEffect
{
    UIColor *tintColor = [UIColor colorWithWhite:0.97 alpha:0.82];
    return [self applyBlurWithRadius:10 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}

/**
 *  黑色模糊
 *
 *  @return <#return value description#>
 */
- (UIImage *)applyDarkEffect
{
    UIColor *tintColor = [UIColor colorWithWhite:0.11 alpha:0.73];
    return [self applyBlurWithRadius:10 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}

/**
 *  指定颜色模糊
 *
 *  @param tintColor 模糊背景色
 *
 *  @return <#return value description#>
 */
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor
{
    const CGFloat EffectColorAlpha = 0.6;
    UIColor *effectColor = tintColor;
    size_t componentCount = CGColorGetNumberOfComponents(tintColor.CGColor);
    if (componentCount == 2)
    {
        CGFloat b;
        if ([tintColor getWhite:&b alpha:NULL])
        {
            effectColor = [UIColor colorWithWhite:b alpha:EffectColorAlpha];
        }
    }
    else
    {
        CGFloat r, g, b;
        if ([tintColor getRed:&r green:&g blue:&b alpha:NULL])
        {
            effectColor = [UIColor colorWithRed:r green:g blue:b alpha:EffectColorAlpha];
        }
    }
    return [self applyBlurWithRadius:10 tintColor:effectColor saturationDeltaFactor:-1.0 maskImage:nil];
}


- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage
{
    // Check pre-conditions.
    if (self.size.width < 1 || self.size.height < 1) {
        NSLog (@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
        return nil;
    }
    if (!self.CGImage) {
        NSLog (@"*** error: image must be backed by a CGImage: %@", self);
        return nil;
    }
    if (maskImage && !maskImage.CGImage) {
        NSLog (@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }
    
    CGRect imageRect = { CGPointZero, self.size };
    UIImage *effectImage = self;
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -self.size.height);
        CGContextDrawImage(effectInContext, imageRect, self.CGImage);
        
        vImage_Buffer effectInBuffer;
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        
        if (hasBlur) {
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            NSUInteger radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }
            else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);
    
    // Draw base image.
    CGContextDrawImage(outputContext, imageRect, self.CGImage);
    
    // Draw effect image.
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    
    // Add in color tint.
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}


//base64
- (NSString *)base64String {
    return [self base64StringWithCompressionQuality:0.1];
}

//- (NSString *)base64StringWithCompressionQuality:(CGFloat)compressionQuality {
//    if (!self) {
//        return @"";
//    }
//    NSData *data = UIImageJPEGRepresentation(self, compressionQuality);
////    NSString *base64 = [NSString stringWithFormat:@"data:image/jpeg;base64,%@",[data base64String]];
//    return base64;
//}
//
//+ (UIImage *)imageWithBase64String:(NSString *)base64 {
//    if (!base64 || base64.length == 0) {
//        return nil;
//    }
//    NSString *headimg = [base64 stringByReplacingOccurrencesOfString:@"data:image/jpeg;base64," withString:@""];
////    NSData *data = [NSData dataWithBase64String:headimg];
//    return [UIImage imageWithData:data];
//}

@end
