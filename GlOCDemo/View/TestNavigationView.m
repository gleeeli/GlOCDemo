//
//  TestNavigationView.m
//  GlOCDemo
//
//  Created by 小柠檬 on 2018/9/7.
//  Copyright © 2018年 小柠檬. All rights reserved.
//

#import "TestNavigationView.h"

@implementation TestNavigationView

- (CGSize)intrinsicContentSize {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    return CGSizeMake(width, 44);
    return UILayoutFittingExpandedSize;
}

@end
