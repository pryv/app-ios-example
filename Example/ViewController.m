//
//  ViewController.m
//  Example
//
//  Created by Perki on 11.03.15.
//  Copyright (c) 2015 Pryv. All rights reserved.
//

#import "ViewController.h"
#import <PryvApiKit/PryvApiKit.h>
#import "PYWebLoginViewController.h"



@interface ViewController () <PYWebLoginDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)siginButtonPressed: (id) sender  {
    NSLog(@"Signin Started");
    
    
    /** 
     * permissions sets is manage for all Streams
     * In JSON that would do:
     * [ { 'streamId' : 'ios-example-test', 'level' : 'manage'} ]
     */
    NSArray *permissions = @[ @{ kPYAPIConnectionRequestStreamId : kPYAPIConnectionRequestAllStreams ,
                                     kPYAPIConnectionRequestLevel: kPYAPIConnectionRequestManageLevel}];
                              
    
    
    __unused
    PYWebLoginViewController *webLoginController =
    [PYWebLoginViewController requestConnectionWithAppId:@"pryv-ios-example"
                                          andPermissions:permissions
                                                delegate:self];
    
}

#pragma mark --PYWebLoginDelegate

- (UIViewController *)pyWebLoginGetController {
    return self;
}

- (BOOL)pyWebLoginShowUIViewController:(UIViewController*)loginViewController {
    return NO;
};

- (void)pyWebLoginSuccess:(PYConnection*)pyAccess {
    NSLog(@"Signin With Success %@ %@", pyAccess.userID, pyAccess.accessToken);
}

- (void)pyWebLoginAborted:(NSString*)reason {
    NSLog(@"Signin Aborted: %@",reason);
}

- (void) pyWebLoginError:(NSError*)error {
    NSLog(@"Signin Error: %@",error);
}



@end
