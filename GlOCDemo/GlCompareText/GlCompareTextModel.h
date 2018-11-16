//
//  GlCompareTextModel.h
//  UITest
//
//  Created by luoluo on 2018/9/26.
//  Copyright © 2018年 luoluo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlCompareTextModel : NSObject<NSCopying>
@property (nonatomic, assign) NSString *mID;
@property (nonatomic, assign) NSInteger replaceCount;//替换错误
@property (nonatomic, assign) NSInteger deleteCount;//删除错误
@property (nonatomic, assign) NSInteger insertCount;//插入错误

@property (nonatomic, assign) NSInteger lastMatchEvaluateIndex;//最后一次匹配成功的对应评估文本的序号
@property (nonatomic, assign) NSInteger lastMatchRightIndex;//最后一次匹配成功的对应正确文本的序号

@property (nonatomic, assign) NSInteger minResult;
@property (nonatomic, assign) NSInteger continueMatchCount;//接连匹配正确的个数
- (void)printMsg:(NSString *)msg;
@end
