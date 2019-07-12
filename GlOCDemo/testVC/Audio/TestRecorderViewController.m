//
//  TestRecorderViewController.m
//  GlOCDemo
//
//  Created by gleeeli on 2018/12/19.
//  Copyright © 2018年 gleeeli. All rights reserved.
//

#import "TestRecorderViewController.h"
#import "lame.h"
#import "LYPlayer.h"
#import "XJJAudioPlayer.h"
#import "GlRecorderFactory.h"


#define LocalEncMp3Path [NSString stringWithFormat:@"%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]]

#define mp3rate 32

@interface TestRecorderViewController ()

@property (nonatomic, strong) XJJAudioPlayer *xjjplayer;
@property (nonatomic, strong) GlRecorderFactory *factory;
@end

@implementation TestRecorderViewController
{
    LYPlayer *player;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.factory = [[GlRecorderFactory alloc] initWithType:GlRecorderQueue];
    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"recorder44100" ofType:@"wav"];
//    [self switchTomp3filePath:filePath];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 150, 100, 50)];
    [btn setTitle:@"start" forState:UIControlStateNormal];
    [btn setTitle:@"pause" forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(startBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    CGFloat resetX = CGRectGetMaxX(btn.frame) + 50;
    UIButton *resetbtn = [[UIButton alloc] initWithFrame:CGRectMake(resetX, 150, 100, 50)];
    [resetbtn setTitle:@"reset" forState:UIControlStateNormal];
    [resetbtn addTarget:self action:@selector(resetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resetbtn];
    
    UIButton *pbtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 250, 100, 50)];
    [pbtn setTitle:@"play pcm" forState:UIControlStateNormal];
    [pbtn setTitle:@"pause pcm" forState:UIControlStateSelected];
    [pbtn addTarget:self action:@selector(onDecodeStart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pbtn];
    
    UIButton *mp3btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 350, 100, 50)];
    [mp3btn setTitle:@"play mp3" forState:UIControlStateNormal];
    [mp3btn setTitle:@"pause mp3" forState:UIControlStateSelected];
    [mp3btn addTarget:self action:@selector(playMp3) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mp3btn];
    
//    [self switchPCMToMp3Path];
    
//    NSString *pcmpath = [self.factory getPCMPath];
//    [self switchTomp3filePath:pcmpath];
    
//    [self test];
}

- (void)test {
    NSString *tomp3 = [self getmp3path];
    [self.factory switchPCMToMp3Path:tomp3];
    NSLog(@"转换mp3完成：%@",tomp3);
}

- (void)startBtnClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self.factory start];
    }else {
        [self.factory pause];
        
        NSString *pcmpath = [self.factory getPCMPath];
        [self switchTomp3filePath:pcmpath];
    }
}

- (void)resetBtnClick:(UIButton *)btn {
    [self.factory reset];
}

/*
 [mp3 @ 0x7fbf6880d800] Estimating duration from bitrate, this may be inaccurate
 Input #0, mp3, from 'test3.mp2':
 Duration: 00:02:51.68, start: 0.000000, bitrate: 384 kb/s
 Stream #0:0: Audio: mp2, 44100 Hz, stereo, fltp, 384 kb/s
 [FORMAT]
 filename=test3.mp2
 nb_streams=1
 nb_programs=0
 format_name=mp3
 format_long_name=MP2/3 (MPEG audio layer 2/3)
 start_time=0.000000
 duration=171.676729
 size=8240483
 bit_rate=384000
 probe_score=51
 [/FORMAT]
 */

- (void)onDecodeStart {
    
    //播放pcm必要条件：采样格式 通道数 采样率 大端还是小端
    
    //播放自己的录音的默认参数
    NSInteger samplerate = kDefaultSampleRate;
    NSInteger nb_samples = 1;//每个包多少帧，目前测试这个为1时 必须配合声道数要对
    NSInteger channgel =1;
    NSInteger fmt_bites = 16;//每个采样数据的字节数
    NSString *fmt_flags = @"int16";
    
    NSString *pcmPath = @"audioPcm";
    
    /*文件一*/
    samplerate = 44100;
    channgel = 2;
    nb_samples = 1;
    //使用命令行播放测试正常：ffplay -f s16le -ac 2 -ar 44100 audioMp2ToPcm.pcm
    pcmPath = @"audioMp2ToPcm";//Audio: mp2, 44100 Hz, stereo, fltp pcm参数：nb_samples:1152 sample_fmt:6 channels:2 sample_rate：44100 AV_SAMPLE_FMT_S16P
//    pcmPath = @"recorder_normal_44100_mono";
    
    /*文件二*/
    //参数：参数：nb_samples:2048 sample_fmt:8 channels:2 sample_rate：48000   linesize0:8192 linesize1:0 channels:2 AV_SAMPLE_FMT_FLT
    //使用命令行播放测试正常：ffplay -f f32le -ac 2 -ar 48000 movie_audioPcm.pcm
    samplerate = 48000;
    channgel = 2;
    nb_samples = 1;
    fmt_bites = 32;
    fmt_flags = @"float32";
    pcmPath = @"movie_audioPcm";
    
    NSString *pcmfilePath = [[NSBundle mainBundle] pathForResource:pcmPath ofType:@"pcm"];
    
    NSURL *url = [NSURL fileURLWithPath:pcmfilePath];
//    NSURL *url = [NSURL fileURLWithPath:[self.factory getPCMPath]];
    
    player = [[LYPlayer alloc] init];
    player.samplerate = samplerate;
    player.nb_samples = nb_samples;//播放pcm 这个得设置，默认1
    player.mBitsPerChannel = fmt_bites;//位深
    player.channel = channgel;//通道
    player.formatFlags = fmt_flags;
    player.url = url;
    player.isBigEndian = NO;
    //player.delegate = self;
    [player play];
}

- (void)playMp3 {
    NSString *path = [self getmp3path];
    
    self.xjjplayer.wavPath = path;
    //__weak typeof(self) weakSelf = self;
    [self.xjjplayer playsoundBlock:^(AVAudioPlayer *audioPlayer) {
        
        
        //weakSelf.xjjplayer.audioPlayer.delegate = self;
    }];
}

- (XJJAudioPlayer *)xjjplayer {
    if (!_xjjplayer) {
        _xjjplayer = [[XJJAudioPlayer alloc]init];
    }
    return _xjjplayer;
}

- (NSString *)getmp3path {
    NSString *mp3FilePath = LocalEncMp3Path;
    mp3FilePath = [mp3FilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",@"recorder"]];
    return mp3FilePath;
}

//将录音文件转换为mp3
-(NSString *)switchTomp3filePath:(NSString *)filePath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    long long l = [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    if (!filePath ||l==0) {
        return nil;
    }

    NSFileManager *fm  = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:LocalEncMp3Path]) {
        [fm createDirectoryAtPath:LocalEncMp3Path withIntermediateDirectories:YES attributes:nil error:nil];
    }

    NSString *mp3FilePath = mp3FilePath = [self getmp3path];
    @try {
        int read, write;

        FILE *pcm = fopen([filePath cStringUsingEncoding:1], "rb");//被转换的文件
        fseek(pcm, 4*1024, SEEK_CUR);
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");//转换后文件的存放位置
        int channel = 1;
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*channel];
        unsigned char mp3_buffer[MP3_SIZE];

        lame_t lame = lame_init();
        lame_set_num_channels(lame,channel);
        lame_set_in_samplerate(lame, kDefaultSampleRate);

//        lame_set_VBR(lame, vbr_default);//压缩级别参数：
        lame_set_VBR_mean_bitrate_kbps(lame, 24);
        lame_set_brate(lame,mp3rate);/* 比特率 */

        lame_set_mode(lame,MONO);

        lame_set_quality(lame,2);/* 2=high  5 = medium  7=low */

        lame_init_params(lame);

        do {
            read = (int)fread(pcm_buffer, channel*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else{
                if (channel == 2) {
                    write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
                }else {
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
        NSLog(@"%@",[exception description]);
    }
    @finally {
        long long l1  = [[ manager attributesOfItemAtPath:filePath error:nil] fileSize];
        long long l2  = [[ manager attributesOfItemAtPath:mp3FilePath error:nil] fileSize];
        //
        NSLog(@"%@转换前＝%lld,%@转换MP3后＝%lld",filePath,l1,mp3FilePath,l2);

    }
    NSLog(@"mp3:%@",mp3FilePath);
    return mp3FilePath;
}
@end
