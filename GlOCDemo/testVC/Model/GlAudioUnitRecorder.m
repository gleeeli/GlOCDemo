//
//  GlAudioUnitRecorder.m
//  GlOCDemo
//
//  Created by 小柠檬 on 2018/12/20.
//  Copyright © 2018年 小柠檬. All rights reserved.
//

#import "GlAudioUnitRecorder.h"
#import <AudioUnit/AudioUnit.h>
#import <AVFoundation/AVFoundation.h>
#import "XBAudioDataWriter.h"
#import "GlHeader_audio.h"
#import "XBAudioTool.h"

@implementation GlAudioUnitRecorder
{
    AudioUnit audioUnit;
    
    XBAudioDataWriter *dataWriter;
    NSData *data;
    
    Byte *recorderTempBuffer;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        dataWriter = [XBAudioDataWriter new];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        
        NSString *path = [paths objectAtIndex:0];
        self.pcmPath = [path stringByAppendingPathComponent:@"recorder.pcm"];
//        [self delete];
        
        [self initInputAudioUnitWithRate:kDefaultSampleRate bit:16 channel:1];
    }
    
    return self;
}

- (void)start {
    AudioOutputUnitStart(audioUnit);
}

- (void)pause {
    NSLog(@"pause");
    CheckError(AudioOutputUnitStop(audioUnit),
               "AudioOutputUnitStop failed");
}

- (void)stop {
    NSLog(@"stop");
    CheckError(AudioOutputUnitStop(audioUnit),
               "AudioOutputUnitStop failed");
    CheckError(AudioComponentInstanceDispose(audioUnit),
               "AudioComponentInstanceDispose failed");
    
    [self initInputAudioUnitWithRate:kDefaultSampleRate bit:16 channel:1];
}

- (void)reset {
    NSLog(@"reset");
    [self delete];
    
    CheckError(AudioOutputUnitStop(audioUnit),
               "AudioOutputUnitStop failed");
    CheckError(AudioComponentInstanceDispose(audioUnit),
               "AudioComponentInstanceDispose failed");
    [self initInputAudioUnitWithRate:kDefaultSampleRate bit:16 channel:1];
}

- (void)initInputAudioUnitWithRate:(XBVoiceRate)rate bit:(XBVoiceBit)bit channel:(XBVoiceChannel)channel
{
    //设置AVAudioSession
    NSError *error = nil;
    AVAudioSession* session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&error];
    [session setActive:YES error:nil];
    
    //初始化audioUnit 音频单元描述 kAudioUnitSubType_RemoteI
    AudioComponentDescription inputDesc = [XBAudioTool allocAudioComponentDescriptionWithComponentType:kAudioUnitType_Output componentSubType:kAudioUnitSubType_RemoteIO componentFlags:0 componentFlagsMask:0];
    AudioComponent inputComponent = AudioComponentFindNext(NULL, &inputDesc);
    AudioComponentInstanceNew(inputComponent, &audioUnit);
    
    
    //设置输出流格式
    int mFramesPerPacket = 1;
    //    kAudioFormatLinearPCM 设置PCM格式
    AudioStreamBasicDescription inputStreamDesc = [XBAudioTool allocAudioStreamBasicDescriptionWithMFormatID:kAudioFormatLinearPCM mFormatFlags:(kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsNonInterleaved | kAudioFormatFlagIsPacked) mSampleRate:rate mFramesPerPacket:mFramesPerPacket mChannelsPerFrame:channel mBitsPerChannel:bit];
    
    OSStatus status = AudioUnitSetProperty(audioUnit,
                                           kAudioUnitProperty_StreamFormat,
                                           kAudioUnitScope_Output,
                                           kInputBus,
                                           &inputStreamDesc,
                                           sizeof(inputStreamDesc));
    CheckError(status, "setProperty StreamFormat error");
    
    //麦克风输入设置为1（yes）
    int inputEnable = 1;
    status = AudioUnitSetProperty(audioUnit,
                                  kAudioOutputUnitProperty_EnableIO,
                                  kAudioUnitScope_Input,
                                  kInputBus,
                                  &inputEnable,
                                  sizeof(inputEnable));
    CheckError(status, "setProperty EnableIO error");
    
    //设置回调
    AURenderCallbackStruct inputCallBackStruce;
    inputCallBackStruce.inputProc = inputCallBackFun;
    inputCallBackStruce.inputProcRefCon = (__bridge void * _Nullable)(self);
    
    status = AudioUnitSetProperty(audioUnit,
                                  kAudioOutputUnitProperty_SetInputCallback,
                                  kAudioUnitScope_Output,
                                  kInputBus,
                                  &inputCallBackStruce,
                                  sizeof(inputCallBackStruce));
    CheckError(status, "setProperty InputCallback error");
    
    if ([self isAGCOn]) {
        NSLog(@"ACG have open ");
    }else {
        NSLog(@"ready ACG open ");
        [self setAGCOn:YES];
    }
}

-(BOOL)isAGCOn{
    UInt32 agc;
    UInt32 size = sizeof(agc);
    AudioUnitGetProperty(audioUnit,
                         kAUVoiceIOProperty_VoiceProcessingEnableAGC,
                         kAudioUnitScope_Global,
                         0,
                         &agc,
                         &size);
    if (agc==1) {
        return YES;
    }else{
        return NO;
    }
}

-(void)setAGCOn: (BOOL)isOn{
    UInt32 agc;
    if(isOn){
        agc = 1;
    }else{
        agc = 0;
    }
    
//   OSStatus status = AudioUnitSetProperty(audioUnit,
//                         kAUVoiceIOProperty_VoiceProcessingEnableAGC,
//                         kAudioUnitScope_Global,
//                         0,
//                         &agc,
//                         sizeof(agc));
    
//    CheckError(status, "set ACG");
    
//    const UInt32 kInputBus = 1;
    const UInt32 one = 1;
    const UInt32 zero = 0;
    OSStatus status1 = AudioUnitSetProperty(audioUnit, kAUVoiceIOProperty_BypassVoiceProcessing, kAudioUnitScope_Global, kInputBus, &zero, sizeof(zero));
    OSStatus status2 = AudioUnitSetProperty(audioUnit, kAUVoiceIOProperty_VoiceProcessingEnableAGC, kAudioUnitScope_Global, kInputBus, &one, sizeof(one));
    
    NSLog(@"status1：%d,status2：%d",status1,status2);
//    AudioUnitSetProperty(audioUnit, kAUVoiceIOProperty_DuckNonVoiceAudio, kAudioUnitScope_Global, kInputBus, &one, sizeof(one));
}

static OSStatus inputCallBackFun(    void *                            inRefCon,
                                 AudioUnitRenderActionFlags *    ioActionFlags,
                                 const AudioTimeStamp *            inTimeStamp,
                                 UInt32                            inBusNumber,
                                 UInt32                            inNumberFrames,
                                 AudioBufferList * __nullable    ioData)
{
    
    GlAudioUnitRecorder *recorder = (__bridge GlAudioUnitRecorder *)(inRefCon);
    AudioBufferList bufferList;
    bufferList.mNumberBuffers = 1;
    bufferList.mBuffers[0].mData = NULL;
    bufferList.mBuffers[0].mDataByteSize = 0;
    
    AudioUnitRender(recorder->audioUnit,
                    ioActionFlags,
                    inTimeStamp,
                    kInputBus,
                    inNumberFrames,
                    &bufferList);
    
    //    //回调中写 函数
    //    recorder ->recorderTempBuffer = malloc(CONST_BUFFER_SIZE);
    //
    //    typeof(recorder) __weak weakSelf = recorder;
    //    typeof(weakSelf) __strong strongSelf = weakSelf;
    //
    AudioBuffer buffer = bufferList.mBuffers[0];
    int len = buffer.mDataByteSize;
    //    memcpy(strongSelf->recorderTempBuffer, buffer.mData, len);
    
    [recorder->dataWriter writeBytes:buffer.mData len:len toPath:recorder.pcmPath];
    
    return noErr;
}


- (void)delete
{
    NSString *pcmPath = self.pcmPath;
    NSLog(@"音频路径：%@",pcmPath);
    if ([[NSFileManager defaultManager] fileExistsAtPath:pcmPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:pcmPath error:nil];
    }
}
@end
