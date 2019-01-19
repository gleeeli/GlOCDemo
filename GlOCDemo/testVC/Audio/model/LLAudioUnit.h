//
//  LLAudioUnit.h
//  LLChatClient
//
//  Created by luo luo on 29/08/2017.
//  Copyright © 2017 luo luo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>


@interface LLAudioUnit : NSObject{
   
    
@public
    //录制的格式信息
    AudioStreamBasicDescription     dataFormat;
    
    AudioUnit                        _audioUnit;
    AudioBufferList                 *_buffList;//录制的pcm数据列表
}

@property (readonly)  BOOL      isRunning;
//@property(nonatomic,strong)NSMutableData  *receveData;

+ (instancetype)sharedInstance ;
//配置音频相关
-(void)configureAudioSession;
//开始录音
- (void)startAudioUnitRecorder;
//停止录音
-(void)stopAudioUnitRecorder;

- (void)pauseAudioUnitRecorder;
@end
