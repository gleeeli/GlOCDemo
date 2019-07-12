//
//  LYPlayer.h
//  LeanAudioUnit
//
//  Created by loyinglin on 2017/9/13.
//  Copyright © 2017年 loyinglin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LYPlayer;
@protocol LYPlayerDelegate <NSObject>

- (void)onPlayToEnd:(LYPlayer *)player;

@end


@interface LYPlayer : NSObject
@property (nonatomic, assign) NSInteger samplerate;
@property (nonatomic, assign) NSInteger nb_samples;//每个packet包含帧的数量
@property (nonatomic, assign) NSInteger channel;//通道数
@property (nonatomic, assign) NSInteger mBitsPerChannel;//每个采样数据的位数
@property (nonatomic, assign) NSString *formatFlags;//int16 float32
//Big-Endian,Little-Endian采用大端方式进行数据存放符合人类的正常思维，而采用小端方式进行数据存放利于计算机处理
@property (nonatomic, assign) BOOL isBigEndian;//是否大端  高字节在低地址, 低字节在高地址
@property (nonatomic, copy) NSURL *url;
@property (nonatomic, weak) id<LYPlayerDelegate> delegate;

- (instancetype)initWithUrl:(NSURL *)url;

- (void)play;

- (double)getCurrentTime;

@end
