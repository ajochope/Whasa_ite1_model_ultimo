//
//  SenderMessage.m
//  WhatsApp
//
//  Created by chipont on 05/07/13.
//  Copyright (c) 2013 chipont. All rights reserved.
//

#import "SendMessage.h"

@implementation SendMessage 

- (id) initWithData:(NSString *)data from:(NSString *)from to:(NSString *)to
{
    self = [super initWithProtocol:from to:to];
    _message = data;
    return self;
}

- (NSString *)print
{
    return [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n", [super fromProtocol], [super toProtocol], [super timeProtocol], [self messageProtocol]];
}

- (NSString *) messageProtocol
{
    return [NSString stringWithFormat:@"DATA: %@\n", _message ];
}

@end
