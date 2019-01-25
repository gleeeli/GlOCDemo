//
//  GlRecorderFactory.h
//  GlOCDemo
//
//  Created by 小柠檬 on 2019/1/8.
//  Copyright © 2019年 小柠檬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlRecorderManager.h"
typedef enum : NSUInteger {
    GlRecorderAV = 0,
    GlRecorderQueue,
    GlRecorderAudioUnit,
} GlRecorderType;
NS_ASSUME_NONNULL_BEGIN

@interface GlRecorderFactory : NSObject
- (instancetype)initWithType:(GlRecorderType)type;

- (void)reset;
- (void)start;
- (void)pause;

- (NSString *)getPCMPath;

- (BOOL)switchPCMToMp3Path:(NSString *)mp3FilePath;
@end

NS_ASSUME_NONNULL_END
