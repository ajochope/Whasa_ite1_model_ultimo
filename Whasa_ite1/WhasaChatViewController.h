//
//  WhasaChatViewController.h
//  Whasa_ite1
//
//  Created by chipont on 18/07/13.
//  Copyright (c) 2013 corenetworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import "QuartzCore/QuartzCore.h"

@interface WhasaChatViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSString *nick;
@property (nonatomic) ABRecordRef contacto;
@end
