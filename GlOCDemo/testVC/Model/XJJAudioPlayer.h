//
//  XJJAudioPlayer.h
//  youyue_ios
//
//  Created by Boyue on 2018/4/16.
//  Copyright © 2018年 boyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
typedef void(^PassPlayer)(AVAudioPlayer *audioPlayer);
@interface XJJAudioPlayer : NSObject
@property (nonatomic,strong)AVAudioPlayer *audioPlayer;
@property (nonatomic,strong)NSString *wavPath;
@property (nonatomic,strong)CADisplayLink *link;
//播放录音
-(void)playsoundBlock:(PassPlayer)passPlayer;
//暂停播放录音
-(void)pausePlayBlock:(PassPlayer)passPlayer;
//停止播放
- (void)stopPlaysound;
//试听结速以后按钮的变化
- (void)audioWorkAuditionEndProcessBlock:(PassPlayer)passPlayer;
@end
