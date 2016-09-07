//
//  EBTrack+JSON.h
//  Homework
//
//  Created by GK on 9/6/16.
//  Copyright © 2016 ME. All rights reserved.
//

#import "EBTrack.h"

@interface EBTrack (Network)

+ (EBTrack *)trackFromJson:(id)response;
- (void)loadImageWithCompletionBlock:(void(^)(UIImage *image))block;

@end
