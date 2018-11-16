//
//  GlTwoTextEditDistance.h
//  GlOCDemo
//
//  Created by 小柠檬 on 2018/10/19.
//  Copyright © 2018年 小柠檬. All rights reserved.
//

#import <Foundation/Foundation.h>

#define OpengLog 1

#ifdef DEBUG
#define LRString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define GlDebugLog(...) {\
if (OpengLog){ \
NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];\
[dateFormatter setLocale:[NSLocale currentLocale]];\
[dateFormatter setTimeZone:[NSTimeZone localTimeZone]];\
[dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];\
NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];\
printf("%s: %s 第%d行: %s\n",[dateString UTF8String], [LRString UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);\
}}

#else
#define GlDebugLog(...)
#endif

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    GlStepNone =0,
    GlStepDelete,
    GlStepInsert,
    GlStepSubstitute,//替换
} GlStepType;

@class GlEditDistanceModel;


typedef void(^CompleteDistanceBlock)(NSInteger minDistance);
typedef void(^CompleteMiddleBlock)(NSInteger minDistance, NSArray<GlEditDistanceModel *>* stepArray);
typedef void(^CompleteAllBlock)(NSInteger minDistance, NSArray<GlEditDistanceModel *>* stepArray,NSString *matchStr);

@interface GlTwoTextEditDistance : NSObject

/**
 返回最优距离 实现该block 将不会回调completeAllBlock
 */
@property (nonatomic, copy) CompleteDistanceBlock completeDistanceBlock;

/**
 返回最优距离和步骤
 */
@property (nonatomic, copy) CompleteMiddleBlock completeMiddleBlock;

/**
 返回最优距离,步骤,匹配到的字符串
 */
@property (nonatomic, copy) CompleteAllBlock completeAllBlock;

/**
 编辑距离
 
 @param str1 待评估字符串
 @param str2 正确字符串
 */
- (void)editDistanceOC:(NSString *)str1 rightStr:(NSString *)str2;
@end

@interface GlEditDistanceModel : NSObject
@property (nonatomic, assign) GlStepType stepType;
@property (nonatomic, assign) NSInteger distance;
@property (nonatomic, assign) NSInteger iCursor;
@property (nonatomic, assign) NSInteger jCursor;
@end
NS_ASSUME_NONNULL_END
