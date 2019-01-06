//
//  TestManager1.h
//  GlOCDemo
//
//  Created by gleeeli on 2018/12/4.
//  Copyright © 2018年 gleeeli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestManager1 : NSObject
@property (nonatomic, copy) NSString *myName;

+ (instancetype)sharedManager;

- (void)method1;
@end

NS_ASSUME_NONNULL_END
