//
//  GlCommHeader.h
//  GlOCDemo
//
//  Created by 小柠檬 on 2018/12/12.
//  Copyright © 2018年 小柠檬. All rights reserved.
//

#ifndef GlCommHeader_h
#define GlCommHeader_h

#define kSystemVersion [[UIDevice currentDevice].systemVersion doubleValue]
#define kWeakSelf(type)  __weak typeof(type) weak##type = type;

#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define kTopHeight (kStatusBarHeight + kNavBarHeight)

//！屏幕宽度
#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
//！屏幕高度
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#endif /* GlCommHeader_h */
