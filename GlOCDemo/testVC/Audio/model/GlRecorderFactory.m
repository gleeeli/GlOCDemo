//
//  GlRecorderFactory.m
//  GlOCDemo
//
//  Created by 小柠檬 on 2019/1/8.
//  Copyright © 2019年 小柠檬. All rights reserved.
//

#import "GlRecorderFactory.h"
#import "GlAudioUnitRecorder.h"

@interface GlRecorderFactory()
@property (nonatomic, assign) GlRecorderType type;
@property (nonatomic, strong) GlRecorderManager *manager;
@property (nonatomic, strong) GlAudioUnitRecorder *audioUnit;
@end

@implementation GlRecorderFactory
- (instancetype)initWithType:(GlRecorderType)type
{
    self = [super init];
    if (self) {
        self.type = type;
        [self initBase];
    }
    
    return self;
}

- (void)initBase {
    switch (self.type) {
        case GlRecorderQueue:{
            self.manager = [[GlRecorderManager alloc] init];
        }
            break;
        case GlRecorderAudioUnit:{
            self.audioUnit = [[GlAudioUnitRecorder alloc] init];
        }
            break;
            
        default:
            break;
    }
}

- (void)start {
    switch (self.type) {
        case GlRecorderQueue:{
            [self.manager startRecorder];
        }
            break;
        case GlRecorderAudioUnit:{
            [self.audioUnit start];
        }
            break;
            
        default:
            break;
    }
}

- (void)pause {
    switch (self.type) {
        case GlRecorderQueue:{
            [self.manager pauseRecorder];
        }
            break;
        case GlRecorderAudioUnit:{
            [self.audioUnit pause];
        }
            break;
            
        default:
            break;
    }
}

- (void)reset {
    switch (self.type) {
        case GlRecorderQueue:{
            [self.manager resetRecorcer];
        }
            break;
        case GlRecorderAudioUnit:{
            [self.audioUnit reset];
        }
            break;
            
        default:
            break;
    }
}

- (NSString *)getPCMPath {
    switch (self.type) {
        case GlRecorderQueue:{
            return self.manager.wavPath;
        }
            break;
        case GlRecorderAudioUnit:{
            return self.audioUnit.pcmPath;
        }
            break;
            
        default:
            break;
    }
    return nil;
}

- (BOOL)switchPCMToMp3Path:(NSString *)mp3FilePath {
    switch (self.type) {
        case GlRecorderQueue:{
            return [self.manager switchPCMToMp3Path:mp3FilePath];
        }
            break;
        case GlRecorderAudioUnit:{
            
        }
            break;
            
        default:
            break;
    }
    return NO;
}
@end
