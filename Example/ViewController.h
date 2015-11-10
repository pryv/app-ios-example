//
//  ViewController.h
//  Example
//
//  Created by Perki on 11.03.15.
//  Copyright (c) 2015 Pryv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PryvApiKit/PryvApiKit.h>

// the two following strings are used to retrieve infos from NSUserDefaults
#define kServiceName @"com.pryv.exampleapp"
#define kLastUsedUsernameKey @"lastUsedUsernameKey"

// the streamID we will use for tests
#define kStreamId @"com.pryv.exampleapp.stream"
#define kStreamDefaultName @"Pryv iOS Example"


@interface ViewController : UIViewController {
}

@property (nonatomic, retain) IBOutlet UITableView *eventTable;
@property (nonatomic, retain) IBOutlet UIButton *addNoteButton;
@property (nonatomic, retain) IBOutlet UIButton *signinButton;


@property (nonatomic, retain) PYConnection *pyConnection;


- (IBAction)signinButtonPressed:(id)sender;


- (IBAction)addNoteButtonPressed:(id)sender;


@end

