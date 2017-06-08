//
//  NSObject+SimpleHTTPRequest.m
//  ObjCDemo
//
//  Created by Aly Yakan on 5/15/17.
//  Copyright © 2017 dreidev. All rights reserved.
//

#import "SimpleHTTPRequest.h"

@interface SimpleHTTPRequest ()

@end

@implementation SimpleHTTPRequest

- (instancetype)init
{
    self = [super init];
    _url = [[NSURL alloc] init];
    _httpMethod = GET;
    _parameters = [[NSDictionary alloc] init];
    return self;
}

- (instancetype)initWithURL:(NSURL*)u andMethod:(HTTPMethod)m andParams:(NSDictionary*)p {
    self = [super init];
    _url = u;
    _httpMethod = m;
    _parameters = p;
    return self;
}

- (NSString*)formatMethodToString:(HTTPMethod)method {
    NSString *result = nil;
    switch(method) {
        case GET:
            result = @"GET";
            break;
        case POST:
            result = @"POST";
            break;
        case PUT:
            result = @"PUT";
            break;
        case DELETE:
            result = @"DELETE";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected HTTP Method."];
    }
    
    return result;
}

@end

