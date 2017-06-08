//
//  NSObject+ImageDownload.h
//  SimpleHTTPObjC
//
//  Created by Aly Yakan on 6/7/17.
//  Copyright © 2017 dreidev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImageView (ImageDownload)
    <NSURLSessionDownloadDelegate>

- (void) setImageWithURL:(NSURL *_Nonnull)url background:(BOOL)background;
- (void) setImageWithURL:(NSURL *_Nonnull)url completionHandler:(void (^_Nullable)(NSError * _Nullable error))completionHandler;
@end
