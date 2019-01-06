//
//  GlCompareTwoText.h
//  GlOCDemo
//
//  Created by gleeeli on 2018/9/25.
//  Copyright © 2018年 gleeeli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlCompareTextModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GlCompareTwoText : NSObject

/**
 几个字符接连相等确定为匹配正确，default：0 性能最差，recommend: 2,数字越大性能越差准确度越高，反之
 小于等于0则准确度最高，但性能差，2的n次方，n为字数
 */
@property (nonatomic, assign) NSInteger establishMatchLenght;

/**
 比较两个文本
 
 @param evaluateStr 待评估的字符串
 @param rightStr 正确的字符串
 */
- (void)evaluateStr:(NSString *)evaluateStr rightStr:(NSString *)rightStr;
@end

NS_ASSUME_NONNULL_END
