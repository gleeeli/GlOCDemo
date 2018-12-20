//
//  TestRecorderViewController.m
//  GlOCDemo
//
//  Created by 小柠檬 on 2018/12/19.
//  Copyright © 2018年 小柠檬. All rights reserved.
//

#import "TestRecorderViewController.h"
#import "lame.h"
//#import "GlRecorderManager.h"
#import "LYPlayer.h"
#import "XJJAudioPlayer.h"
#import "GlAudioUnitRecorder.h"

#define LocalEncMp3Path [NSString stringWithFormat:@"%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]]

@interface TestRecorderViewController ()
//@property (nonatomic, strong) GlRecorderManager *manager;
@property (nonatomic, strong) XJJAudioPlayer *xjjplayer;
@property (nonatomic, strong) GlAudioUnitRecorder *audioUnit;
@end

@implementation TestRecorderViewController
{
    LYPlayer *player;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //self.manager = [[GlRecorderManager alloc] init];
    self.audioUnit = [[GlAudioUnitRecorder alloc] init];
    
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
    
}

- (void)startBtnClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        //[self.manager startRecorder];
        [self.audioUnit start];
    }else {
        //[self.manager pauseRecorder];
        [self.audioUnit pause];
        
        NSString *pcmpath = self.audioUnit.pcmPath;
        
        [self switchTomp3filePath:pcmpath];
    }
    
}

- (void)resetBtnClick:(UIButton *)btn {
    [self.audioUnit reset];
}

- (void)onDecodeStart {
    NSURL *url = [NSURL fileURLWithPath:self.audioUnit.pcmPath];
    
    player = [[LYPlayer alloc] init];
    player.samplerate = kDefaultSampleRate;
    player.url = url;
    //player.delegate = self;
    [player play];
}

- (void)playMp3 {
    NSString *path = [self getmp3path];
    
    self.xjjplayer.wavPath = path;
    __weak typeof(self) weakSelf = self;
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
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    
    NSString * currentTimeString = [formatter stringFromDate:date];
    
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
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_num_channels(lame,1);
        lame_set_in_samplerate(lame, kDefaultSampleRate / 2);//录音16000，这里8000测试则较正确
        
        lame_set_VBR(lame, vbr_default);//压缩级别参数：
        lame_set_brate(lame,8);/* 比特率 */
        
        lame_set_mode(lame,3);
        
        lame_set_quality(lame,2);/* 2=high  5 = medium  7=low */
        
        lame_init_params(lame);
        
        do {
            read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
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
