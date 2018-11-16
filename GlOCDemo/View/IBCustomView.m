//
//  IBCustomView.m
//  GlOCDemo
//
//  Created by 小柠檬 on 2018/8/6.
//  Copyright © 2018年 小柠檬. All rights reserved.
//

#import "IBCustomView.h"


@implementation IBCustomView

- (void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius  = _cornerRadius;
    self.layer.masksToBounds = YES;
}

- (void)setBcolor:(UIColor *)bcolor{
    _bcolor = bcolor;
    self.layer.borderColor = _bcolor.CGColor;
}

- (void)setBwidth:(CGFloat)bwidth {
    _bwidth = bwidth;
    self.layer.borderWidth = _bwidth;
}

@end
