//
//  TestManager1.m
//  GlOCDemo
//
//  Created by 小柠檬 on 2018/12/4.
//  Copyright © 2018年 小柠檬. All rights reserved.
//

#import "TestManager1.h"

@interface TestManager1()

@end

@implementation TestManager1
+ (instancetype)sharedManager {
    
    static TestManager1 *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.myName = @"test1Manager";
    }
    
    return self;
}


- (void)method1 {
    NSLog(@"testmange1---method1");
}
@end
