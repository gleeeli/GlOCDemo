//
//  GlTwoTextEditDistance.m
//  GlOCDemo
//
//  Created by 小柠檬 on 2018/10/19.
//  Copyright © 2018年 小柠檬. All rights reserved.
//

#import "GlTwoTextEditDistance.h"
@interface GlTwoTextEditDistance()
@property (nonatomic, copy) NSString *str1;
@property (nonatomic, copy) NSString *str2;
@property (nonatomic, assign) NSInteger len1;
@property (nonatomic, assign) NSInteger len2;
@end

@implementation GlTwoTextEditDistance

/**
 编辑距离
 
 @param str1 待评估字符串
 @param str2 正确字符串
 */
- (void)editDistanceOC:(NSString *)str1 rightStr:(NSString *)str2{
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        @synchronized (self) {
            self.str1 = str1;
            self.str2 = str2;
            self.len1 = str1.length;
            self.len2 = str2.length;
            
            NSMutableArray *distance = [NSMutableArray arrayWithCapacity:self.len1 + 1];
            for (int i = 0; i <= self.len1; i ++) {
                distance[i] = [NSMutableArray arrayWithCapacity:self.len2 + 1];
            }
            //第一列
            for (int i = 0; i <= self.len1; i++) {
                GlEditDistanceModel *model = [[GlEditDistanceModel alloc] init];
                model.distance = i;
                model.stepType = GlStepDelete;
                distance[i][0] = model;
            }
            
            //第一行
            for (int j = 0; j <= self.len2; j++) {
                GlEditDistanceModel *model = [[GlEditDistanceModel alloc] init];
                model.distance = j;
                model.stepType = GlStepInsert;
                distance[0][j] = model;
            }
            
            for(int i=1;i<= self.len1;i++)
            {
                for(int j=1;j<= self.len2;j++)
                {
                    NSInteger cost = [str1 characterAtIndex:i-1] == [str2 characterAtIndex:j-1]?0:1;
                    GlEditDistanceModel *dmodel = distance[i-1][j];
                    GlEditDistanceModel *imodel = distance[i][j-1];
                    GlEditDistanceModel *smodel = distance[i-1][j-1];
                    
                    NSInteger deletion = dmodel.distance + 1;
                    NSInteger insertion = imodel.distance + 1;
                    NSInteger substitution = smodel.distance + cost;
                    
                    GlEditDistanceModel *model = [[GlEditDistanceModel alloc] init];
                    NSInteger minDistance = deletion;
                    GlStepType stepType = GlStepDelete;
                    if (insertion < minDistance) {
                        minDistance = insertion;
                        stepType = GlStepInsert;
                    }
                    
                    if (substitution < minDistance) {
                        minDistance = substitution;
                        stepType = cost == 0? GlStepNone:GlStepSubstitute;
                    }
                    model.stepType = stepType;
                    model.distance = minDistance;
                    distance[i][j] = model;
                }
            }
            
            [self structureStepWithDistanceArray:distance];
        }
    });
}

- (void)structureStepWithDistanceArray:(NSArray *)distance{
    
    GlEditDistanceModel *model = distance[self.len1][self.len2];
    NSInteger minDistance = model.distance;
    GlDebugLog(@"最优步数:%zd",minDistance);
    
    if (self.completeDistanceBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.completeDistanceBlock(minDistance);
        });
        return;
    }
    
    NSMutableArray<GlEditDistanceModel *> *stepArray = [[NSMutableArray alloc] init];
    NSInteger i = self.len1;
    NSInteger j = self.len2;
    while (i != 0 || j != 0) {
        GlEditDistanceModel *model = distance[i][j];
        model.iCursor = i;
        model.jCursor = j;
        [stepArray addObject:model];
        
        switch (model.stepType) {
            case GlStepDelete:{
                i--;
            }
                break;
            case GlStepInsert:{
                j--;
            }
                break;
                
            default:{//GlStepNone 和 GlStepSubstitute
                i--;
                j--;
            }
                break;
        }
    }
    
    if (self.completeMiddleBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.completeMiddleBlock(minDistance, stepArray);
        });
        return;
    }
    
    [self printAllStepWithStepArray:stepArray minDistance:minDistance];
}

/**
 打印所有的步骤

 @param stepArray 步骤数组
 */
- (void)printAllStepWithStepArray:(NSArray *)stepArray minDistance:(NSInteger)minDistance{
    NSString *sameStr = @"";
    for (long i = [stepArray count] - 1; i >=0 ; i --) {
        GlEditDistanceModel *model = stepArray[i];
        NSString *icur = model.iCursor > 0? [NSString stringWithFormat:@"%C",[self.str1 characterAtIndex:model.iCursor - 1]] : @"首位";
        
        if (model.stepType == GlStepNone) {
            sameStr = [NSString stringWithFormat:@"%@%@",sameStr,icur];
        }
        
        //下面打印具体的每一步操作
        NSString *op = @"无操作";
        switch (model.stepType) {
            case GlStepDelete:{
                op = @"删除";
            }
                break;
            case GlStepInsert:{
                NSString *jcur = [NSString stringWithFormat:@"%C",[self.str2 characterAtIndex:model.jCursor - 1]];
                op = [NSString stringWithFormat:@"插入%@",jcur];
            }
                break;
            case GlStepSubstitute:{
                NSString *jcur = [NSString stringWithFormat:@"%C",[self.str2 characterAtIndex:model.jCursor - 1]];
                op = [NSString stringWithFormat:@"替换%@",jcur];
            }
                break;
                
            default:{//GlStepNone
                
            }
                break;
        }
        GlDebugLog(@"当前字符:%@,%@",icur,op);
    }
    GlDebugLog(@"相同的字段为:%@",sameStr);
    
    if (self.completeAllBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.completeAllBlock(minDistance, stepArray, sameStr);
        });
    }
}

@end

@implementation GlEditDistanceModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.stepType = GlStepNone;
    }
    
    return self;
}
@end
