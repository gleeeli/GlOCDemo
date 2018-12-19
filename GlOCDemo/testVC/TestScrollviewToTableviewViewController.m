//
//  TestScrollviewToTableviewViewController.m
//  GlOCDemo
//
//  Created by 小柠檬 on 2018/12/13.
//  Copyright © 2018年 小柠檬. All rights reserved.
//

#import "TestScrollviewToTableviewViewController.h"
#import "GlScrollview.h"

@interface TestScrollviewToTableviewViewController ()<UIScrollViewDelegate,GlTouchEventDelegate>

@property (nonatomic, strong) GlScrollview *scrollviewBack;
@property (nonatomic, strong) UIScrollView *scrollview1;
@property (nonatomic, assign) BOOL canScroll1;
@property (nonatomic, assign) CGFloat s1Height;

@end

@implementation TestScrollviewToTableviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.scrollviewBack = [[GlScrollview alloc] init];
    self.scrollviewBack.canScroll = YES;
    self.scrollviewBack.delegategl = self;
    self.scrollviewBack.delegate = self;
    [self.view addSubview:self.scrollviewBack];
    
    CGFloat top1Height = 360;
    UIView *topView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, top1Height)];
    topView1.backgroundColor = [UIColor greenColor];
    CGFloat bheight = SCREEN_HEIGHT - kTopHeight + top1Height;
    self.scrollviewBack.contentSize = CGSizeMake(SCREEN_WIDTH,  bheight);
    self.scrollviewBack.showsVerticalScrollIndicator = NO;
    [self.scrollviewBack addSubview:topView1];
    
    UIView *topView2 = [[UIView alloc] init];
    topView2.backgroundColor = [UIColor yellowColor];
    [self.scrollviewBack addSubview:topView2];
    
    self.canScroll1 = NO;
    self.scrollview1 = [[GlScrollview alloc] init];
    self.scrollview1.delegate = self;
    self.scrollview1.backgroundColor = [UIColor lightGrayColor];
    [self.scrollviewBack addSubview:self.scrollview1];
    
    CGFloat cheight = 1500;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 100, cheight)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.scrollview1 addSubview:contentView];
    self.scrollview1.contentSize = CGSizeMake(SCREEN_WIDTH, cheight + 50);

    [self.scrollviewBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
    }];
    
    [topView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView1.mas_bottom);
        make.leading.trailing.equalTo(topView1);
        make.height.mas_equalTo(50);
    }];
    
    self.s1Height = SCREEN_HEIGHT - kTopHeight - 50 - top1Height;
    [self.scrollview1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView2.mas_bottom);
        make.leading.trailing.equalTo(topView2);
        make.height.mas_equalTo(self.s1Height);
    }];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat backY = self.scrollviewBack.contentOffset.y;
    CGFloat s1Y = self.scrollview1.contentOffset.y;
    
    if(self.scrollviewBack.canScroll) {//顶部可以滑动的情况

        if (backY > 360) {//顶部滑动到最大值
            self.scrollviewBack.canScroll = NO;
            [self bandSBack];
            self.canScroll1 = YES;
        }else {
            [self bandS1];
        }
    }
    
    if (self.canScroll1) {
        if (s1Y < 0) {
            self.scrollviewBack.canScroll = YES;
            self.canScroll1 = NO;
            [self bandS1];
        }else {
            [self bandSBack];
        }
    }
    
    [self.scrollview1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.s1Height + self.scrollviewBack.contentOffset.y);
    }];
}

- (void)bandSBack {
    self.scrollviewBack.contentOffset = CGPointMake(0, 360);
}

- (void)bandS1 {
    self.scrollview1.contentOffset = CGPointMake(0, 0);
}

//- (BOOL)touchesShouldBegin:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event inContentView:(UIView *)view scrollview:(UIScrollView *)scrollview {
//
//    if (scrollview == self.scrollview1 && self.scrollviewBack.contentOffset.y < 360) {
//        return NO;
//    }
//
//    return YES;
//}

//- (BOOL)touchesShouldCancelInContentView:(UIView *)view scrollview:(UIScrollView *)scrollview {
//
//    return NO;
//}
@end
