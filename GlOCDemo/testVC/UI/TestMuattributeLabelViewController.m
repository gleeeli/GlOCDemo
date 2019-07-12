//
//  TestMuattributeLabelViewController.m
//  GlOCDemo
//
//  Created by 小柠檬 on 2019/2/25.
//  Copyright © 2019年 小柠檬. All rights reserved.
//

#import "TestMuattributeLabelViewController.h"

@interface TestMuattributeLabelViewController ()

@end

@implementation TestMuattributeLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel* contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 100, 200, 500)];
    contentLabel.backgroundColor = [UIColor redColor];
    contentLabel.numberOfLines = 0;
    [self.view addSubview:contentLabel];
    NSString *teststr= @"首行缩进根据字体大小自动调整 间隔可自定根据需求随意改变。。。。。。。";
    NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];paraStyle01.alignment = NSTextAlignmentLeft;
    //对齐/*这里这里*/
    paraStyle01.headIndent = 0.0f;//行首缩进//参数：（字体大小17号字乘以2，34f即首行空出两个字符）
    CGFloat emptylen = contentLabel.font.pointSize * 2;
    paraStyle01.firstLineHeadIndent = emptylen;
    //首行缩进
    paraStyle01.tailIndent = 0.0f;
    //行尾缩进
    paraStyle01.lineSpacing = 2.0f;
    //行间距
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:teststr attributes:@{NSParagraphStyleAttributeName:paraStyle01}];contentLabel.attributedText = attrText;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
