//
//  BomAnimationViewController.m
//  GlOCDemo
//
//  Created by gleeeli on 2019/1/2.
//  Copyright © 2019年 gleeeli. All rights reserved.
//

#import "BomAnimationViewController.h"
#import "BomObject.h"

@interface BomAnimationViewController ()
@property (nonatomic, strong) BomObject *bomAnimation;
@end

@implementation BomAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.bomAnimation = [[BomObject alloc] init];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 150, 80, 80)];
    [btn setTitle:@"animiation1" forState:UIControlStateNormal];
    [btn setTitle:@"animiation2" forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(animation:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    btn.center = self.view.center;
}

- (void)animation:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self.bomAnimation animation1WithView:self.view];
    }else {
        [self.bomAnimation animationBomWithView:btn];
    }
}

- (void)test {
    CGContextRef context = UIGraphicsGetCurrentContext();
}
@end
