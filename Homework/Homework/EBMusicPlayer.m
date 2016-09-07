//
//  EBMusicPlayer.m
//  Homework
//
//  Created by GK on 9/6/16.
//  Copyright © 2016 ME. All rights reserved.
//

#import "EBMusicPlayer.h"


@interface EBMusicPlayer ()

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation EBMusicPlayer

- (void)playTrack:(EBTrack *)stream
{
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfFile:stream.mediaFile];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&error];
    if (!error)
    {
        [self.audioPlayer play];
        self.currentTrack = stream;
    }
    else
    {
        [self handleError:error];
    }
}

- (void)handleError:(NSError *)error
{
    NSLog(@"%@",error.localizedDescription);
}

@end
