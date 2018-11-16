//
//  GlCompareTwoText.m
//  GlOCDemo
//
//  Created by 小柠檬 on 2018/9/25.
//  Copyright © 2018年 小柠檬. All rights reserved.
//

#import "GlCompareTwoText.h"
#import "GlCompareTextModel.h"

@interface GlCompareTwoText()
@property (nonatomic, copy) NSString *evaluateStr;//待评估的文本
@property (nonatomic, copy) NSString *rightStr;//正确的文本
@property (nonatomic, assign) NSInteger evaluateCount;
@property (nonatomic, assign) NSInteger rightCount;
@property (nonatomic, assign) NSInteger runRecursion;//运行的递归统计
@property (nonatomic, assign) NSInteger completeRecursion;//完成的递归统计
@property (nonatomic, strong) GlCompareTextModel *bestModel;

@end

@implementation GlCompareTwoText

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.establishMatchLenght = 0;
    }
    return self;
}

/**
 比较两个文本

 @param evaluateStr 待评估的字符串
 @param rightStr 正确的字符串
 */
- (void)evaluateStr:(NSString *)evaluateStr rightStr:(NSString *)rightStr{
    self.evaluateStr = evaluateStr;
    self.rightStr = rightStr;
    self.evaluateCount = evaluateStr.length;
    self.rightCount = rightStr.length;
    
    self.runRecursion = 1;
    self.completeRecursion = 0;
    self.bestModel = nil;
    NSTimeInterval startInterval = [[NSDate date] timeIntervalSince1970];
    [self recursionFindNextMatchCharEIndex:0 rIndex:0 model:[[GlCompareTextModel alloc] init] ];
    NSTimeInterval endInterval = [[NSDate date] timeIntervalSince1970];
    
    NSLog(@"评估的字符串：%ld,正确字符串长度：%ld,花费时间：%f",evaluateStr.length,rightStr.length,(endInterval - startInterval));
}

/**
 有一次递归结束
 */
- (void)oneRecursionEndModel:(GlCompareTextModel *)model{
    self.completeRecursion ++;
    
    
    if (model.lastMatchEvaluateIndex < 0) {//一次都没匹配上
        model.minResult = self.rightCount;
    }else{//至少匹配上一次
        model.minResult = model.replaceCount + model.deleteCount + model.insertCount;
    }
    
    
    if (!self.bestModel) {
        self.bestModel = model;
    }else{
        if (self.bestModel.minResult > model.minResult) {
            self.bestModel = model;
        }
    }
    NSLog(@"当前结果:%zd \n替换的：%zd,\n删除的:%zd,\n插入的:%zd\n",model.minResult,model.replaceCount,model.deleteCount,model.insertCount);
    
    if (self.runRecursion == self.completeRecursion) {
        NSLog(@"最优结果:%zd \n替换的：%zd,\n删除的:%zd,\n插入的:%zd\n执行次数:%zd",self.bestModel.minResult,self.bestModel.replaceCount,self.bestModel.deleteCount,self.bestModel.insertCount,self.completeRecursion);
    }
}

- (void)recursionFindNextMatchCharEIndex:(NSInteger)eIndex rIndex:(NSInteger)rIndex model:(GlCompareTextModel *)model{
    if (eIndex >= self.evaluateCount) {//已经找到最后一个
        if (model.lastMatchEvaluateIndex < 0) {//一次都没匹配上
            //model.minResult = -1;
        }
        else{
            if (model.lastMatchEvaluateIndex == self.evaluateCount - 1) {
                if (rIndex < self.rightCount) {//eIndex已经结束，rIndex未结束，视为删除
                    NSInteger eInterval = (self.evaluateCount - 1) - model.lastMatchEvaluateIndex;
                    NSInteger  rInterval = (self.rightCount -1) - model.lastMatchRightIndex;
                    [self handleNowGainWithEInterval:eInterval rInterval:rInterval model:model];
                }
            }else{//最后一次匹配上的不是最后一个
                NSInteger eInterval = (self.evaluateCount - 1) - model.lastMatchEvaluateIndex;
                NSInteger  rInterval = (self.rightCount -1) - model.lastMatchRightIndex;
                [self handleNowGainWithEInterval:eInterval rInterval:rInterval model:model];
            }
        }
        [self oneRecursionEndModel:model];
        return;
    }
    else if(model.lastMatchRightIndex >= self.rightCount - 1){//rArray匹配完了
        NSInteger eInterval = (self.evaluateCount - 1) - model.lastMatchEvaluateIndex;
        NSInteger  rInterval = (self.rightCount -1) - model.lastMatchRightIndex;
        [self handleNowGainWithEInterval:eInterval rInterval:rInterval model:model];
        
        [self oneRecursionEndModel:model];
        return;
    }

    NSInteger nowresult = model.replaceCount + model.deleteCount + model.insertCount;
    if (self.bestModel && nowresult > self.bestModel.minResult) {
        self.completeRecursion ++;
        NSLog(@"放弃本次结果:%zd",nowresult);
        return;
    }
//    NSString *msg = [NSString stringWithFormat:@"开始查找eIndex:%zd,rIndex:%zd",eIndex,rIndex];
//    [model printMsg:msg];
    NSString *nowEvaluateChar = [NSString stringWithFormat:@"%C",[self.evaluateStr characterAtIndex:eIndex]];
    //当前正确的字符
    NSString *nowRightChar = [NSString stringWithFormat:@"%C",[self.rightStr characterAtIndex:rIndex]];
    
    if ([nowEvaluateChar isEqualToString:nowRightChar]) {
        
        NSInteger nowContinueMatchCount = model.continueMatchCount + 1;
        GlCompareTextModel *errorModel = [model copy];
        //产生两种可能 匹配正确和匹配错误
        [self mayMatchRightWitheIndex:eIndex rIndex:rIndex model:model];
        
        /*未达到设置的最少接连匹配正确个数，无法断定当前一定匹配正确，增加一种结果
        */
        if (nowContinueMatchCount < self.establishMatchLenght || self.establishMatchLenght <= 0) {
            self.runRecursion ++;//进入这里每次增加一种结果
            [self mayMatchErrorWitheIndex:eIndex rIndex:rIndex model:errorModel];
        }
    }else{//当前字符不相等
        [self mayMatchErrorWitheIndex:eIndex rIndex:rIndex model:model];
    }
}

/**
 也许匹配正确
 */
- (void)mayMatchRightWitheIndex:(NSInteger)eIndex rIndex:(NSInteger)rIndex model:(GlCompareTextModel *)model{
//    NSString *msg = [NSString stringWithFormat:@"匹配正确eIndex:%zd,rIndex:%zd",eIndex,rIndex];
//    [model printMsg:msg];
    
    NSInteger eInterval;
    NSInteger rInterval;
    //之前已经匹配到过
    if (model.lastMatchEvaluateIndex >=0 && model.lastMatchRightIndex >= 0) {
        eInterval = eIndex - model.lastMatchEvaluateIndex - 1;
        rInterval = rIndex - model.lastMatchRightIndex - 1;
    }else{//之前还未匹配到过
        eInterval = eIndex;
        rInterval = rIndex;
    }
    
    [self handleNowGainWithEInterval:eInterval rInterval:rInterval model:model];
    
    model.continueMatchCount ++;
    model.lastMatchEvaluateIndex = eIndex;
    model.lastMatchRightIndex = rIndex;
    eIndex ++;
    rIndex ++;
    [self recursionFindNextMatchCharEIndex:eIndex rIndex:rIndex model:model];
}

/**
 处理当前获得的数据结果

 @param eInterval e相间多少个
 @param rInterval r相间多少个
 */
- (void)handleNowGainWithEInterval:(NSInteger)eInterval rInterval:(NSInteger)rInterval model:(GlCompareTextModel *)model{
    if (eInterval > rInterval) {
        //多出来的部分则为插入的
        model.insertCount += eInterval - rInterval;
        model.replaceCount += rInterval;
    }
    else if(eInterval == rInterval){
        model.replaceCount += rInterval;
    }
    else{
        model.deleteCount += rInterval - eInterval;
        model.replaceCount += eInterval;
    }
    
    //NSLog(@"临时结果:%zd \n替换的：%zd,\n删除的:%zd,\n插入的:%zd\n",model.minResult,model.replaceCount,model.deleteCount,model.insertCount);
}

/**
 也许匹配不对
 */
- (void)mayMatchErrorWitheIndex:(NSInteger)eIndex rIndex:(NSInteger)rIndex model:(GlCompareTextModel *)model{
//    NSString *msg = [NSString stringWithFormat:@"匹配不对 eIndex:%zd,rIndex:%zd",eIndex,rIndex];
//    [model printMsg:msg];
    //NSLog(@"最后一次匹配对的r:%zd",model.lastMatchRightIndex);
    
    //连续匹配正确为0
    model.continueMatchCount = 0;
    rIndex ++;//查找下一个rIndex 看是否匹配当前eIndex
    //rArray找到最后一个，也未能找到可以匹配当前eIndex的，放弃当前eIndex的查找
    if (rIndex >= self.rightCount) {
        eIndex ++;
        rIndex = model.lastMatchRightIndex >= 0? model.lastMatchRightIndex + 1:0;
    }
    
    [self recursionFindNextMatchCharEIndex:eIndex rIndex:rIndex model:model];
}

//- (NSInteger)getNextMatchWithStartIndex:(NSInteger)startIndex nowText:(NSString *)nowText startFindRightIndex:(NSInteger)startFindIndex allText:(NSString *)allText{
//    for (NSInteger i = startIndex; i < nowText.length; i++) {
//        NSString *nowUserChar = [nowText substringWithRange:NSMakeRange(i,1)];
//        for (NSInteger j = startFindIndex; j < allText.length; j++) {
//            NSString *nowRightChar = [nowText substringWithRange:NSMakeRange(j,1)];
//            if ([nowRightChar isEqualToString:nowUserChar]) {
//                return i;
//            }
//        }
//    }
//    return -1;
//}
//
//
//- (NSInteger)getIndexkeyStr:(NSString *)keyStr startFindIndex:(NSInteger)startFindIndex allText:(NSString *)allText{
//    NSString *remainText = [allText substringWithRange:NSMakeRange(startFindIndex, allText.length - startFindIndex)];
//    NSRange range = [remainText rangeOfString:keyStr];
//    if (range.location != NSNotFound && range.length > 0) {
//        return range.location + startFindIndex;
//    }
//    return -1;
//}
//
//- (void)createAllArray{
//    NSMutableArray *allarray = [[NSMutableArray alloc] init];
//
//    int i = 0;
//    while (i < self.evaluateCount) {
//        if ([allarray count] == 0) {
//            NSMutableString *tStr1 = [NSMutableString stringWithString:@"1"];
//            NSMutableString *tStr2 = [NSMutableString stringWithString:@"0"];;
//            [allarray addObject:tStr1];
//            [allarray addObject:tStr2];
//        }else{
//            NSInteger nowCount = [allarray count];
//            for (int j = 0; j < nowCount; j++) {
//                NSMutableString *nowmuStr = allarray[j];
//                NSMutableString *newBranchStr = [NSMutableString stringWithString:nowmuStr];
//
//                [nowmuStr appendString:@"1"];
//                [newBranchStr appendString:@"0"];
//            }
//        }
//    }
//
//    self.muarray = allarray;
//}
@end
