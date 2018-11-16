//
//  IBCustomView.h
//  GlOCDemo
//
//  Created by 小柠檬 on 2018/8/6.
//  Copyright © 2018年 小柠檬. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface IBCustomView : UIView
@property (nonatomic, assign)IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign)IBInspectable CGFloat bwidth;
@property (nonatomic, assign)IBInspectable UIColor *bcolor;
@end
