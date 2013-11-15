//
//  ReceiverMessage.m
//  WhatsApp
//
//  Created by chipont on 05/07/13.
//  Copyright (c) 2013 chipont. All rights reserved.
//

#import "ReceiveMessage.h"


@implementation ReceiveMessage 

@synthesize message = _message;


-(id)initWithProtocol:(NSString *)from 
{
    self = [super init];
    [super setFrom:from];
    return self;
}
- (NSString *) fromProtocol
{
    return [NSString stringWithFormat: @"GETMSGID: %@\n", [super from]];
}
@end
