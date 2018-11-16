//
//  RoundedView.h
//  begonia
//
//  Created by weienjie on 2017/4/1.
//  Copyright © 2017年 usmeibao. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface RoundedView : UIView

@property (nonatomic) IBInspectable CGFloat tml_cornerRadius;
@property (nonatomic) IBInspectable UIColor *tml_borderColor;
@property (nonatomic) IBInspectable CGFloat tml_borderWidth;
@property (nonatomic) IBInspectable BOOL tml_rounded;

@property (nonatomic) IBInspectable BOOL isShadowed;
@property (nonatomic) IBInspectable UIColor *shadowedColor;
@property (nonatomic) IBInspectable CGFloat shadowOpacity;
@property (nonatomic) IBInspectable CGFloat shadowRadius;


@end
