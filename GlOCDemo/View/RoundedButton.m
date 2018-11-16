//
//  RoundedButton.m
//  begonia
//
//  Created by weienjie on 2017/4/1.
//  Copyright © 2017年 usmeibao. All rights reserved.
//

#import "RoundedButton.h"
#import "UIImage+Additions.h"
#define iPhone6Scale 1.0
@implementation RoundedButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self draw];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self draw];
    }
    return self;
}

- (void)setTml_cornerRadius:(CGFloat)tml_cornerRadius {
    if (_tml_cornerRadius != tml_cornerRadius) {
        _tml_cornerRadius = tml_cornerRadius;
        [self draw];
    }
}

- (void)setTml_backgroundNormalColor:(UIColor *)tml_backgroundNormalColor {
    if (![_tml_backgroundNormalColor isEqual:tml_backgroundNormalColor]) {
        _tml_backgroundNormalColor = tml_backgroundNormalColor;
        [self draw];
    }
}

- (void)setTml_backgroundHighlightedColor:(UIColor *)tml_backgroundHighlightedColor {
    if (![_tml_backgroundHighlightedColor isEqual:tml_backgroundHighlightedColor]) {
        _tml_backgroundHighlightedColor = tml_backgroundHighlightedColor;
        self.adjustsImageWhenHighlighted = NO;
        [self draw];
    }
}


- (void)setTml_backgroundSelectedColor:(UIColor *)backgroundSelectedColor {
    if (![_tml_backgroundSelectedColor isEqual:backgroundSelectedColor]) {
        _tml_backgroundSelectedColor = backgroundSelectedColor;
        [self draw];
    }
}

- (void)setTml_backgroundDisabledColor:(UIColor *)tml_backgroundDisabledColor {
    if (![_tml_backgroundDisabledColor isEqual:tml_backgroundDisabledColor]) {
        _tml_backgroundDisabledColor = tml_backgroundDisabledColor;
        [self draw];
    }
}

- (void)setTml_borderWidth:(CGFloat)tml_borderWidth {
    if (_tml_borderWidth != tml_borderWidth) {
        _tml_borderWidth = tml_borderWidth;
        [self draw];
    }
}

- (void)setTml_borderNormalColor:(UIColor *)tml_borderNormalColor {
    if (![_tml_borderNormalColor isEqual:tml_borderNormalColor]) {
        _tml_borderNormalColor = tml_borderNormalColor;
        [self draw];
    }
}

- (void)setTml_borderHighlightedColor:(UIColor *)tml_borderHighlightedColor {
    if (![_tml_borderHighlightedColor isEqual:tml_borderHighlightedColor]) {
        _tml_borderHighlightedColor = tml_borderHighlightedColor;
        [self draw];
    }
}

- (void)setTml_borderSelectedColor:(UIColor *)tml_borderSelectedColor {
    if (![_tml_borderSelectedColor isEqual:tml_borderSelectedColor]) {
        _tml_borderSelectedColor = tml_borderSelectedColor;
        [self draw];
    }
}

- (void)setTml_borderDisabledColor:(UIColor *)tml_borderDisabledColor {
    if (![_tml_borderDisabledColor isEqual:tml_borderDisabledColor]) {
        _tml_borderDisabledColor = tml_borderDisabledColor;
        [self draw];
    }
}

-(void)setTml_fontNormalColor:(UIColor *)tml_fontNormalColor
{
    if (![_tml_fontNormalColor isEqual:tml_fontNormalColor]) {
        _tml_fontNormalColor = tml_fontNormalColor;
        [self draw];
    }
}

-(void)setTml_fontDisabledColor:(UIColor *)tml_fontDisabledColor
{
    if (![_tml_fontDisabledColor isEqual:tml_fontDisabledColor]) {
        _tml_fontDisabledColor = tml_fontDisabledColor;
        [self draw];
    }
}

-(void)setTml_fontHighlightedColor:(UIColor *)tml_fontHighlightedColor
{
    if (![_tml_fontHighlightedColor isEqual:tml_fontHighlightedColor]) {
        _tml_fontHighlightedColor = tml_fontHighlightedColor;
        
        [self draw];
    }
}

-(void)setTml_fontSelectedColor:(UIColor *)tml_fontSelectedColor
{
    if (![_tml_fontSelectedColor isEqual:tml_fontSelectedColor]) {
        _tml_fontSelectedColor = tml_fontSelectedColor;
        [self draw];
    }
}

-(void)setIsShadowed:(BOOL)isShadowed
{
    if (_isShadowed !=isShadowed) {
        _isShadowed = isShadowed;
        [self draw];
    }
}

- (void)setTml_rounded:(BOOL)tml_rounded {
    if (_tml_rounded != tml_rounded) {
        _tml_rounded = tml_rounded;
        [self draw];
    }
}

-(void)setNormalImage:(NSString *)normalImage
{
    if (![_normalImage isEqualToString:normalImage]) {
        _normalImage = normalImage;
        [self draw];
    }
}

-(void)sethighlightedImage:(NSString *)highlightedImage
{
    if (![_highlightedImage isEqualToString:highlightedImage]) {
        _highlightedImage = highlightedImage;
        [self draw];
    }
}

-(void)setselectedImage:(NSString *)selectedImage
{
    if (![_selectedImage isEqualToString:selectedImage]) {
        _selectedImage = selectedImage;
        [self draw];
    }
}

-(void)setdisabledImage:(NSString *)disabledImage
{
    if (![_disabledImage isEqualToString:disabledImage]) {
        _disabledImage = disabledImage;
        [self draw];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.tml_rounded) {
        NSUInteger roundSize = self.frame.size.width<=self.frame.size.height?self.frame.size.width:self.frame.size.height;
        self.layer.cornerRadius = roundSize/ 2.0;
        self.tml_cornerRadius = roundSize / 2.0;
    }
    else if (self.tml_cornerRadius > 0 && !self.tml_backgroundNormalColor && !self.tml_rounded) {
        self.layer.cornerRadius = self.tml_cornerRadius*iPhone6Scale;
    }
}


- (void)draw {
    if (self.tml_rounded) {
        NSUInteger roundSize = self.frame.size.width<=self.frame.size.height?self.frame.size.width:self.frame.size.height;
        self.layer.cornerRadius = roundSize/ 2.0;
        self.tml_cornerRadius = roundSize / 2.0;
    }
    else if (self.tml_cornerRadius > 0 && !self.tml_rounded) {
        self.layer.cornerRadius = self.tml_cornerRadius*iPhone6Scale;
    }
    [self setTitleColor:[self titleColorForState:UIControlStateSelected] forState:UIControlStateSelected|UIControlStateHighlighted];
    if (self.tml_borderHighlightedColor|| self.tml_backgroundHighlightedColor) {
        [self setBackgroundImage:[UIImage stretchableImageWithColor:self.tml_backgroundHighlightedColor borderColor:self.tml_borderHighlightedColor borderWidth:self.tml_borderWidth cornerRadius:self.tml_cornerRadius] forState:UIControlStateHighlighted];
    }
    if (self.tml_borderNormalColor || self.tml_backgroundNormalColor) {
        [self setBackgroundImage:[UIImage stretchableImageWithColor:self.tml_backgroundNormalColor borderColor:self.tml_borderNormalColor borderWidth:self.tml_borderWidth cornerRadius:self.tml_cornerRadius] forState:UIControlStateNormal];
    }
    
    if (self.tml_borderSelectedColor || self.tml_backgroundSelectedColor) {
        [self setBackgroundImage:[UIImage stretchableImageWithColor:self.tml_backgroundSelectedColor borderColor:self.tml_borderSelectedColor borderWidth:self.tml_borderWidth cornerRadius:self.tml_cornerRadius] forState:UIControlStateSelected];
    }
    if (self.tml_borderDisabledColor || self.tml_backgroundDisabledColor) {
        [self setBackgroundImage:[UIImage stretchableImageWithColor:self.tml_backgroundDisabledColor borderColor:self.tml_borderDisabledColor borderWidth:self.tml_borderWidth cornerRadius:self.tml_cornerRadius] forState:UIControlStateDisabled];
    }
    if (self.tml_fontNormalColor) {
        [self setTitleColor:self.tml_fontNormalColor forState:UIControlStateNormal];
    }
    if (self.tml_fontDisabledColor) {
        [self setTitleColor:self.tml_fontDisabledColor forState:UIControlStateDisabled];
    }
    if (self.tml_fontSelectedColor) {
        [self setTitleColor:self.tml_fontSelectedColor forState:UIControlStateSelected];
    }
    if (self.tml_fontHighlightedColor) {
        [self setTitleColor:self.tml_fontHighlightedColor forState:UIControlStateHighlighted];
    }
//    if (self.normalImage) {
//        [self setImage:IMAGE_NAMED(self.normalImage) forState:UIControlStateNormal];
//    }
//    if (self.disabledImage) {
//        [self setImage:IMAGE_NAMED(self.disabledImage) forState:UIControlStateDisabled];
//    }
//    if (self.highlightedImage) {
//        [self setImage:IMAGE_NAMED(self.highlightedImage) forState:UIControlStateHighlighted];
//    }
//    if (self.selectedImage) {
//        [self setImage:IMAGE_NAMED(self.selectedImage) forState:UIControlStateSelected];
//    }

    if (self.isShadowed) {
        [self.layer setShadowPath:[UIBezierPath bezierPathWithRect:self.bounds].CGPath];//这句严重影响性能
        self.layer.shadowRadius = 2;
        self.layer.shadowOpacity = 0.1;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 0);
    }
}

@end
