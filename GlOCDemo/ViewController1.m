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
#import "MyManager.h"
#import "TestWkwebViewViewController.h"
#import "TestScrollviewToTableviewViewController.h"
#import "TestRecorderViewController.h"

@interface ViewController1 ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) WKWebView         *webView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *array;
@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    id data = nil;
    self.array = [[NSMutableArray alloc] init];
    [self.array addObject:@"wkwebview"];
    [self.array addObject:@"scrollviewToTableview"];
    [self.array addObject:@"recorder"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    
    //NSAssert(nil, @"token为空");
    MCTestModel *model = [MCTestModel modelWithJSON:data];
    
    [self.view addSubview:self.webView];
    [self.webView loadHTMLString:@"<p>test</p>" baseURL:nil];
    
    [self.view sendSubviewToBack:self.webView];
    
    
    TestManager1 *testManager = [TestManager1 sharedManager];
    MyManager *myManager = [MyManager sharedManager];
    
    NSLog(@"单列名字1:%@",testManager.myName);
    NSLog(@"单列名字:%@",myManager.myName);
    
    [testManager method1];
    [myManager method1];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = self.array[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vc;
    NSString *title = self.array[indexPath.row];
    if ([title isEqualToString:@"wkwebview"]) {
        vc = [[TestWkwebViewViewController alloc] initWithBaseHttpUrlStr:@"https://www.baidu.com/"];
    }
    else if ([title isEqualToString:@"scrollviewToTableview"]) {
        vc = [[TestScrollviewToTableviewViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
    }else if ([title isEqualToString:@"recorder"]) {
        vc = [[TestRecorderViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
    }
    
    
    
    [self.navigationController pushViewController:vc animated:YES];
}
@end
