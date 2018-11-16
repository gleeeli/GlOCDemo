//
//  ViewController3.m
//  GlOCDemo
//
//  Created by 小柠檬 on 2018/9/26.
//  Copyright © 2018年 小柠檬. All rights reserved.
//

#import "ViewController3.h"
#import "GlCompareText/GlCompareTwoText.h"
#import "GlTwoTextEditDistance.h"
#import "TestAutoScorllviewViewController.h"

@interface ViewController3 ()
@property (nonatomic, strong) GlCompareTwoText *compare;
@property (nonatomic, strong) GlTwoTextEditDistance *distance;
@end

@implementation ViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *text1 = @"你现在认识不到互联网项目的好处，就是因为你的思维还没有到位，比如很多富翁都是干互联网的，比如马云，比如马化腾，当然还有很多世界级的首富，都是干互联网的，你只是看见他们赚钱，却不去想他们为什么赚钱";
    NSString *text2 = @"你现在认识不到互联网项目的好处，因为你的思维还没有到位，比如很多富翁都是干互联网的，比如马云，比如马化腾，当然还有很多世界级的首富，都是干互联网的，你只是看见他们赚钱，却不去想他们为什么赚钱";
    
    text1 = @"cafekb";
    text2 = @"icofmeb";
    
//    text1 = @"你现在认识不到互联网项目的好处，就是因为你的思维还没有到位";
//    text2 = @"你现在认识不到互联网项目的好处，因为你的思维还没有到位";
    
//    self.compare = [[GlCompareTwoText alloc] init];
//    self.compare.establishMatchLenght = 2;
//    [self.compare evaluateStr:text1 rightStr:text2];
    
    /****方式2****/
//    text1 = @"像允许无字的歌谣城市神奇地从四面八方飘然而起逐渐清晰起来响亮起来";
//    text2 = @"像一曲无字的歌谣神奇地从四面八方飘然而起逐渐清晰起来响亮起来由远而近由远而近";
//    NSInteger num = [self matchingTarget:text1 AndTotalText:text2];
//    NSLog(@"匹配个数:%zd",num);
//
//    float score = [self getScoreWithMathNum:num aReadLength:text1.length allLenght:text2.length];
//
//    NSLog(@"分数:%f",score);
    
    
    self.distance = [[GlTwoTextEditDistance alloc] init];
    [self.distance editDistanceOC:text1 rightStr:text2];
    
    
}

- (float)getScoreWithMathNum:(NSInteger)matchNum aReadLength:(NSInteger)aReadLength allLenght:(NSInteger)allLenght{
    
    if (allLenght <= 0) {
        return 0;
    }
    float score;
    
    if (aReadLength > allLenght) {//已读字数超过原文个数
        NSInteger insertNum = aReadLength  - allLenght;
        NSInteger errorNum = (allLenght > matchNum)? (allLenght - matchNum):0;//错误的字数
        if (matchNum > allLenght) {
            insertNum = matchNum  - allLenght;
        }
        
        score =  1 - (insertNum + errorNum)/(float)allLenght;
        score = score < 0? 0.0:score;
    }else {
        score = matchNum / (float)allLenght;
        NSInteger errorNum = (allLenght > matchNum)? (allLenght - matchNum):0;//错误的字数
    }
    
    if (score > 1) {
        score = 1.0;
    }
    
    return score;
}


//打分的匹配度
-(NSInteger)matchingTarget:(NSString *)target AndTotalText:(NSString *)totalText
{
    NSInteger targetLength = target.length;
    NSInteger totalTextLength = totalText.length;
    NSInteger resultCount = 0;
    NSLog(@"已读总长度:%zd",targetLength);
    for (NSInteger i = 0; i<targetLength; i++) {
        
        NSString *targetChar = [target substringWithRange:NSMakeRange(i,1)];
        if (i == 31) {
            NSLog(@"匹配的字：%@",targetChar);
        }
        
        for (NSInteger j = 0;j<totalTextLength;j++) {
            NSString *totalChar = [totalText substringWithRange:NSMakeRange(j,1)];
            if ([targetChar isEqualToString:totalChar]) {
                //NSLog(@"匹配的字：%@",targetChar);
                resultCount++;
                break;
            }
        }
    }
    return resultCount;//京口瓜洲一水间钟山只隔数重山春风又绿江南岸明月何时照我还土你哈喽哈喽
}

- (IBAction)toautoScollview:(id)sender {
    TestAutoScorllviewViewController *vc = [[TestAutoScorllviewViewController alloc] init];
    [self presentViewController:vc animated:YES completion:NO];
}


@end
