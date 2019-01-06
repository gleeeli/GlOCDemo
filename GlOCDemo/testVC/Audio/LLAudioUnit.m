//
//  LLAudioUnit.m
//  LLChatClient
//
//  Created by luo luo on 29/08/2017.
//  Copyright © 2017 luo luo. All rights reserved.
//

#import "LLAudioUnit.h"
#import <AVFoundation/AVFoundation.h>
//#import "LLAudioQueuePlayer.h"

// Audio Unit Set Property
#define INPUT_BUS  1      ///< A I/O unit's bus 1 connects to input hardware (microphone).
#define OUTPUT_BUS 0      ///< A I/O unit's bus 0 connects to output hardware (speaker).

#define kXDXRecoderAACFramesPerPacket       1024            //在AAC格式下需要将mFramesPerPacket设置为1024才会开始转换
#define kXDXRecoderAudioBytesPerPacket      2

#define kXDXRecoderPCMFramesPerPacket       1
#define kXDXAudioSampleRate                 48000.0
#define kXDXRecoderConverterEncodeBitRate   64000 //码率和采样率对应
#define kTVURecoderPCMMaxBuffSize           2048 //1024帧X2(字节/帧：由采样精度16bit决定)

AudioConverterRef               _encodeConvertRef = NULL;   ///< convert param
//目标格式
AudioStreamBasicDescription     _targetDes;

static int          pcm_buffer_size = 0;
static uint8_t      pcm_buffer[kTVURecoderPCMMaxBuffSize*2];//存采集到的pcm数据

OSStatus encodeConverterComplexInputDataProc(AudioConverterRef              inAudioConverter,
                                             UInt32                         *ioNumberDataPackets,
                                             AudioBufferList                *ioData,
                                             AudioStreamPacketDescription   **outDataPacketDescription,
                                             void                           *inUserData) {
    
    ioData->mBuffers[0].mData           = inUserData;
    ioData->mBuffers[0].mNumberChannels = _targetDes.mChannelsPerFrame;
    ioData->mBuffers[0].mDataByteSize   = kXDXRecoderAACFramesPerPacket * kXDXRecoderAudioBytesPerPacket * _targetDes.mChannelsPerFrame;
    
    return 0;
}

#pragma mark 回调
//采集完成回调方法
static OSStatus RecordCallback(void *inRefCon,
                               AudioUnitRenderActionFlags *ioActionFlags,
                               const AudioTimeStamp *inTimeStamp,
                               UInt32 inBusNumber,
                               UInt32 inNumberFrames,
                               AudioBufferList *ioData) {
    /*
     注意：如果采集的数据是PCM需要将dataFormat.mFramesPerPacket设置为1，而本例中最终要的数据为AAC,因为本例中使用的转换器只有每次传入1024帧才能开始工作,所以在AAC格式下需要将mFramesPerPacket设置为1024.也就是采集到的inNumPackets为1，在转换器中传入的inNumPackets应该为AAC格式下默认的1，在此后写入文件中也应该传的是转换好的inNumPackets,如果有特殊需求需要将采集的数据量小于1024,那么需要将每次捕捉到的数据先预先存储在一个buffer中,等到攒够1024帧再进行转换。
     */
    
    LLAudioUnit *recorder = (__bridge LLAudioUnit *)inRefCon;
    // 将回调数据传给_buffList
    AudioUnitRender(recorder->_audioUnit, ioActionFlags, inTimeStamp, inBusNumber, inNumberFrames, recorder->_buffList);
    
    void    *bufferData = recorder->_buffList->mBuffers[0].mData;
    UInt32   bufferSize = recorder->_buffList->mBuffers[0].mDataByteSize;
        printf("Audio Recoder get pcm dataSize : %d \n",bufferSize);
   
    
    // 由于PCM转成AAC的转换器每次需要有1024个采样点（每一帧2个字节）才能完成一次转换，所以每次需要2048大小的数据，这里定义的pcm_buffer用来累加每次存储的bufferData
//    memcpy(pcm_buffer+pcm_buffer_size, bufferData, bufferSize);
//    pcm_buffer_size = pcm_buffer_size + bufferSize;
    
    
//    if(pcm_buffer_size >= kTVURecoderPCMMaxBuffSize) {
//
//        [NSData dataWithBytes:pcm_buffer length:bufferSize];
//
//        //1024的数据转aac
////        AudioBufferList *bufferList = convertPcmToAAcPCMdata(pcm_buffer);
////        NSMutableData *aacData = [NSMutableData new];
////        for (int i= 0; i<bufferList->mNumberBuffers; i++) {
////            [aacData appendData:[NSData dataWithBytes:bufferList->mBuffers[i].mData length:bufferList->mBuffers[i].mDataByteSize]];
////        }
//        //测试播放
////        LLAudioQueuePlayer *player = [LLAudioQueuePlayer sharedInstance];
////        [player.receiveData addObject:aacData];
//        //@end
//
//
//        //NSLog(@"aac dataSize:%d",(int)aacData.length);
//        // 因为采样不可能每次都精准的采集到1024个样点，所以如果大于2048大小就先填满2048，剩下的跟着下一次采集一起送给转换器
//        memcpy(pcm_buffer, pcm_buffer + kTVURecoderPCMMaxBuffSize, pcm_buffer_size - kTVURecoderPCMMaxBuffSize);
//        pcm_buffer_size = pcm_buffer_size - kTVURecoderPCMMaxBuffSize;
//        // free memory
////        if(bufferList) {
////            free(bufferList->mBuffers[0].mData);
////            free(bufferList);
////        }
//    }
    return noErr;
}




@implementation LLAudioUnit
@synthesize isRunning;

+ (instancetype)sharedInstance {
    static LLAudioUnit *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LLAudioUnit alloc] init];
        [manager registerAll];
    });
    
    return manager;
}

//配置和初始化转码和录音
-(void)registerAll
{
    isRunning = NO;
//    [self configureAudio];//会话信息配置
    [self initAudioComponent];
    [self setAudioUnitPropertyAndFormat];
    [self initBuffer];
    
    [self initRecordeCallback];
    OSStatus status = AudioUnitInitialize(_audioUnit);
    if (status != noErr) {
     NSLog(@"Audio Recoder couldn't initialize AURemoteIO instance, status : %d \n",status);
    }
   
}

//基本信息配置
- (void)initAudioComponent {
    OSStatus status;
    // 配置AudioUnit基本信息
    AudioComponentDescription audioDesc;
    audioDesc.componentType         = kAudioUnitType_Output;
    // 如果你的应用程序需要去除回声将componentSubType设置为kAudioUnitSubType_VoiceProcessingIO
    audioDesc.componentSubType      = kAudioUnitSubType_VoiceProcessingIO;//kAudioUnitSubType_VoiceProcessingIO;
    //厂商
    audioDesc.componentManufacturer = kAudioUnitManufacturer_Apple;
    audioDesc.componentFlags        = 0;
    audioDesc.componentFlagsMask    = 0;
    //根据描述找出实际的AudioUnit类型
    AudioComponent inputComponent = AudioComponentFindNext(NULL, &audioDesc);
    //创建并添加一个引用
    status = AudioComponentInstanceNew(inputComponent, &_audioUnit);
    if (status != noErr)  {
        _audioUnit = NULL;
        //        log4cplus_info("Audio Recoder", "couldn't create a new instance of AURemoteIO, status : %d \n",status);
    }
    
    
}

// 因为本例只做录音功能，未实现播放功能，所以没有设置播放相关设置。
- (void)setAudioUnitPropertyAndFormat {
    OSStatus status;
    [self setUpRecoderWithFormatID:kAudioFormatLinearPCM];
    
    //将格式设置给Unit
    status = AudioUnitSetProperty(_audioUnit,
                                  kAudioUnitProperty_StreamFormat,
                                  kAudioUnitScope_Output,
                                  INPUT_BUS,
                                  &dataFormat,
                                  sizeof(dataFormat));
    if (status != noErr) {
        //        log4cplus_info("Audio Recoder", "couldn't set the input client format on AURemoteIO, status : %d \n",status);
    }
    // 去除回声开关
    UInt32 echoCancellation;
    AudioUnitSetProperty(_audioUnit,
                         kAUVoiceIOProperty_BypassVoiceProcessing,
                         kAudioUnitScope_Global,
                         0,
                         &echoCancellation,
                         sizeof(echoCancellation));
    
    // AudioUnit输入端默认是关闭，需要将他打开 即设置IO口1连接到麦克风
    UInt32 flag = 1;
    status      = AudioUnitSetProperty(_audioUnit,
                                       kAudioOutputUnitProperty_EnableIO,
                                       kAudioUnitScope_Input,
                                       INPUT_BUS,//Element1连接到麦克风
                                       &flag,
                                       sizeof(flag));
    if (status != noErr) {
         NSLog(@"Audio Recoder could not enable input on AURemoteIO, status : %d \n",status);
    }
}

-(void)setUpRecoderWithFormatID:(UInt32)formatID {
    // Notice : The settings here are official recommended settings,can be changed according to specific requirements. 此处的设置为官方推荐设置,可根据具体需求修改部分设置
    //setup auido sample rate, channel number, and format ID
    memset(&dataFormat, 0, sizeof(dataFormat));
    
    UInt32 size = sizeof(dataFormat.mSampleRate);
    AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareSampleRate,
                            &size,
                            &dataFormat.mSampleRate);
    dataFormat.mSampleRate = kXDXAudioSampleRate;
    
    size = sizeof(dataFormat.mChannelsPerFrame);
    AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareInputNumberChannels,
                            &size,
                            &dataFormat.mChannelsPerFrame);
    dataFormat.mFormatID = formatID;
    dataFormat.mChannelsPerFrame = 1;
    
    if (formatID == kAudioFormatLinearPCM) {
       //声音格式是用int类型存储的 目前左右声道是交错存在mBuffers[0] 如果不需要交错请设置kAudioFormatFlagIsNonInterleaved
        dataFormat.mFormatFlags     = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
        
        //每个采样点使用2个字节*8bit存储 即SInt16
        dataFormat.mBitsPerChannel  = 16;
        //目前左右通道未分开 所以需要使用乘以通道数  类型用Byte
        dataFormat.mBytesPerPacket  = dataFormat.mBytesPerFrame = (dataFormat.mBitsPerChannel / 8) * dataFormat.mChannelsPerFrame;
        dataFormat.mFramesPerPacket = kXDXRecoderPCMFramesPerPacket; // 用AudioQueue采集pcm需要这么设置
    }
}


- (void)initBuffer {
    // 禁用AudioUnit默认的buffer而使用我们自己写的全局BUFFER,用来接收每次采集的PCM数据，Disable AU buffer allocation for the recorder, we allocate our own.
    UInt32 flag     = 0;
    OSStatus status = AudioUnitSetProperty(_audioUnit,
                                           kAudioUnitProperty_ShouldAllocateBuffer,
                                           kAudioUnitScope_Output,
                                           INPUT_BUS,
                                           &flag,
                                           sizeof(flag));
    if (status != noErr) {
        //        log4cplus_info("Audio Recoder", "couldn't AllocateBuffer of AudioUnitCallBack, status : %d \n",status);
    }
    _buffList = (AudioBufferList*)malloc(sizeof(AudioBufferList));
    _buffList->mNumberBuffers               = 1;
    _buffList->mBuffers[0].mNumberChannels  = dataFormat.mChannelsPerFrame;
    _buffList->mBuffers[0].mDataByteSize    = kTVURecoderPCMMaxBuffSize * sizeof(short);
    _buffList->mBuffers[0].mData            = (short *)malloc(sizeof(short) * kTVURecoderPCMMaxBuffSize);
}

#pragma mark 采集回调
- (void)initRecordeCallback {
    // 设置回调，有两种方式，一种是采集pcm的BUFFER使用系统回调中的参数，另一种是使用我们自己的，本例中使用的是自己的，所以回调中的ioData为空。如果想要使用回调中的请看博客另一种设置方法。
    AURenderCallbackStruct recordCallback;
    recordCallback.inputProc        = RecordCallback;
    recordCallback.inputProcRefCon  = (__bridge void *)self;
    OSStatus status                 = AudioUnitSetProperty(_audioUnit,
                                                           kAudioOutputUnitProperty_SetInputCallback,
                                                           kAudioUnitScope_Global,
                                                           INPUT_BUS,
                                                           &recordCallback,
                                                           sizeof(recordCallback));
    
    if (status != noErr) {
        //        log4cplus_info("Audio Recoder", "Audio Unit set record Callback failed, status : %d \n",status);
    }
}

#pragma mark 开始录制
- (void)startAudioUnitRecorder {
    
   
    if (isRunning) {
                NSLog(@"Audio Recoder Start recorder repeat \n");
        return;
    }
    
    [self initGlobalVar];
    OSStatus status;
    status = AudioOutputUnitStart(_audioUnit);
    if (status == noErr) {
        isRunning  = YES;
    }else{
        NSLog(@"开始录制出错code:%d",status);
    }
}

- (void)initGlobalVar {
    // 初始化pcm_buffer，pcm_buffer是存储每次捕获的PCM数据，因为PCM若要转成AAC需要攒够2048个字节给转换器才能完成一次转换，Reset pcm_buffer to save convert handle
    memset(pcm_buffer, 0, pcm_buffer_size);
    pcm_buffer_size = 0;
}

#pragma mark 通知
-(void)audioRouteChanged:(NSNotification *)noti
{
    NSLog(@"dddd");
}


#pragma mark 其它
//配置音频相关
-(void)configureAudioSession
{
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    BOOL success;
    NSError* error;
    
     success =  [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&error];
        [audioSession setPreferredIOBufferDuration:0.01 error:&error]; // 10ms采集一次
        [audioSession setPreferredSampleRate:kXDXAudioSampleRate error:&error];  // 需和XDXRecorder中对应
    
    
    
    //set USB AUDIO device as high priority: iRig mic HD
    for (AVAudioSessionPortDescription *inputPort in [audioSession availableInputs])
    {
        if([inputPort.portType isEqualToString:AVAudioSessionPortUSBAudio])
        {
            [audioSession setPreferredInput:inputPort error:&error];
            //log4cplus_error("aac", "setPreferredInput status:%s\n", error.debugDescription.UTF8String);
            [audioSession setPreferredInputNumberOfChannels:2 error:&error];
            //log4cplus_error("aac", "setPreferredInputNumberOfChannels status:%s\n", error.debugDescription.UTF8String);
            break;
        }
    }
    
   
    
    if(!success)
        NSLog(@"AVAudioSession error setCategory = %@",error.debugDescription);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChanged:) name:AVAudioSessionRouteChangeNotification object:nil];
    
    success = [audioSession setActive:YES error:&error];
    
    //Restrore default audio output to BuildinReceiver
//    AVAudioSessionRouteDescription *currentRoute = [[AVAudioSession sharedInstance] currentRoute];
//    for (AVAudioSessionPortDescription *portDesc in [currentRoute outputs])
//    {
//        if([portDesc.portType isEqualToString:AVAudioSessionPortBuiltInReceiver])
//        {
//            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
//            break;
//        }
//    }
    
}

- (void)pauseAudioUnitRecorder {
    [self stopAudioUnitRecorder];
}

-(void)stopAudioUnitRecorder {
    if (isRunning == NO) {
                NSLog(@"Audio Recoder Stop recorder repeat \n");
        return;
    }
    isRunning = NO;
    OSStatus status = AudioOutputUnitStop(_audioUnit);
    if (status != noErr){
                NSLog(@"Audio Recoder stop AudioUnit failed. \n");
    }
}

@end
