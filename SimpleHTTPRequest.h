//
//  ObjCDemo
//
//  Created by Aly Yakan on 5/15/17.
//  Copyright © 2017 dreidev. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CompletionBlock)();

typedef enum {
    GET, POST, PUT, DELETE
}  HTTPMethod;

@interface SimpleHTTPRequest : NSObject
{
    
}

@property(nonatomic, copy) NSURL *url;
@property(nonatomic) HTTPMethod httpMethod;
@property(nonatomic, copy) NSDictionary *parameters;

- (instancetype)initWithURL:(NSURL*)url andMethod:(HTTPMethod)method andParams:(NSDictionary*) parameters;
- (NSString*)formatMethodToString:(HTTPMethod)method;

@end

