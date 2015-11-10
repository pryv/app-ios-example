//
//  ViewController.m
//  Example
//
//  Created by Perki on 11.03.15.
//  Copyright (c) 2015 Pryv. All rights reserved.
//

#import "ViewController.h"
#import "PYWebLoginViewController.h"


//
// Implements PYWebLoginDelegate to be able to use PYWebLoginViewController
//
@interface ViewController () <PYWebLoginDelegate, UIAlertViewDelegate>

@end

@implementation ViewController

@synthesize pyConnection;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)siginButtonPressed: (id) sender  {
    if (self.pyConnection) { // already logged in -> Propose to log Off
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sign off?"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK",nil];
        [alert show];
        return;
    }
    
    
    NSLog(@"Signin Started");
    
    
    /** 
     * permissions sets is manage for all Streams
     * In JSON that would do:
     * [ { 'streamId' : '*', 'level' : 'manage'} ]
     */
    NSArray *permissions = @[ @{ kPYAPIConnectionRequestStreamId : kPYAPIConnectionRequestAllStreams ,
                                     kPYAPIConnectionRequestLevel: kPYAPIConnectionRequestManageLevel}];
                              
    
    
    __unused
    PYWebLoginViewController *webLoginController =
    [PYWebLoginViewController requestConnectionWithAppId:@"pryv-ios-example"
                                          andPermissions:permissions
                                                delegate:self];
    
}


#pragma mark --Alert Views

- (void)alertView:(UIAlertView *)theAlert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) { // OK
        self.pyConnection = nil;
        [self.signinButton setTitle:@"Sign in" forState:UIControlStateNormal];
    }
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
- (void)pyWebLoginSuccess:(PYConnection*)pyAccess {
    NSLog(@"Signin With Success %@ %@", pyAccess.userID, pyAccess.accessToken);
    self.pyConnection = pyAccess;
    [self.signinButton setTitle:pyAccess.userID forState:UIControlStateNormal];
    
}

- (void)pyWebLoginAborted:(NSString*)reason {
    NSLog(@"Signin Aborted: %@",reason);
}

- (void) pyWebLoginError:(NSError*)error {
    NSLog(@"Signin Error: %@",error);
}



@end
