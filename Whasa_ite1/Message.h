//
//  Message.h
//  WhatsApp
//
//  Created by chipont on 05/07/13.
//  Copyright (c) 2013 chipont. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property(strong, nonatomic) NSString *from;
@property(strong, nonatomic) NSString *to;
@property(strong, nonatomic) NSDate *time;

- (id) initWithProtocol: (NSString *) from to: (NSString *) to;

- (NSString *) fromProtocol;
- (NSString *) toProtocol;
- (NSString *) timeProtocol;

@end
