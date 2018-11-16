//
//  ViewController2.m
//  GlOCDemo
//
//  Created by 小柠檬 on 2018/9/12.
//  Copyright © 2018年 小柠檬. All rights reserved.
//

#import "ViewController2.h"

@interface ViewController2 ()

@end

struct GlA {
    char name[100];
    struct GlB *bInAStruct;
};

struct GlB {
    char name[100];
    struct GlA aInBStruct;
};

struct LocationRegional {
    unsigned int r1:2;
    unsigned int r2:2;
};

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    struct GlB glB;
    strcpy(glB.name, "this is b name");
    
    struct GlA glA;
    strcpy(glA.name, "this is a name");
    
    glB.aInBStruct = glA;

    printf("print b struct:%s",glB.name);
    printf("print b struct:%s",glB.aInBStruct.name);
    
    //.000Z .Z
//    NSDate *date = [self date:@"2018-09-21T08:12:33" WithFormat:@"yyyy-MM-ddTHH:mm:ss"];
    NSDate *date = [self date:@"2018-09-21T08:12:33.000Z" WithFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    
    NSLog(@"打印日期:%@",date);
}

- (NSDateFormatter *)getLocalDataFormatter
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setCalendar:[NSCalendar currentCalendar]];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    return formatter;
}

- (NSDate *)date:(NSString *)datestr WithFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [self getLocalDataFormatter];
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString:datestr];
//#if ! __has_feature(objc_arc)
//    [dateFormatter release];
//#endif
    return date;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
