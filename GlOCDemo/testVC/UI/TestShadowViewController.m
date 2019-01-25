//
//  TestShadowViewController.m
//  GlOCDemo
//
//  Created by 小柠檬 on 2019/1/24.
//  Copyright © 2019年 小柠檬. All rights reserved.
//

#import "TestShadowViewController.h"

@interface TestShadowViewController ()

@end

@implementation TestShadowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self innerShadow];
    
    __weak typeof(self) weakSelf = self;
    [weakSelf innerShadow];
}

- (void)innerShadow {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 150, 200, 50)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    CAShapeLayer* shadowLayer = [CAShapeLayer layer];
    [shadowLayer setFrame:view.bounds];
    [shadowLayer setShadowColor:[[UIColor colorWithWhite:0 alpha:0.8] CGColor]];[shadowLayer setShadowOffset:CGSizeMake(0.0f,0.0f)];
    [shadowLayer setShadowOpacity:1.0f];
    [shadowLayer setFillRule:kCAFillRuleEvenOdd];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path,NULL,CGRectInset(view.bounds, -42, -42));
    
//    CGPathRef someInnerPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds cornerRadius:10.0f].CGPath;
    UIBezierPath *bpath = [UIBezierPath bezierPath];
    [bpath moveToPoint:CGPointMake(0, CGRectGetMaxY(view.bounds))];
    [bpath addLineToPoint:CGPointMake(CGRectGetMaxX(view.bounds), CGRectGetMaxY(view.bounds))];
    
    CGPathAddPath(path,NULL, (__bridge CGPathRef _Nullable)(bpath));
    CGPathCloseSubpath(path);
    [shadowLayer setPath:path];
    CGPathRelease(path);
    [[view layer]addSublayer:shadowLayer];
//    CAShapeLayer* maskLayer = [CAShapeLayer layer];
//    [maskLayer setPath:(__bridge CGPathRef _Nullable)(bpath)];
//    [shadowLayer setMask:maskLayer];
}

- (void)innerShadow2 {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 150, 200, 50)];
    [self.view addSubview:view];
    
    CAShapeLayer* shadowLayer = [CAShapeLayer layer];
    [shadowLayer setFrame:view.bounds];
    [shadowLayer setShadowColor:[[UIColor colorWithWhite:0 alpha:0.8] CGColor]];[shadowLayer setShadowOffset:CGSizeMake(0.0f,0.0f)];
    [shadowLayer setShadowOpacity:1.0f];
    [shadowLayer setFillRule:kCAFillRuleEvenOdd];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path,NULL,CGRectInset(view.bounds, -42, -42));
    CGPathRef someInnerPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds cornerRadius:10.0f].CGPath;CGPathAddPath(path,NULL, someInnerPath);
    CGPathCloseSubpath(path);
    [shadowLayer setPath:path];
    CGPathRelease(path);
    [[view layer]addSublayer:shadowLayer];
    CAShapeLayer* maskLayer = [CAShapeLayer layer];
    [maskLayer setPath:someInnerPath];
    [shadowLayer setMask:maskLayer];
}

@end
