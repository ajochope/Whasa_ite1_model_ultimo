//
//  ReceiverMessage.h
//  WhatsApp
//
//  Created by chipont on 05/07/13.
//  Copyright (c) 2013 chipont. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"

@interface ReceiveMessage : Message

@property(strong, nonatomic) NSString *message;

- (id)initWithProtocol:(NSString *)from;

@end
