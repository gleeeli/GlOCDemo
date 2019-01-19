//
//  TestAnimationViewController.m
//  GlOCDemo
//
//  Created by 小柠檬 on 2019/1/18.
//  Copyright © 2019年 小柠檬. All rights reserved.
//

#import "TestAnimationViewController.h"

@interface TestAnimationViewController ()

@end

@implementation TestAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 150, 100, 50)];
    [btn setTitle:@"测试" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(animationStart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)animationStart {
    [self animationWithGetMoney];
}

- (void)animationWithGetMoney {
    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.textColor = [UIColor redColor];
    moneyLabel.font = [UIFont systemFontOfSize:14];
    moneyLabel.text = @"500柠檬币";
    [self.view addSubview:moneyLabel];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    moneyLabel.layer.anchorPoint = CGPointMake(0.5, 0.5);
    [UIView animateWithDuration:1.5 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeScale(2, 2);
        moneyLabel.transform = transform;
    } completion:^(BOOL finished) {
        [self disappearAnimationWithView:moneyLabel];
    }];
}

- (void)disappearAnimationWithView:(UIView *)view {
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        view.alpha = 0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

@end
