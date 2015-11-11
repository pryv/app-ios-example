//
//  PryvController.h
//  Example
//
//  Created by Perki on 11.11.15.
//  Copyright © 2015 Pryv. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PYConnection;


// the two following strings are used to retrieve infos from NSUserDefaults
#define kServiceName @"com.pryv.exampleapp"
#define kLastUsedUsernameKey @"lastUsedUsernameKey"

// the streamID we will use for tests
#define kStreamId @"com.pryv.exampleapp.stream"
#define kStreamDefaultName @"Pryv iOS Example"

// Event driven notification
#define kAppPryvConnectionChange  @"kAppPryvConnectionChange"

@interface PryvController : NSObject

+ (PryvController*)sharedInstance;

@property (nonatomic, retain) PYConnection *connection;


@end
