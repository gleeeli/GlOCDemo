//
//  GlAudioUnitRecorder.h
//  GlOCDemo
//
//  Created by gleeeli on 2018/12/20.
//  Copyright © 2018年 gleeeli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


//#define kDefaultSampleRate 44100

#define kDefaultSampleRate 16000

@interface GlAudioUnitRecorder : NSObject
@property (nonatomic, copy) NSString *pcmPath;
- (void)start;
- (void)pause;
- (void)stop;
- (void)reset;
@end

NS_ASSUME_NONNULL_END
