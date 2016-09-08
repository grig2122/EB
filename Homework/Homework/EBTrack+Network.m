//
//  EBTrack+JSON.m
//  Homework
//
//  Created by GK on 9/6/16.
//  Copyright © 2016 ME. All rights reserved.
//

#import "EBTrack+Network.h"
#import "API.h"

@interface EBTrack ()

// Private properties
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *localMediaFilePath;

@end

@implementation EBTrack (Network)

// Map json to Track object
+ (EBTrack *)trackFromJson:(id)responseObject
{
    EBTrack *track = [[EBTrack alloc] init];
    
    // track name
    track.trackName = responseObject[@"name"];
    
    // artist name
    track.artistName = responseObject[@"artist"][@"name"];
    
    // image url
    id images = responseObject[@"artist"][@"images"];
    if ([images isKindOfClass:[NSArray class]] && [images count] > 0)
    {
        track.artistImageURL = [images firstObject][@"small"];
    }
    
    // media file
    track.mediaFileURL = responseObject[@"media_file"];
    track.createdDate = [NSDate date];
    
    return track;
}

- (void)loadMediaFileWithCompletionBlock:(void(^)(NSString *localFilePath))block
{
    if ([self.localMediaFilePath length] > 0)
    {
        block(self.localMediaFilePath);
    }
    else
    {
        // Download media file
        __weak typeof(self)weakSelf = self;
        [[API sharedInstance] downloadMediaFileFromRemoteFilePath:self.mediaFileURL completion:^(NSString *localFilePath) {
            weakSelf.localMediaFilePath = localFilePath;
            block(localFilePath);
        }];
    }
}

- (void)loadImageWithCompletionBlock:(void(^)(UIImage *image))block
{
    if (self.image)
    {
        block(self.image);
    }
    else
    {
        // Download artist image
        [[API sharedInstance] downloadImageFromPath:self.artistImageURL completion:^(UIImage *image) {
            block(image);
        }];
    }
}

- (void)handleError:(NSError *)error
{
    NSLog(@"%@",error.localizedDescription);
}

@end






















