//
//  Message.m
//  WhatsApp
//
//  Created by chipont on 05/07/13.
//  Copyright (c) 2013 chipont. All rights reserved.
//

#import "Message.h"

@implementation Message

- (id) initWithProtocol:(NSString *)from to:(NSString *)to
{
    self = [super init];
    _from = from;
    _to = to;
    _time = [[NSDate alloc]init];
    
    return self;
}

- (NSString *) fromProtocol
{
    return [NSString stringWithFormat: @"MSG FROM: %@\n", _from];
}

- (NSString *) toProtocol
{
    return [NSString stringWithFormat: @"RCTP TO: %@\n", _to];
}

- (NSString *) timeProtocol
{
    NSNumber *time = [NSNumber numberWithLong:[_time timeIntervalSince1970]];
    return [NSString stringWithFormat: @"TIME: %ld\n", [time unsignedLongValue]];
}

@end
