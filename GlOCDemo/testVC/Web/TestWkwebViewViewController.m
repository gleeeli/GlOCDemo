//
//  TestWkwebViewViewController.m
//  GlOCDemo
//
//  Created by gleeeli on 2018/12/12.
//  Copyright © 2018年 gleeeli. All rights reserved.
//测试滑动webview隐藏导航栏

#import "TestWkwebViewViewController.h"

@interface TestWkwebViewViewController ()<UIScrollViewDelegate>

@end

@implementation TestWkwebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView.scrollView.delegate = self;

    
    [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kStatusBarHeight);
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.webView.scrollView.contentOffset.y == 0) {
//        self.navBarBgAlpha = [NSString stringWithFormat:@"%f",0.0];
    }
}
- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"offsetY:%f",offsetY);
    
    if (offsetY > 0) {
        CGFloat alpha = offsetY / 64.0;
        if (alpha > 1.0) {
            alpha = 1.0;
        }
//        self.navBarBgAlpha = [NSString stringWithFormat:@"%f",alpha];
    }else {
//        self.navBarBgAlpha = [NSString stringWithFormat:@"%f",0.0];
    }
}

- (void)dealloc {
    NSLog(@"dealloc webvc");
}
@end
