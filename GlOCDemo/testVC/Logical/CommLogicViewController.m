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
    pattern = @"<style .*>([\\d\\D]*)</style>";
    pattern = @"<div class=\"content\">([\\d\\D]*)</div>";
//    pattern = [self getPattern];
    
    
    [self startPattern:pattern content:content];
    
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
