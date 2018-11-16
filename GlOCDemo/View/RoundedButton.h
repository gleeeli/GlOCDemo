//
//  RoundedButton.h
//  begonia
//
//  Created by weienjie on 2017/4/1.
//  Copyright © 2017年 usmeibao. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface RoundedButton : UIButton

@property (nonatomic) IBInspectable CGFloat tml_cornerRadius;
@property (nonatomic) IBInspectable UIColor *tml_backgroundNormalColor;
@property (nonatomic) IBInspectable UIColor *tml_backgroundHighlightedColor;
@property (nonatomic) IBInspectable UIColor *tml_backgroundSelectedColor;
@property (nonatomic) IBInspectable UIColor *tml_backgroundDisabledColor;
@property (nonatomic) IBInspectable CGFloat tml_borderWidth;
@property (nonatomic) IBInspectable UIColor *tml_borderNormalColor;
@property (nonatomic) IBInspectable UIColor *tml_borderHighlightedColor;
@property (nonatomic) IBInspectable UIColor *tml_borderSelectedColor;
@property (nonatomic) IBInspectable UIColor *tml_borderDisabledColor;

@property (nonatomic) IBInspectable UIColor *tml_fontNormalColor;
@property (nonatomic) IBInspectable UIColor *tml_fontHighlightedColor;
@property (nonatomic) IBInspectable UIColor *tml_fontSelectedColor;
@property (nonatomic) IBInspectable UIColor *tml_fontDisabledColor;

@property (nonatomic) IBInspectable NSString *normalImage;
@property (nonatomic) IBInspectable NSString *highlightedImage;
@property (nonatomic) IBInspectable NSString *selectedImage;
@property (nonatomic) IBInspectable NSString *disabledImage;


@property (nonatomic) IBInspectable BOOL isShadowed;
@property (nonatomic) IBInspectable BOOL tml_rounded;

@end
