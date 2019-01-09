//
//  GlRecorderManager.h
//  RecorderDemo
//
//  Created by luoluo on 2018/10/15.
//  Copyright © 2018年 luoluo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "lame.h"
/**
 *  缓存区的个数，一般3个
 */
#define kNumberAudioQueueBuffers 3

/**
 *  采样率，要转码为amr的话必须为8000
 */
#define kDefaultSampleRate 16000//16000

/**
 通道数
 */
#define kDefaultChannel 1

/**
 线性采样位数
 */
#define kDefaultBitsPerSample 16

#define kDefaultInputBufferSize 7360   //2000

@protocol GlRecorderDelegate <NSObject>
@optional
- (void)receiveNewRecorderData:(NSData *)data;

@end

NS_ASSUME_NONNULL_BEGIN

@interface GlRecorderManager : NSObject
{
    AudioQueueRef                   _inputQueue;
    AudioQueueRef                   _outputQueue;
    AudioStreamBasicDescription     _audioFormat;
    
    AudioQueueBufferRef     _inputBuffers[kNumberAudioQueueBuffers];
    AudioQueueBufferRef     _outputBuffers[kNumberAudioQueueBuffers];
}

@property (assign, nonatomic) AudioQueueRef                 inputQueue;
@property(nonatomic,strong) NSMutableArray *receiveData;//接收录音数据的数组
@property (nonatomic, copy) NSString *wavPath;
@property (nonatomic, weak, nullable) id <GlRecorderDelegate> delegate;

/**
 收到录音数据
 */
- (void)receiveRecorderData:(NSData *)data;

- (void)startRecorder;

- (void)pauseRecorder;

- (void)stopRecorder;

- (void)resetRecorcer;


@end



NS_ASSUME_NONNULL_END
