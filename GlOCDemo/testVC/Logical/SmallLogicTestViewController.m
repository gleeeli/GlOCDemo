//
//  SmallLogicTestViewController.m
//  GlOCDemo
//
//  Created by 小柠檬 on 2019/1/22.
//  Copyright © 2019年 小柠檬. All rights reserved.
//

#import "SmallLogicTestViewController.h"

@interface SmallLogicTestViewController ()

@end

@implementation SmallLogicTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    NSString *path = [self testTry];
    //    NSLog(@"结果:%@",path);
    
    //    [self testDict];
    
    //    [self requestShareInfoComplete:^(BOOL isSuccess, NSString *bookName, NSString *bookCoverKey) {
    //        if (isSuccess == NO) {
    //            bookName = @"booknamehh";
    //        }
    //        NSLog(@"bookName:%@",bookName);
    //    }];
    
    //    [self testNumTostr:@"12345金木水火土，天地分上下"];
}

- (void)testNumTostr:(NSString *)str {
    NSDictionary *dict = @{@"0":@"零",@"1":@"一",@"2":@"二",@"3":@"三",@"4":@"四",@"5":@"五",@"6":@"六",@"7":@"七",@"8":@"八",@"9":@"九"};
    NSMutableString *mustr = [[NSMutableString alloc] initWithString:str];
    for (int i = 0; i < str.length; i++) {
        NSString *substr = [str substringWithRange:NSMakeRange(i,1)];
        if ([self isPureInt:substr] && [dict objectForKey:substr]) {
            [mustr replaceCharactersInRange:NSMakeRange(i,1) withString:[dict objectForKey:substr]];
        }
    }
    
    NSLog(@"转换后:%@",mustr);
}

- (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return[scan scanInt:&val] && [scan isAtEnd];
    
}

- (void)requestShareInfoComplete:(void(^)(BOOL isSuccess,NSString *bookName,NSString *bookCoverKey))complete {
    if (complete) {
        complete(NO,nil,nil);
    }
}

- (void)testDict {
    NSDictionary *dict = @{@"key1":@"test"};
    NSDictionary *dict1 = @{@"key2":@"test",@"activity":dict};
    
    NSString *result = dict1[@"test"][@"key1"];
    
    NSLog(@"result:%@",result);
}

- (NSString *)testTry {
    NSLog(@"start****");
    NSString *path = @"my path1";
    @try {
        path = @"my path2";
        NSArray *array = @[];
        //        array[2];
    } @catch (NSException *exception) {
        NSLog(@"exception-----%@",[exception description]);
    } @finally {
        NSLog(@"@finally****************");
        //        return path;
    }
    
    NSLog(@"allend****");
    return path;
}

@end
