//
//  BaseAutoLayoutScrollView.h
//  ZhongQiuHui
//
//  Created by zqh on 2018/3/13.
//  Copyright © 2018年 WeiEr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
typedef enum : NSUInteger {
    AutoScrollViewHorization = 0,
    AutoScrollViewVertical,
} AutoScrollViewtype;
@interface BaseAutoLayoutScrollView : UIScrollView
@property (strong, nonatomic) UIView *contentView;
@property (assign, nonatomic) AutoScrollViewtype scrollType;
@end
