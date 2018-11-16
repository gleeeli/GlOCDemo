//
//  GlCompareTextModel.m
//  UITest
//
//  Created by luoluo on 2018/9/26.
//  Copyright © 2018年 luoluo. All rights reserved.
//

#import "GlCompareTextModel.h"

@implementation GlCompareTextModel

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.replaceCount = 0;//替换错误
        self.deleteCount = 0;//删除错误
        self.insertCount = 0;//插入错误
        
        self.lastMatchEvaluateIndex = -1;
        self.lastMatchRightIndex = -1;
        
        self.minResult = -1;
        self.mID = [NSString stringWithFormat:@"%@",self];
        self.continueMatchCount = 0;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    GlCompareTextModel *model = [[GlCompareTextModel allocWithZone:zone] init];
    model.replaceCount = self.replaceCount;
    model.deleteCount = self.deleteCount;
    model.insertCount = self.insertCount;
    model.lastMatchEvaluateIndex = self.lastMatchEvaluateIndex;
    model.lastMatchRightIndex = self.lastMatchRightIndex;
    
    return model;
}

- (void)printMsg:(NSString *)msg{
    NSLog(@"id:%@--%@",self.mID,msg);
}
@end
