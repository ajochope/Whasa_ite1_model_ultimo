//
//  SenderMessage.h
//  WhatsApp
//
//  Created by chipont on 05/07/13.
//  Copyright (c) 2013 chipont. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"

@interface SendMessage : Message

@property(strong, nonatomic) NSString *message;

- (id) initWithData: (NSString *) data from: (NSString *) from to: (NSString *) to;

- (NSString *) print;
- (NSString *) messageProtocol;

@end
