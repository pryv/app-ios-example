//
//  ViewController.m
//  Example
//
//  Created by Perki on 11.03.15.
//  Copyright (c) 2015 Pryv. All rights reserved.
//

#import "ViewController.h"
#import "PYWebLoginViewController.h"

#import "SSKeychain.h"  // provided by cocoapod : SSKeychain


//
// Implements PYWebLoginDelegate to be able to use PYWebLoginViewController
//
@interface ViewController () <PYWebLoginDelegate, UIAlertViewDelegate>
- (void)loadSavedConnection;
+ (void)saveConnection:(PYConnection *)connection;
+ (void)removeConnection:(PYConnection *)connection;
@end

@implementation ViewController

@synthesize pyConnection;



- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSavedConnection];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signinButtonPressed: (id) sender  {
    if (loadingSavedConnection) return;
    if (self.pyConnection) { // already logged in -> Propose to log Off
        [[[UIAlertView alloc] initWithTitle:@"Sign off?"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK",nil] show];
        return;
    }
    
    
    NSLog(@"Signin Started");
    
    
    /** 
     * permissions sets is manage for all Streams
     * In JSON that would do:
     * [ { 'streamId' : 'com.pryv.exampleapp.stream', 
     *     'defaultName' : 'Pryv iOS Example',
     *      'level' : 'manage'} ]
     */
    NSArray *permissions = @[ @{ kPYAPIConnectionRequestStreamId : kStreamId ,
                                 kPYAPIConnectionRequestDefaultStreamName : kStreamDefaultName,
                                 kPYAPIConnectionRequestLevel: kPYAPIConnectionRequestManageLevel}];
                              
    
    
    __unused
    PYWebLoginViewController *webLoginController =
    [PYWebLoginViewController requestConnectionWithAppId:@"pryv-ios-example"
                                          andPermissions:permissions
                                                delegate:self];
    
}

/**
 * Connection changed (can be nil to remove)
 */
- (void)setupConnection:(PYConnection *)connection
{
    if (connection == self.pyConnection) return; // nothing to do
    
    if (self.pyConnection) {
        [[self class] removeConnection:self.pyConnection]; // remove from the settings
    }
    
    self.pyConnection = connection;
    
    if (self.pyConnection) { // Signed In
        [self.signinButton setTitle:self.pyConnection.userID forState:UIControlStateNormal];
        [[self class] saveConnection:self.pyConnection];
        
        [self.pyConnection streamsEnsureFetched:^(NSError *error) {
            if (error) {
                NSLog(@"<FAIL> fetching stream at streamSetup");
                return;
            }
        }];

        
    } else { // Signed off
        [self.signinButton setTitle:@"Sign in" forState:UIControlStateNormal];
    }
}


#pragma mark --Alert Views

- (void)alertView:(UIAlertView *)theAlert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) { // OK
        [self setupConnection:nil];
    }
}



#pragma maek -- Add Note

- (void)addNoteButtonPressed:(id)sender
{
    if (! self.pyConnection) {
        [[[UIAlertView alloc] initWithTitle:@"Sign in before adding notes"
                                    message:@""
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    
    PYEvent *event = [[PYEvent alloc] init];
    event.streamId = kStreamId;
    event.eventContent = @"Hello World";
    event.type = @"note/txt";
    
    [self.pyConnection eventCreate:event successHandler:^(NSString *newEventId, NSString *stoppedId, PYEvent *event) {
        NSLog(@"Event created succefully with ID: %@", newEventId);
    } errorHandler:^(NSError *error) {
        NSLog(@"Event creation Error: %@", error);
    }];
    
}

#pragma mark --PYWebLoginDelegate

- (UIViewController *)pyWebLoginGetController {
    return self;
}

- (BOOL)pyWebLoginShowUIViewController:(UIViewController*)loginViewController {
    return NO;
};

/**
 * Called after a successfull sign-in
 */
- (void)pyWebLoginSuccess:(PYConnection*)pyConn {
    NSLog(@"Signin With Success %@ %@", pyConn.userID, pyConn.accessToken);
    [self setupConnection:pyConn];
}

- (void)pyWebLoginAborted:(NSString*)reason {
    NSLog(@"Signin Aborted: %@",reason);
}

- (void) pyWebLoginError:(NSError*)error {
    NSLog(@"Signin Error: %@",error);
}


#pragma mark --Utilities to load and save Pryv connections: can be reused in other apps

BOOL loadingSavedConnection = NO;

- (void)loadSavedConnection
{
    loadingSavedConnection = YES;
    NSString *lastUsedUsername = [[NSUserDefaults standardUserDefaults] objectForKey:kLastUsedUsernameKey];
    if(lastUsedUsername)
    {
        NSString *accessToken = [SSKeychain passwordForService:kServiceName account:lastUsedUsername];
        [self setupConnection:[[PYConnection alloc] initWithUsername:lastUsedUsername
                                                      andAccessToken:accessToken]];
        NSLog(@"LoadedSavedConnection: %@", lastUsedUsername);
    }
    loadingSavedConnection = NO;
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
