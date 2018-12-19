//
//  XJJAudioPlayer.m
//  youyue_ios
//
//  Created by Boyue on 2018/4/16.
//  Copyright © 2018年 boyue. All rights reserved.
//

#import "XJJAudioPlayer.h"

@implementation XJJAudioPlayer

-(void)audioPlayerplay
{
    
    NSError* error=nil;
    NSURL *url=nil;;
    if (_wavPath) {
        NSFileManager* f = [NSFileManager defaultManager];
        long long l = [[f attributesOfItemAtPath:_wavPath error:nil] fileSize];
        if (l == 0) {
            [self.link setPaused:YES];
            NSLog(@"player error");
            return;
        }
        
        url = [NSURL fileURLWithPath:_wavPath];
        
    }
    _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    _audioPlayer.numberOfLoops = 0;
    
    _audioPlayer.enableRate = YES;
    _audioPlayer.rate = 1.0;
    _audioPlayer.meteringEnabled = YES;
    
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
    
}


//播放录音
-(void)playsoundBlock:(PassPlayer)passPlayer
{
    [self audioPlayerplay];
    passPlayer(_audioPlayer);
}

//暂停播放录音
-(void)pausePlayBlock:(PassPlayer)passPlayer
{
    if ([_audioPlayer isPlaying]) {
        [_audioPlayer pause];
        passPlayer(_audioPlayer);
    }
}

//停止播放
- (void)stopPlaysound{
    
    if (_audioPlayer) {
        [_audioPlayer stop];
        
    }
    
}

//试听结速以后按钮的变化

- (void)audioWorkAuditionEndProcessBlock:(PassPlayer)passPlayer
{
    passPlayer(_audioPlayer);
    [self stopPlaysound];
}


@end
