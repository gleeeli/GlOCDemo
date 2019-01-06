//
//  TestNavigationViewController.m
//  GlOCDemo
//
//  Created by gleeeli on 2018/11/16.
//  Copyright © 2018年 gleeeli. All rights reserved.
//

#import "TestNavigationViewController.h"
#import "UIButton+NMHitRect.h"

@interface TestNavigationViewController ()

@end

@implementation TestNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

/**
 自定义返回按钮
 */
-(void)createCustomLeftImgBarButton{
    UIBarButtonItem *backItem;
    //配置返回按钮距离屏幕边缘的距离
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 11.0) {
        UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        [backButton setImage:[UIImage imageNamed:@"back_login"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backItemClick:) forControlEvents:UIControlEventTouchUpInside];
        backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        //44 - 25 = 19 (25为图片大小)
        //19 + 8 = 27 / 2 = 18.5 - 1= 17.5
        backButton.contentEdgeInsets =UIEdgeInsetsMake(-2, -17.5,0, 0);
        backButton.imageEdgeInsets = UIEdgeInsetsMake(-2, -17.5,0, 0);
        backButton.hitEdgeInsets = UIEdgeInsetsMake(-1, -8.7, 0, 0);
    }else {
        spaceItem.width = - 8;
        backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_login"] style:UIBarButtonItemStylePlain target:self action:@selector(backItemClick:)];
    }
    self.navigationItem.leftBarButtonItems = @[spaceItem,backItem];
}

- (void)backItemClick:(UIBarButtonItem *)btnItem {
    if (self.navigationController && [self.navigationController.viewControllers count] > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
