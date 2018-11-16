//
//  TestTableViewController.m
//  GlOCDemo
//
//  Created by 小柠檬 on 2018/11/12.
//  Copyright © 2018年 小柠檬. All rights reserved.
//

#import "TestTableViewController.h"
#import "Masonry.h"
#import "UIScrollView+EmptyDataSet.h"
#import "YYKit.h"

@interface TestTableViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) NSMutableArray *muarray;
@property (nonatomic, strong) UITableView  *tableView;
@end

@implementation TestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    self.muarray = [NSMutableArray array];
    for (int i = 0; i < 100; i++) {
        [self.muarray addObject:@""];
    }
    [self.tableView reloadData];
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 150, 100, 50)];
    [btn setTitle:@"test" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(testClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:btn];
}

- (void)testClick:(id)sender {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    view.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.4];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    if ([self.tableView.subviews count] > 1) {
        [self.tableView insertSubview:view atIndex:0];
    }else {
        [self.tableView addSubview:view];
    }
    [self.muarray removeAllObjects];
    [self.tableView reloadData];
    [self.tableView reloadEmptyDataSet];
}

#pragma mark <UITableViewDelegate,UITableViewDataSource>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 155;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.muarray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {

    return [UIImage imageNamed:@"wangluo"];;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] init];
    [attrStr appendString:@"测试测试"];
    attrStr.font = [UIFont systemFontOfSize:15];
    attrStr.color = [UIColor grayColor];
    attrStr.alignment = NSTextAlignmentCenter;
    attrStr.lineBreakMode = NSLineBreakByWordWrapping;
    return attrStr;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {

    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] init];
    [attrStr appendString:@"测试测试"];
    attrStr.font = [UIFont systemFontOfSize:15];
    attrStr.color = [UIColor grayColor];
    attrStr.alignment = NSTextAlignmentCenter;
    attrStr.lineBreakMode = NSLineBreakByWordWrapping;
    return attrStr;
}

-(UIImage *)buttonImageForEmptyDataSet:(UIScrollView*)scrollView forState:(UIControlState)state {
    return [UIImage imageNamed:@"reloadbtn"];
}

//空白数据集 按钮被点击时 触发该方法
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {

}

//设置所有组件彼此之间的上下间距
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return 20;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return YES;
}

// 偏移量
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return 0;
}

@end
