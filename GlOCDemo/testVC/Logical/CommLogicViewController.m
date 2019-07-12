//
//  CommLogicViewController.m
//  GlOCDemo
//
//  Created by 小柠檬 on 2019/1/19.
//  Copyright © 2019年 小柠檬. All rights reserved.
//

#import "CommLogicViewController.h"

@interface CommLogicViewController ()

@end

@implementation CommLogicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *content = @"<div class='aa'> <div class='left'>324324<div>dsfsdf</div><h1>aa</h1></div></div>";
    content = [self getWithName:@"newyear" type:@"html"];
//    content = @"<style> 哈哈哈</style>";
    
//    if ([content containsString:@"<style>"]) {
//        NSLog(@"包含：<style>");
//    }
//
//    if ([content containsString:@"</style>"]) {
//        NSLog(@"包含：</style>");
//    }
    
    NSString *pattern = @"(?is)<div class='left'[^>]*>(?><div[^>]*>(?<o>)|</div>(?<-o>)|(?:(?!</?div\b).)*)*(?(o)(?!))</div>";
//    pattern = @"<style .*>([\\d\\D]*)</style>";
    pattern = @"<div class=\"content\">([\\d\\D]*)</div>";
    
    content = @"<div class=\"content\">dddd</div>";
//    [self startPattern:pattern content:content];

//    [self replaceWithPattern:pattern content:content];
    
    pattern = @"<style .*>([\\d\\D]*)[^(<style)]</style>";
//    [self findMultipleWithPattern:pattern content:content];
    
//    [self testDeleteStyle];
    
    BOOL result = [self isOnlyLetterOrNumOrChines:@"中文123gg="];
    NSLog(@"是否中文数字字母：%d",result);
}

/*
 enum {
 NSRegularExpressionCaseInsensitive             = 1 << 0,   // 不区分大小写的
 NSRegularExpressionAllowCommentsAndWhitespace  = 1 << 1,   // 忽略空格和# -
 NSRegularExpressionIgnoreMetacharacters        = 1 << 2,   // 整体化
 NSRegularExpressionDotMatchesLineSeparators    = 1 << 3,   // 匹配任何字符，包括行分隔符
 NSRegularExpressionAnchorsMatchLines           = 1 << 4,   // 允许^和$在匹配的开始和结束行
 NSRegularExpressionUseUnixLineSeparators       = 1 << 5,   // (查找范围为整个的话无效)
 NSRegularExpressionUseUnicodeWordBoundaries    = 1 << 6    // (查找范围为整个的话无效)
 }
 */

/*
 typedef NS_OPTIONS(NSUInteger, NSMatchingOptions) {
 NSMatchingReportProgress         = 1 << 0, //找到最长的匹配字符串后调用block回调
 NSMatchingReportCompletion       = 1 << 1, //找到任何一个匹配串后都回调一次block
 NSMatchingAnchored               = 1 << 2, //从匹配范围的开始出进行极限匹配
 NSMatchingWithTransparentBounds  = 1 << 3, //允许匹配的范围超出设置的范围
 NSMatchingWithoutAnchoringBounds = 1 << 4  //禁止^和$自动匹配行还是和结束
 };
 */

- (void)testFindMultipleEmail {
    //测试找出多个邮箱
    NSString *testString1 = @"clc_cfzxyq@163.com wcowfjwogjwoiejfiow 12321@qq.com 298349845fwe ctftf:iLoveiOS@qq.com";
    NSError *error;
    //正则表达式，解析邮箱
    NSString* regexString = @"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";
}

- (void)testDeleteStyle {
    NSString *content = @"<style> 7 </style><style>没有我</style>";
    NSString *pattern = @"<style.*>((?!^style$).)*</style>";
    pattern = @"(?is)<(script|style)\\b[^>]*>(?(?!\\1\\b).)*</\\1>";
//    pattern = @"(<style.*>((?!没有我).)*</style>)/g";
    
    content = @"before (nope (yes (here) okay) after";
    pattern = @"\((?>[^()]+|\((?<DEPTH>)|\)(?<-DEPTH>))*(?(DEPTH)(?!))\)";
    
    [self findMultipleWithPattern:pattern content:content];
}

- (void)startPattern:(NSString *)pattern content:(NSString *)content{
    NSRange range = [self getRangeWithPattern:pattern content:content];
    if (range.length > 0) {
        NSString *result = [content substringWithRange:range];
        NSLog(@"result:%@",result);
        
//        content = [content stringByReplacingCharactersInRange:range withString:@""];
//        NSLog(@"净化后:%@",content);
        NSLog(@"********************************************");
//        [self startPattern:pattern content:content];
    }else {
        NSLog(@"未找到");
    }
}

- (NSString *)getPattern {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"pattern2" ofType:nil];
    NSString *JSONString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return JSONString;
}

- (NSString *)getWithName:(NSString *)name type:(NSString *)type {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"newyear" ofType:@"html"];
    NSString *JSONString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return JSONString;
}

- (void)test2 {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"newyear" ofType:@"html"];
    NSString *JSONString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //NSLog(@"本地%@",JSONString);
    [self parsercontent:JSONString];
}

- (void)parsercontent:(NSString *)content {
    NSRegularExpression *regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n"
                                                                                    options:0
                                                                                      error:nil];
    
    content=[regularExpretion stringByReplacingMatchesInString:content options:NSMatchingReportProgress range:NSMakeRange(0, content.length) withTemplate:@"-"];//替换所有html和换行匹配元素为"-"
    
    regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"-{1,}" options:0 error:nil] ;
    content=[regularExpretion stringByReplacingMatchesInString:content options:NSMatchingReportProgress range:NSMakeRange(0, content.length) withTemplate:@"-"];//把多个"-"匹配为一个"-"
    
    //根据"-"分割到数组
    NSArray *arr=[NSArray array];
    content=[NSString stringWithString:content];
    arr =  [content componentsSeparatedByString:@"-"];
    NSMutableArray *marr=[NSMutableArray arrayWithArray:arr];
    [marr removeObject:@""];
    for (NSString *str in marr) {
        NSLog(@"呵呵-------------%@",str);
        
    }
}

/**
 获取正则表达式的
 */
- (NSRange)getRangeWithPattern:(NSString *)pattern content:(NSString *)content
{
    //pattern = @"[0-9]*(?=胜)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    
    NSRange range = [regex rangeOfFirstMatchInString:content options:NSMatchingReportProgress range:NSMakeRange(0, content.length)];
    
//    NSArray *results = [regex matchesInString:content options:NSMatchingReportProgress range:NSMakeRange(0, content.length)];
//    // 3.遍历结果
//    for (NSTextCheckingResult *result in results) {
//        content = [content stringByReplacingCharactersInRange:range withString:@""];
//        NSLog(@"净化后:%@",content);
//        NSLog(@"%@ %@", NSStringFromRange(result.range), [content substringWithRange:result.range]);
//    }

    
    return range;
}

- (void)findMultipleWithPattern:(NSString *)pattern content:(NSString *)content {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    //方法二 查找多个 NSMatchingReportCompletion NSMatchingReportProgress
    NSArray *results = [regex matchesInString:content options:NSMatchingReportCompletion range:NSMakeRange(0, content.length)];
    for (NSTextCheckingResult *result in results) {
        NSString *tmp = [content substringWithRange:result.range];
        NSLog(@"----找到的：\n%@",tmp);
    }
    if ([results count] == 0) {
        NSLog(@"未找到：%@",pattern);
    }
}

- (void)replaceWithPattern:(NSString *)pattern content:(NSString *)content {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    //方法一 替换
    NSMutableString *muStr = [NSMutableString stringWithString:content];
    NSInteger result = [regex replaceMatchesInString:muStr options:NSMatchingReportCompletion range:NSMakeRange(0, content.length) withTemplate:@"***gleeeli***"];

    NSLog(@"结果:%zd,%@",result,muStr);
}

- (BOOL)isOnlyLetterOrNumOrChines:(NSString *)str {
    NSString *regex =@"[A-Za-z0-9\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:str];
}

@end
