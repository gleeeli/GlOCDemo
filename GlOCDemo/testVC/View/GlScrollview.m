//
//  GlScrollview.m
//  GlOCDemo
//
//  Created by gleeeli on 2018/12/13.
//  Copyright © 2018年 gleeeli. All rights reserved.
//

#import "GlScrollview.h"

@implementation GlScrollview
- (instancetype)init
{
    self = [super init];
    if (self) {
         self.panGestureRecognizer.cancelsTouchesInView = NO;
    }
    
    return self;
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    id view = otherGestureRecognizer.view;
    if ([[view superview] isKindOfClass:[UIWebView class]]) {
        view = [view superview];
    }
    NSLog(@"----- gestureRecognizer");
    return YES;
}

- (BOOL)touchesShouldBegin:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event inContentView:(UIView *)view {
    if (self.delegategl && [self.delegategl respondsToSelector:@selector(touchesShouldBegin:withEvent:inContentView:scrollview:)]) {
        return [self.delegategl touchesShouldBegin:touches withEvent:event inContentView:view scrollview:self];
    }
    
    return [super touchesShouldBegin:touches withEvent:event inContentView:view];
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    if (self.delegategl && [self.delegategl respondsToSelector:@selector(touchesShouldCancelInContentView:scrollview:)]) {
       return [self.delegategl touchesShouldCancelInContentView:view scrollview:self];
    }
    return [super touchesShouldCancelInContentView:view];
}


@end
