//
//  ChatModel.h
//  WhatsApp
//
//  Created by chipont on 05/07/13.
//  Copyright (c) 2013 chipont. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReceiveMessage.h"
#import "SendMessage.h"
@interface Chat : NSObject <NSStreamDelegate>

@property(strong, nonatomic) NSMutableArray *messageReceiver;//of ReceiverMessages

@property(strong, nonatomic) NSString *from;

- (id) initWithRegisterController: (UIViewController*) controller from: (NSString *) from;

- (void) setNetworkComunication;

- (void) closeConnection;

-(void) sendMessage: (SendMessage *) message;

-(void) receiveMessages;

-(void) stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode;

@end
