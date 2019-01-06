//
//  GlScrollview.h
//  GlOCDemo
//
//  Created by gleeeli on 2018/12/13.
//  Copyright © 2018年 gleeeli. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GlTouchEventDelegate <NSObject>
@optional
- (BOOL)touchesShouldBegin:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event inContentView:(UIView *)view scrollview:(UIScrollView *)scrollview;
- (BOOL)touchesShouldCancelInContentView:(UIView *)view scrollview:(UIScrollView *)scrollview;
@end

@interface GlScrollview : UIScrollView
@property (nonatomic, weak) id<GlTouchEventDelegate> delegategl;

@property (nonatomic, assign) BOOL canScroll;
@end
