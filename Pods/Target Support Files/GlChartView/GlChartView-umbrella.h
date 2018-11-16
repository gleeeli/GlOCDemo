#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "GlBasicAnimation.h"
#import "GlChartConfig.h"
#import "GlChartDataModel.h"
#import "GlChartViewDelegate.h"
#import "GlDrawLineView.h"
#import "GlLineChartView.h"
#import "GlXYCoordView.h"

FOUNDATION_EXPORT double GlChartViewVersionNumber;
FOUNDATION_EXPORT const unsigned char GlChartViewVersionString[];

