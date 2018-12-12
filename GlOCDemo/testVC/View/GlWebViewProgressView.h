//
//  GlWebViewProgressView.h
//  LemonTeach
//
//  Created by 小柠檬 on 2018/8/20.
//  Copyright © 2018年 boyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GlWebViewProgressView : UIView
@property (nonatomic, assign) float progress;

@property (nonatomic, strong) UIView *progressBarView;
@property (nonatomic, assign) NSTimeInterval barAnimationDuration; // default 0.1
@property (nonatomic, assign) NSTimeInterval fadeAnimationDuration; // default 0.27
@property (nonatomic, assign) NSTimeInterval fadeOutDelay; // default 0.1

- (void)setProgress:(float)progress animated:(BOOL)animated;
@end
