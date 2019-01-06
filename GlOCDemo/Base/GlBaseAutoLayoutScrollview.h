//
//  GlBaseAutoLayoutScrollview.h
//  LemonTeach
//
//  Created by gleeeli on 2018/10/26.
//  Copyright © 2018年 boyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
typedef enum : NSUInteger {
    GlAutoScrollViewHorization = 0,
    GlAutoScrollViewVertical,
} GlAutoScrollViewtype;

NS_ASSUME_NONNULL_BEGIN

@interface GlBaseAutoLayoutScrollview : UIScrollView
@property (strong, nonatomic) UIView *contentView;
@property (assign, nonatomic) GlAutoScrollViewtype scrollType;

- (instancetype)initWithType:(GlAutoScrollViewtype)scrollType;
@end

NS_ASSUME_NONNULL_END
