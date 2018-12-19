//
//  GlRecorderManager.m
//  RecorderDemo
//
//  Created by luoluo on 2018/10/15.
//  Copyright © 2018年 luoluo. All rights reserved.
//

#import "GlRecorderManager.h"


@interface GlRecorderManager ()

@property (nonatomic, copy) NSString *filePath;
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
    self.wavPath = [NSString stringWithFormat:@"%@",self.filePath];//[path stringByAppendingPathComponent:@"recorder.wav"];
    
    [self deleteFilePath:self.filePath];
    [self createPath:self.filePath];
    self.fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:self.filePath];
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
    
    UInt32 echoCancellation;
    UInt32 size = sizeof(echoCancellation);
    AudioUnitGetProperty(_inputQueue,
                         kAUVoiceIOProperty_BypassVoiceProcessing,
                         kAudioUnitScope_Global,
                         0,
                         &echoCancellation,
                         &size);

    //创建一个录制音频队列
    AudioQueueNewInput (&(_audioFormat),GenericInputCallback,(__bridge void *)self,NULL,NULL,0,&_inputQueue);
    
    //创建录制音频队列缓冲区
    for (int i = 0; i < kNumberAudioQueueBuffers; i++) {
        AudioQueueAllocateBuffer (_inputQueue,kDefaultInputBufferSize,&_inputBuffers[i]);
        
        AudioQueueEnqueueBuffer (_inputQueue,(_inputBuffers[i]),0,NULL);
    }
}

- (void)deleteFilePath:(NSString *)path {
    return;
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
    _audioFormat.mChannelsPerFrame = 1;
    
    //设置format，怎么称呼不知道。
    _audioFormat.mFormatID = inFormatID;
    
    if (inFormatID == kAudioFormatLinearPCM){
        //这个屌属性不知道干啥的。，
        _audioFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
        //每个通道里，一帧采集的bit数目
        _audioFormat.mBitsPerChannel = 16;
        //结果分析: 8bit为1byte，即为1个通道里1帧需要采集2byte数据，再*通道数，即为所有通道采集的byte数目。
        //所以这里结果赋值给每帧需要采集的byte数目，然后这里的packet也等于一帧的数据。
        _audioFormat.mBytesPerPacket = _audioFormat.mBytesPerFrame = (_audioFormat.mBitsPerChannel / 8) * _audioFormat.mChannelsPerFrame;
//        _audioFormat.mBytesPerFrame = 2;
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
     //NSLog(@"aacData长度＝%ld",(unsigned long)data.length);
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
    NSError *error = nil;
    //设置audioSession格式 录音播放模式
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    
    //开启录制队列
    AudioQueueStart(self.inputQueue, NULL);
}

- (void)pauseRecorder {
    NSLog(@"暂停");
    self.isRecoreding = NO;
    AudioQueuePause(_inputQueue);
    //[self deleteFilePath:self.wavPath];
    [self createWavPathFileFromPcmData:self.filePath];
    NSLog(@"创建wav:%@",self.wavPath);
    [self todefaultAudioSessionModel];
}

- (void)stopRecorder {
    NSLog(@"停止");
    self.isRecoreding = NO;
    AudioQueueDispose(_inputQueue, YES);
    [self.fileHandle closeFile];
    
    //[self deleteFilePath:self.wavPath];
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
    
    self.fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:self.filePath];
    
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
    return;
//    convertPcm2Wav([filePath UTF8String], [self.wavPath UTF8String], 1, kDefaultSampleRate);
//    convertPcm2Wav([filePath UTF8String], [self.wavPath UTF8String], 1, kDefaultSampleRate);
    
//    FILE *fout;
//
//    short NumChannels = 1;       //录音通道数
//    short BitsPerSample = 16;    //线性采样位数
//    int SamplingRate = kDefaultSampleRate;     //录音采样率(Hz)
//    int numOfSamples = (int)[[NSData dataWithContentsOfFile:filePath] length];
//
//    int ByteRate = NumChannels*BitsPerSample*SamplingRate/8;
//    short BlockAlign = NumChannels*BitsPerSample/8;
//    int DataSize = NumChannels*numOfSamples*BitsPerSample/8;
//    int chunkSize = 16;
//    int totalSize = 46 + DataSize;
//    short audioFormat = 1;
//
//    if((fout = fopen([self.wavPath cStringUsingEncoding:1], "w")) == NULL)
//    {
//        printf("Error opening out file ");
//    }
//
//    fwrite("RIFF", sizeof(char), 4,fout);
//    fwrite(&totalSize, sizeof(int), 1, fout);
//    fwrite("WAVE", sizeof(char), 4, fout);
//    fwrite("fmt ", sizeof(char), 4, fout);
//    fwrite(&chunkSize, sizeof(int),1,fout);
//    fwrite(&audioFormat, sizeof(short), 1, fout);
//    fwrite(&NumChannels, sizeof(short),1,fout);
//    fwrite(&SamplingRate, sizeof(int), 1, fout);
//    fwrite(&ByteRate, sizeof(int), 1, fout);
//    fwrite(&BlockAlign, sizeof(short), 1, fout);
//    fwrite(&BitsPerSample, sizeof(short), 1, fout);
//    fwrite("data", sizeof(char), 4, fout);
//    fwrite(&DataSize, sizeof(int), 1, fout);
//
//    fclose(fout);
//
//    NSMutableData *pamdata = [NSMutableData dataWithContentsOfFile:filePath];
//    NSFileHandle *handle;
//    handle = [NSFileHandle fileHandleForUpdatingAtPath:self.wavPath];
//    [handle seekToEndOfFile];
//    [handle writeData:pamdata];
//    [handle closeFile];
}

//分贝数
//- (CGFloat)decibels {
//    
//    float   level;                // The linear 0.0 .. 1.0 value we need.
//    float   minDecibels = -60.0f; // Or use -60dB, which I measured in a silent room.
//    /**
//     *  获得指定声道的分贝平均值
//     */
//
//    float   decibels    = ;
//    //    CHLog(@"%f",decibels);
//    if (decibels < minDecibels)
//    {
//        level = -0.0f;
//
//    }
//    else if (decibels >= 0.0f)
//    {
//        level = 1.0f;
//
//    }
//    else
//    {
//        float   root            = 2.0f;
//        float   minAmp          = powf(10.0f, 0.05f * minDecibels);
//        float   inverseAmpRange = 1.0f / (1.0f - minAmp);
//        float   amp             = powf(10.0f, 0.05f * decibels);
//        float   adjAmp          = (amp - minAmp) * inverseAmpRange;
//        level = powf(adjAmp, 1.0f / root);
//
//    }
//    return level * 60.0;
//}


//
////wav头的结构如下所示：
//
//typedef  struct  {
//
//    char        fccID[4];
//
//    int32_t      dwSize;
//
//    char        fccType[4];
//
//} HEADER;
//
//typedef  struct  {
//
//    char        fccID[4];
//
//    int32_t      dwSize;
//
//    int16_t      wFormatTag;
//
//    int16_t      wChannels;
//
//    int32_t      dwSamplesPerSec;
//
//    int32_t      dwAvgBytesPerSec;
//
//    int16_t      wBlockAlign;
//
//    int16_t      uiBitsPerSample;
//
//}FMT;
//
//typedef  struct  {
//
//    char        fccID[4];
//
//    int32_t      dwSize;
//
//}DATA;
//
//int convertPcm2Wav(char *src_file, char *dst_file, int channels, int sample_rate)
//
//{
//
//    int bits = 16;
//
//    //以下是为了建立.wav头而准备的变量
//
//    HEADER  pcmHEADER;
//
//    FMT  pcmFMT;
//
//    DATA  pcmDATA;
//
//    unsigned  short  m_pcmData;
//
//    FILE  *fp,*fpCpy;
//
//    if((fp=fopen(src_file,  "rb"))  ==  NULL) //读取文件
//
//    {
//
//        printf("open pcm file %s error\n", src_file);
//
//        return -1;
//
//    }
//
//    if((fpCpy=fopen(dst_file,  "wb+"))  ==  NULL) //为转换建立一个新文件
//
//    {
//
//        printf("create wav file error\n");
//
//        return -1;
//
//    }
//
//    //以下是创建wav头的HEADER;但.dwsize未定，因为不知道Data的长度。
//
//    strncpy(pcmHEADER.fccID,"RIFF",4);
//
//    strncpy(pcmHEADER.fccType,"WAVE",4);
//
//    fseek(fpCpy,sizeof(HEADER),1); //跳过HEADER的长度，以便下面继续写入wav文件的数据;
//
//    //以上是创建wav头的HEADER;
//
//    if(ferror(fpCpy))
//
//    {
//
//        printf("error\n");
//
//    }
//
//    //以下是创建wav头的FMT;
//
//    pcmFMT.dwSamplesPerSec=sample_rate;
//
//    pcmFMT.dwAvgBytesPerSec=pcmFMT.dwSamplesPerSec*sizeof(m_pcmData);
//
//    pcmFMT.uiBitsPerSample=bits;
//
//    strncpy(pcmFMT.fccID,"fmt  ", 4);
//
//    pcmFMT.dwSize=16;
//
//    pcmFMT.wBlockAlign=2;
//
//    pcmFMT.wChannels=channels;
//
//    pcmFMT.wFormatTag=1;
//
//    //以上是创建wav头的FMT;
//
//    fwrite(&pcmFMT,sizeof(FMT),1,fpCpy); //将FMT写入.wav文件;
//
//    //以下是创建wav头的DATA;  但由于DATA.dwsize未知所以不能写入.wav文件
//
//    strncpy(pcmDATA.fccID,"data", 4);
//
//    pcmDATA.dwSize=0; //给pcmDATA.dwsize  0以便于下面给它赋值
//
//    fseek(fpCpy,sizeof(DATA),1); //跳过DATA的长度，以便以后再写入wav头的DATA;
//
//    fread(&m_pcmData,sizeof(int16_t),1,fp); //从.pcm中读入数据
//
//    while(!feof(fp)) //在.pcm文件结束前将他的数据转化并赋给.wav;
//
//    {
//
//        pcmDATA.dwSize+=2; //计算数据的长度；每读入一个数据，长度就加一；
//
//        fwrite(&m_pcmData,sizeof(int16_t),1,fpCpy); //将数据写入.wav文件;
//
//        fread(&m_pcmData,sizeof(int16_t),1,fp); //从.pcm中读入数据
//
//    }
//
//    fclose(fp); //关闭文件
//
//    pcmHEADER.dwSize = 0;  //根据pcmDATA.dwsize得出pcmHEADER.dwsize的值
//
//    rewind(fpCpy); //将fpCpy变为.wav的头，以便于写入HEADER和DATA;
//
//    fwrite(&pcmHEADER,sizeof(HEADER),1,fpCpy); //写入HEADER
//
//    fseek(fpCpy,sizeof(FMT),1); //跳过FMT,因为FMT已经写入
//
//    fwrite(&pcmDATA,sizeof(DATA),1,fpCpy);  //写入DATA;
//
//    fclose(fpCpy);  //关闭文件
//
//    return 0;
//
//}



// pcm 转wav

//wav头的结构如下所示：

typedef  struct  {
    
    char        fccID[4];
    
    int32_t      dwSize;
    
    char        fccType[4];
    
} HEADER;

typedef  struct  {
    
    char        fccID[4];
    
    int32_t      dwSize;
    
    int16_t      wFormatTag;
    
    int16_t      wChannels;
    
    int32_t      dwSamplesPerSec;
    
    int32_t      dwAvgBytesPerSec;
    
    int16_t      wBlockAlign;
    
    int16_t      uiBitsPerSample;
    
}FMT;

typedef  struct  {
    
    char        fccID[4];
    
    int32_t      dwSize;
    
}DATA;

/*
 int convertPcm2Wav(char *src_file, char *dst_file, int channels, int sample_rate)
 请问这个方法怎么用?参数都是什么意思啊
 
 赞  回复
 code书童： @不吃鸡爪 pcm文件路径，wav文件路径，channels为通道数，手机设备一般是单身道，传1即可，sample_rate为pcm文件的采样率，有44100，16000，8000，具体传什么看你录音时候设置的采样率。
 */

int convertPcm2Wav(char *src_file, char *dst_file, int channels, int sample_rate)

{
    int bits = 16;
    
    //以下是为了建立.wav头而准备的变量
    
    HEADER  pcmHEADER;
    
    FMT  pcmFMT;
    
    DATA  pcmDATA;
    
    unsigned  short  m_pcmData;
    
    FILE  *fp,*fpCpy;
    
    if((fp=fopen(src_file,  "rb"))  ==  NULL) //读取文件
        
    {
        
        printf("open pcm file %s error\n", src_file);
        
        return -1;
        
    }
    
    if((fpCpy=fopen(dst_file,  "wb+"))  ==  NULL) //为转换建立一个新文件
        
    {
        
        printf("create wav file error\n");
        
        return -1;
        
    }
    
    //以下是创建wav头的HEADER;但.dwsize未定，因为不知道Data的长度。
    
    strncpy(pcmHEADER.fccID,"RIFF",4);
    
    strncpy(pcmHEADER.fccType,"WAVE",4);
    
    fseek(fpCpy,sizeof(HEADER),1); //跳过HEADER的长度，以便下面继续写入wav文件的数据;
    
    //以上是创建wav头的HEADER;
    
    if(ferror(fpCpy))
        
    {
        
        printf("error\n");
        
    }
    
    //以下是创建wav头的FMT;
    
    pcmFMT.dwSamplesPerSec=sample_rate;
    
    pcmFMT.dwAvgBytesPerSec=pcmFMT.dwSamplesPerSec*sizeof(m_pcmData);
    
    pcmFMT.uiBitsPerSample=bits;
    
    strncpy(pcmFMT.fccID,"fmt  ", 4);
    
    pcmFMT.dwSize=16;
    
    pcmFMT.wBlockAlign=2;
    
    pcmFMT.wChannels=channels;
    
    pcmFMT.wFormatTag=1;
    
    //以上是创建wav头的FMT;
    
    fwrite(&pcmFMT,sizeof(FMT),1,fpCpy); //将FMT写入.wav文件;
    
    //以下是创建wav头的DATA;  但由于DATA.dwsize未知所以不能写入.wav文件
    
    strncpy(pcmDATA.fccID,"data", 4);
    
    pcmDATA.dwSize=0; //给pcmDATA.dwsize  0以便于下面给它赋值
    
    fseek(fpCpy,sizeof(DATA),1); //跳过DATA的长度，以便以后再写入wav头的DATA;
    
    fread(&m_pcmData,sizeof(int16_t),1,fp); //从.pcm中读入数据
    
    while(!feof(fp)) //在.pcm文件结束前将他的数据转化并赋给.wav;
        
    {
        
        pcmDATA.dwSize+=2; //计算数据的长度；每读入一个数据，长度就加一；
        
        fwrite(&m_pcmData,sizeof(int16_t),1,fpCpy); //将数据写入.wav文件;
        
        fread(&m_pcmData,sizeof(int16_t),1,fp); //从.pcm中读入数据
        
    }
    
    fclose(fp); //关闭文件
    
    pcmHEADER.dwSize = 0;  //根据pcmDATA.dwsize得出pcmHEADER.dwsize的值
    
    rewind(fpCpy); //将fpCpy变为.wav的头，以便于写入HEADER和DATA;
    
    fwrite(&pcmHEADER,sizeof(HEADER),1,fpCpy); //写入HEADER
    
    fseek(fpCpy,sizeof(FMT),1); //跳过FMT,因为FMT已经写入
    
    fwrite(&pcmDATA,sizeof(DATA),1,fpCpy);  //写入DATA;
    
    fclose(fpCpy);  //关闭文件
    
    return 0;
    
}

@end
