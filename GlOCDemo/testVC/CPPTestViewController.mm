//
//  CPPTestViewController.m
//  GlOCDemo
//
//  Created by gleeeli on 2018/10/18.
//  Copyright © 2018年 gleeeli. All rights reserved.
//

#import "CPPTestViewController.h"
#import <iostream>

@interface CPPTestViewController ()

@end

@implementation CPPTestViewController
char s1[1000],s2[1000];

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *text1 = @"你现在认识不到互联网项目的好处，就是因为你的思维还没有到位，比如很多富翁都是干互联网的，比如马云，比如马化腾，当然还有很多世界级的首富，都是干互联网的，你只是看见他们赚钱，却不去想他们为什么赚钱";
    NSString *text2 = @"你现在认识不到互联网项目的好处，因为你的思维还没有到位，比如很多富翁都是干互联网的，比如马云，比如马化腾，当然还有很多世界级的首富，都是干互联网的，你只是看见他们赚钱，却不去想他们为什么赚钱";
//    text1 = @"cafe";
//    text2 = @"coffee";
    
    strcpy(s1, [text1 UTF8String]);
    strcpy(s2, [text2 UTF8String]);
    
    NSLog(@"text1 length:%ld, c lenght:%ld",text1.length,strlen(s1));
    
    //editDistance(strlen(s1),strlen(s2));
    [self editDistanceOC:text1 rightStr:text2];
}

/**
 编辑距离

 @param str1 待评估字符串
 @param str2 正确字符串
 */
- (void)editDistanceOC:(NSString *)str1 rightStr:(NSString *)str2{
    NSInteger len1 = str1.length;
    NSInteger len2 = str2.length;
    NSMutableArray *distance = [NSMutableArray arrayWithCapacity:len1 + 1];
    for (int i = 0; i <= len1; i ++) {
        distance[i] = [NSMutableArray arrayWithCapacity:len2 + 1];
    }
    //第一列
    for (int i = 0; i <= len1; i++) {
        distance[i][0] = [NSNumber numberWithInt:i];
    }
    
    //第一行
    for (int j = 0; j <= len2; j++) {
        distance[0][j] = [NSNumber numberWithInt:j];
    }
    
    for(int i=1;i<=len1;i++)
    {
        for(int j=1;j<=len2;j++)
        {
            NSInteger cost = [str1 characterAtIndex:i-1] == [str2 characterAtIndex:j-1]?0:1;
            NSInteger deletion = [distance[i-1][j] integerValue] + 1;
            NSInteger insertion = [distance[i][j-1] integerValue] + 1;
            NSInteger substitution = [distance[i-1][j-1] integerValue] + cost;
            distance[i][j] = [NSNumber numberWithInteger:[self getMinA:deletion b:insertion c:substitution]];
        }
    }
    
    NSInteger minDistance = [distance[len1][len2] integerValue];
    NSLog(@"最优步数:%zd",minDistance);
}

- (NSInteger)getMinA:(NSInteger)a b:(NSInteger)b c:(NSInteger)c{
    NSInteger min = a;
    if (b < min) {
        min = b;
    }
    if (c < min) {
        min = c;
    }
    
    return min;
}

int min(int a,int b,int c)
{
    int tmp=a<b?a:b;
    return tmp<c?tmp:c;
}

void editDistance(int len1,int len2)
{
    int **d=new int*[len1+1];
    for(int i=0;i<=len1;i++)
        d[i]=new int[len2+1];
    int i,j;
    for(i=0;i<=len1;i++)
        d[i][0]=i;
    for(j=0;j<=len2;j++)
        d[0][j]=j;
    for(i=1;i<=len1;i++)
    {
        for(j=1;j<=len2;j++)
        {
            int cost=s1[i-1]==s2[j-1]?0:1;
            int deletion=d[i-1][j]+1;
            int insertion=d[i][j-1]+1;
            int substitution=d[i-1][j-1]+cost;
            d[i][j]=min(deletion,insertion,substitution);
        }
    }
    printf("*****************************\n");
    for(j=0;j<=len2;j++)
    {
        printf("%c ",s2[j]);
    }
    for (int i = 0; i<=len1; i++) {
        printf("\n%c ",s1[i]);
        for(j=0;j<=len2;j++)
        {
            printf("%d ",d[i][j]);
        }
    }
    printf("\n距离为:%d\n",d[len1][len2]);
    for(int i=0;i<=len1;i++)
    {
        delete[] d[i];
    }
    delete[] d;
}
@end
