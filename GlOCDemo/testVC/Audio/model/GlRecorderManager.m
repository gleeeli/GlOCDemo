//
//  GlRecorderManager.m
//  RecorderDemo
//
//  Created by luoluo on 2018/10/15.
//  Copyright © 2018年 luoluo. All rights reserved.
//

#import "GlRecorderManager.h"
#import "lame.h"

@interface GlRecorderManager ()

//@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, strong) NSFileHandle *fileHandle;
@property (nonatomic, strong) NSURL *mp3Url;
@property (nonatomic, assign) BOOL isRecoreding;
@end

@implementation GlRecorderManager
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initBaseInfo];
    }
    return self;
}

- (void)initBaseInfo{
    self.isRecoreding = YES;
    self.receiveData = [[NSMutableArray alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *path = [paths objectAtIndex:0];
    self.filePath = [path stringByAppendingPathComponent:@"recorder.pcm"];
    
    //wav文件的路径
    self.wavPath = [path stringByAppendingPathComponent:@"recorder.wav"];
    
    [self deleteFilePath:self.filePath];
    [self createPath:self.filePath];
    
    NSLog(@"录音文件路径:%@",self.filePath);
    NSError *error = nil;
    //设置audioSession格式 录音播放模式
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    //[[AVAudioSession sharedInstance] setPreferredIOBufferDuration:kAudioSessionOverrideAudioRoute_None error:&error];
    //[[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:&error];
    
    [self setQueueBaseInfo];
}

- (void)setQueueBaseInfo{
    //设置录音的参数
    [self setupAudioFormat:kAudioFormatLinearPCM SampleRate:kDefaultSampleRate];
    _audioFormat.mSampleRate = kDefaultSampleRate;
    //创建一个录制音频队列
    AudioQueueNewInput (&(_audioFormat),GenericInputCallback,(__bridge void *)self,NULL,NULL,0,&_inputQueue);
    
    //创建录制音频队列缓冲区
    for (int i = 0; i < kNumberAudioQueueBuffers; i++) {
        AudioQueueAllocateBuffer (_inputQueue,kDefaultInputBufferSize,&_inputBuffers[i]);
        
        AudioQueueEnqueueBuffer (_inputQueue,(_inputBuffers[i]),0,NULL);
    }
    
    UInt32 val = 1;
    AudioQueueSetProperty(_inputQueue, kAudioQueueProperty_EnableLevelMetering, &val, sizeof(UInt32));
}

- (void)deleteFilePath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:path];
    if (fileExists) {
      NSError *err;
      [fileManager removeItemAtPath:path error:&err];
    }
}

- (void)createPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:path];
    if (!fileExists) {
        [fileManager createFileAtPath:path contents:[NSData data] attributes:nil];
    }
    
}

// 设置录音格式
- (void)setupAudioFormat:(UInt32) inFormatID SampleRate:(int)sampeleRate
{
    //重置下
    memset(&_audioFormat, 0, sizeof(_audioFormat));
    
    //设置采样率，这里先获取系统默认的测试下 //TODO:
    //采样率的意思是每秒需要采集的帧数
    _audioFormat.mSampleRate = sampeleRate;//[[AVAudioSession sharedInstance] sampleRate];
    
    //设置通道数,这里先使用系统的测试下 //TODO:
    _audioFormat.mChannelsPerFrame = kDefaultChannel;
    
    //设置format，怎么称呼不知道。
    _audioFormat.mFormatID = inFormatID;
    
    if (inFormatID == kAudioFormatLinearPCM){
        //这个屌属性不知道干啥的。，
        _audioFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
        //每个通道里，一帧采集的bit数目
        _audioFormat.mBitsPerChannel = kDefaultBitsPerSample;
        //结果分析: 8bit为1byte，即为1个通道里1帧需要采集2byte数据，再*通道数，即为所有通道采集的byte数目。
        //所以这里结果赋值给每帧需要采集的byte数目，然后这里的packet也等于一帧的数据。
        _audioFormat.mBytesPerPacket = _audioFormat.mBytesPerFrame = (_audioFormat.mBitsPerChannel / 8) * _audioFormat.mChannelsPerFrame;
        _audioFormat.mFramesPerPacket = 1;
    }
}

#pragma mark -  录音回调
void GenericInputCallback (
                           void                                *inUserData,
                           AudioQueueRef                       inAQ,
                           AudioQueueBufferRef                 inBuffer,
                           const AudioTimeStamp                *inStartTime,
                           UInt32                              inNumberPackets,
                           const AudioStreamPacketDescription  *inPacketDescs
                           )
{
    GlRecorderManager *manager = (__bridge GlRecorderManager *)(inUserData);
    
    if (inNumberPackets > 0) {
        NSData *aacData = [[NSData alloc] initWithBytes:inBuffer->mAudioData length:inBuffer->mAudioDataByteSize];
       
        if (aacData && aacData.length > 0) {
            [manager receiveRecorderData:aacData];
        }
    }
    AudioQueueEnqueueBuffer (inAQ,inBuffer,0,NULL);
    
}

/**
 收到录音数据
 */
- (void)receiveRecorderData:(NSData *)data {
    //NSLog(@"data:%@",data);
     NSLog(@"aacData长度＝%ld",(unsigned long)data.length);
    if (self.isRecoreding) {
        [self.receiveData addObject:data];
        [self.fileHandle seekToEndOfFile];
        [self.fileHandle writeData:data];
        [self.fileHandle synchronizeFile];
    }
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(receiveNewRecorderData:)]) {
        [self.delegate receiveNewRecorderData:data];
    }
}

- (void)startRecorder {
    self.isRecoreding = YES;
    self.fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:self.filePath];
    
    NSError *error = nil;
    //设置audioSession格式 录音播放模式
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    
    //开启录制队列
    AudioQueueStart(self.inputQueue, NULL);
}

- (void)pauseRecorder {
    NSLog(@"暂停");
    self.isRecoreding = NO;
    [self.fileHandle closeFile];
    AudioQueuePause(_inputQueue);
    [self deleteFilePath:self.wavPath];
    [self createWavPathFileFromPcmData:self.filePath];
    [self todefaultAudioSessionModel];
}

- (void)stopRecorder {
    NSLog(@"停止");
    self.isRecoreding = NO;
    AudioQueueDispose(_inputQueue, YES);
    [self.fileHandle closeFile];
    
    [self deleteFilePath:self.wavPath];
    [self createWavPathFileFromPcmData:self.filePath];
    [self todefaultAudioSessionModel];
}

- (void)resetRecorcer{
    NSLog(@"重置");
    self.isRecoreding = NO;
    AudioQueueFlush(_inputQueue);
    AudioQueueDispose(_inputQueue, YES);
    [self.fileHandle closeFile];
    
    [self.receiveData removeAllObjects];
    [self deleteFilePath:self.filePath];
    [self createPath:self.filePath];
    
    [self deleteFilePath:self.wavPath];
//    AudioQueueReset(_inputQueue);//此处调重置 没法再次激活，不知道为啥
//    AudioQueueStop(_inputQueue, YES);
    
    _inputQueue = nil;
    [self setQueueBaseInfo];
    [self todefaultAudioSessionModel];
}

- (void)todefaultAudioSessionModel{
    NSError *error = nil;
    //设置audioSession格式 录音播放模式
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
}

- (void)createWavPathFileFromPcmData:(NSString *)filePath
{
    NSLog(@"PCM file path : %@",filePath); //pcm文件的路径
    
    FILE *fout;
    
    short NumChannels = kDefaultChannel;       //录音通道数
    short BitsPerSample = kDefaultBitsPerSample;    //线性采样位数
    int SamplingRate = kDefaultSampleRate;     //录音采样率(Hz)
    int numOfSamples = (int)[[NSData dataWithContentsOfFile:filePath] length];
    
    int ByteRate = NumChannels*BitsPerSample*SamplingRate/8;
    short BlockAlign = NumChannels*BitsPerSample/8;
    int DataSize = NumChannels*numOfSamples*BitsPerSample/8;
    int chunkSize = 16;
    int totalSize = 46 + DataSize;
    short audioFormat = 1;
    
    if((fout = fopen([self.wavPath cStringUsingEncoding:1], "w")) == NULL)
    {
        printf("Error opening out file ");
    }
    
    fwrite("RIFF", sizeof(char), 4,fout);
    fwrite(&totalSize, sizeof(int), 1, fout);
    fwrite("WAVE", sizeof(char), 4, fout);
    fwrite("fmt ", sizeof(char), 4, fout);
    fwrite(&chunkSize, sizeof(int),1,fout);
    fwrite(&audioFormat, sizeof(short), 1, fout);
    fwrite(&NumChannels, sizeof(short),1,fout);
    fwrite(&SamplingRate, sizeof(int), 1, fout);
    fwrite(&ByteRate, sizeof(int), 1, fout);
    fwrite(&BlockAlign, sizeof(short), 1, fout);
    fwrite(&BitsPerSample, sizeof(short), 1, fout);
    fwrite("data", sizeof(char), 4, fout);
    fwrite(&DataSize, sizeof(int), 1, fout);
    
    fclose(fout);
    
    NSMutableData *pamdata = [NSMutableData dataWithContentsOfFile:filePath];
    NSFileHandle *handle;
    handle = [NSFileHandle fileHandleForUpdatingAtPath:self.wavPath];
    [handle seekToEndOfFile];
    [handle writeData:pamdata];
    [handle closeFile];
}

- (CGFloat)decibels {
    UInt32 dataSize = sizeof(AudioQueueLevelMeterState) * _audioFormat.mChannelsPerFrame;
    AudioQueueLevelMeterState *levels = (AudioQueueLevelMeterState*)malloc(dataSize);
    
    OSStatus rc = AudioQueueGetProperty(_inputQueue, kAudioQueueProperty_CurrentLevelMeter, levels, &dataSize);
    if (rc) {
        NSLog(@"NoiseLeveMeter>>takeSample - AudioQueueGetProperty(CurrentLevelMeter) returned %d", (int)rc);
    }
    
    float channelAvg = 0;
    for (int i = 0; i < _audioFormat.mChannelsPerFrame; i++) {
        channelAvg += levels[i].mPeakPower;
    }
    free(levels);
    
    // This works because in this particular case one channel always has an mAveragePower of 0.
    return channelAvg;
}

- (BOOL)switchPCMToMp3Path:(NSString *)mp3FilePath {
    NSString *filePath = self.filePath;
    
    NSFileManager *manager = [NSFileManager defaultManager];
    long long l = [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    if (!filePath ||l==0) {
        return NO;
    }
    
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([filePath cStringUsingEncoding:1], "rb");//被转换的文件
        fseek(pcm, 4*1024, SEEK_CUR);
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");//转换后文件的存放位置
        
        int channel = kDefaultChannel;
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*channel];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_num_channels(lame,channel);
        lame_set_in_samplerate(lame, kDefaultSampleRate);//录音16000
        
        lame_set_VBR(lame, vbr_default);//压缩级别参数：
        lame_set_brate(lame,32);/* 比特率 */
        
        lame_set_mode(lame,MONO);
        
        lame_set_quality(lame,2);/* 2=high  5 = medium  7=low */
        
        lame_init_params(lame);
        
        do {
            read = (int)fread(pcm_buffer, channel*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else {
                if (channel == 2) {
                    write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
                }else {//单声道走这
                    write = lame_encode_buffer(lame, pcm_buffer, NULL, read, mp3_buffer, MP3_SIZE);
                }
                
            }
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        lame_mp3_tags_fid(lame, mp3);
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"转码异常：%@",[exception description]);
    }
    @finally {
        
    }
    
    return YES;
}
@end
