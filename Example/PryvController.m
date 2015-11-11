//
//  PryvController.m
//  Example
//
//  Created by Perki on 11.11.15.
//  Copyright © 2015 Pryv. All rights reserved.
//

#import "PryvController.h"
#import "SSKeychain.h"  // provided by cocoapod : SSKeychain

#import <PryvApiKit/PryvApiKit.h>

//
// Implements PYWebLoginDelegate to be able to use PYWebLoginViewController
//


@interface PryvController ()
- (void)initObject;
- (void)loadSavedConnection;
+ (void)saveConnection:(PYConnection *)connection;
+ (void)removeConnection:(PYConnection *)connection;
@end


@implementation PryvController

@synthesize connection = _connection;

+ (PryvController*)sharedInstance
{
    static PryvController *_sharedInstance;
    static dispatch_once_t onceToken;
    __block BOOL init_done = NO;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[PryvController alloc] init];
        init_done = YES;
    });
    if (init_done) [_sharedInstance initObject];
    return _sharedInstance;
}

- (void)initObject
{
    [self loadSavedConnection];
}



#pragma mark --Utilities to load and save Pryv connections: can be reused in other apps

- (void)setConnection:(PYConnection *)pyConn
{
    if (pyConn == _connection) return; // nothing to do
    
    if (_connection) {
        [[self class] removeConnection:_connection]; // remove from the settings
    }
    _connection = pyConn;
    [[NSNotificationCenter defaultCenter] postNotificationName:kAppPryvConnectionChange object:nil];
    [[self class] saveConnection:_connection];
}


- (void)loadSavedConnection
{
    NSString *lastUsedUsername = [[NSUserDefaults standardUserDefaults] objectForKey:kLastUsedUsernameKey];
    if(lastUsedUsername)
    {
        NSString *accessToken = [SSKeychain passwordForService:kServiceName account:lastUsedUsername];
        
        [self setConnection:[[PYConnection alloc] initWithUsername:lastUsedUsername
                                                      andAccessToken:accessToken]];
        
    }
}

+ (void)saveConnection:(PYConnection *)connection
{
    [[NSUserDefaults standardUserDefaults] setObject:connection.userID forKey:kLastUsedUsernameKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [SSKeychain setPassword:connection.accessToken forService:kServiceName account:connection.userID];
}

+ (void)removeConnection:(PYConnection *)connection
{
    [SSKeychain deletePasswordForService:kServiceName account:connection.userID];
}

@end
