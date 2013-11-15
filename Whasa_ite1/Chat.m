//
//  ChatModel.m
//  WhatsApp
//
//  Created by chipont on 05/07/13.
//  Copyright (c) 2013 chipont. All rights reserved.
//
#import "Chat.h"

@interface Chat()

@property(strong, nonatomic) NSInputStream *inputStream;
@property(strong, nonatomic) NSOutputStream *outputStream;
@property(strong, nonatomic) UIViewController *controller;

@property(strong, nonatomic) NSMutableArray *rMessages;
@end

@implementation Chat

- (id) initWithRegisterController: (id) controller from: (NSString *) from
{
    self = [super init];
    _from = from;
    _controller = controller;
    
    [NSTimer scheduledTimerWithTimeInterval:10.0
                                target:self
                                selector:@selector(listen)
                                userInfo:nil
                                repeats:YES];
    _rMessages = [[NSMutableArray alloc]init];
    
    return self;
}

- (void) setNetworkComunication
{
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)@"localhost", 1234, &readStream, &writeStream);
    
    _inputStream = (__bridge NSInputStream *) readStream;
    _outputStream = (__bridge NSOutputStream *)writeStream;
    
    [_inputStream setDelegate: self];
    [_outputStream setDelegate: self];
    
    [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [_outputStream open];
    [_inputStream open];

}

- (void) sendMessage:(SendMessage *)message 
{
    [self setNetworkComunication];
    NSData *data = [[NSData alloc] initWithData:[message.fromProtocol dataUsingEncoding:NSUTF8StringEncoding]];
    [_outputStream write:[data bytes] maxLength:[data length]];
    data = [[NSData alloc] initWithData:[message.toProtocol dataUsingEncoding:NSUTF8StringEncoding]];
    [_outputStream write:[data bytes] maxLength:[data length]];    
    data = [[NSData alloc] initWithData:[message.timeProtocol dataUsingEncoding:NSUTF8StringEncoding]];
    [_outputStream write:[data bytes] maxLength:[data length]];
    data = [[NSData alloc] initWithData:[message.messageProtocol dataUsingEncoding:NSUTF8StringEncoding]];
    [_outputStream write:[data bytes] maxLength:[data length]];
    [self closeConnection];
}

- (void) receiveMessages
{
    [self setNetworkComunication];
    ReceiveMessage *message = [[ReceiveMessage alloc] initWithProtocol: _from ];
    //NSLog(@"Pidiendo mensajes para %@", [message fromProtocol]);
    NSData *data = [[NSData alloc] initWithData:[message.fromProtocol dataUsingEncoding:NSUTF8StringEncoding]];
    
    [_outputStream write: [data bytes] maxLength: [data length]];
}

- (void) stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{

    switch (eventCode) {
        case NSStreamEventOpenCompleted:
			//NSLog(@"Stream opened");
			break;
            
		case NSStreamEventHasBytesAvailable:
            [self receive:aStream];
			break;
            
		case NSStreamEventErrorOccurred:
			//NSLog(@"Can not connect to the host!");
			break;
            
		case NSStreamEventEndEncountered:
            [aStream close];
            [aStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            aStream = nil;
            [self closeConnection];
			break;
        case NSStreamStatusWriting:
            break;
        default:
            NSLog(@"Evento desconocido: %u", eventCode);
            break;
    }
}

- (void) receive : (NSStream *) aStream
{
    [_rMessages removeAllObjects];
    if (aStream == _inputStream) {
        
        uint8_t buffer[1024];
        int len;
        
        while ([_inputStream hasBytesAvailable]) {
            len = [_inputStream read:buffer maxLength:sizeof(buffer)];
            if (len > 0) {
                
                NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                
                if (nil != output) {
                    if (![output isEqualToString:@"EMPTY\n"]){
                        [self parserResponse:output];
                    }
                }
            }
        }
        //NSLog(@"%d",[[self rMessages] count]);
        if ([[self rMessages] count] > 0){
            [self notify];
        }
    }

}

- (void) closeConnection{
    [_outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void) listen
{
    [self receiveMessages];
}

- (void) parserResponse: (NSString *) response
{
    ReceiveMessage *receiveMessage;
    
    NSArray *lines = [response componentsSeparatedByString:@"\n"];
        
    for (NSString *line in lines){
        NSArray *field = [line componentsSeparatedByString:@": "];
        if ([[field objectAtIndex:0] isEqualToString:@"MSG FROM"]){
            receiveMessage = [[ReceiveMessage alloc] init];
            [receiveMessage setFrom: [field objectAtIndex:1]];            
            [receiveMessage setTo:_from];
            [_rMessages addObject: receiveMessage];
        }else if ([[field objectAtIndex:0] isEqualToString:@"TIME"]){
            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
            NSNumber *dateLong = [f numberFromString: [field objectAtIndex:1]];
            [receiveMessage setTime:[NSDate dateWithTimeIntervalSince1970: [dateLong longValue]]];            
        }else if ([[field objectAtIndex:0] isEqualToString:@"DATA"]){
            [receiveMessage setMessage:[field objectAtIndex:1]];
        }    
    }
}

- (void) notify
{
    NSArray *array = [[NSArray alloc] initWithArray:_rMessages];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReceivedData"
                                                        object:array];
}

@end
