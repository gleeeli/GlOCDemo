//
//  ViewController1.m
//  GlOCDemo
//
//  Created by 小柠檬 on 2018/9/7.
//  Copyright © 2018年 小柠檬. All rights reserved.
//

#import "ViewController1.h"
#import "TestNavigationView.h"
#import <WebKit/WebKit.h>
#import "YYKit.h"
#import "MCTestModel.h"
#import "TestHsegmentViewController.h"
#import "TestTableViewController.h"

@interface ViewController1 ()
@property(nonatomic, strong) WKWebView         *webView;

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    id data = nil;
    
    //NSAssert(nil, @"token为空");
    MCTestModel *model = [MCTestModel modelWithJSON:data];
    
    [self.view addSubview:self.webView];
    [self.webView loadHTMLString:@"<p>test</p>" baseURL:nil];
    
    [self.view sendSubviewToBack:self.webView];
}

- (IBAction)tohmsegment:(id)sender {
    TestHsegmentViewController *vc = [[TestHsegmentViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)textBtnClick:(id)sender {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com/"] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
    [self.webView loadRequest:request];
}

- (IBAction)testTableview:(id)sender {
    TestTableViewController *tableVC = [[TestTableViewController alloc] init];
    [self presentViewController:tableVC animated:YES completion:nil];
}

//- (void)matchText:(NSString *)nowText originText:(NSString *)originText{
//    NSInteger nowCount = nowText.length;
//    NSInteger originCount = originText.length;
//
//    NSInteger replaceCount = 0;//替换错误
//    NSInteger deleteCount = 0;//删除错误
//    NSInteger insertCount = 0;//插入错误
//
//    for (int i = 0; i < nowCount; i++) {
//
//    }
//}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, 320, 480)];
        _webView.navigationDelegate                   = self;
        _webView.scrollView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _webView;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    TestNavigationView *testView = [[TestNavigationView alloc] initWithFrame:CGRectMake(0, 0, width, 30)];
    testView.backgroundColor = [UIColor redColor];
//    testView.intrinsicContentSize = CGSizeMake(width, 44);
//    testView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = testView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)testsort {
    
}
@end
