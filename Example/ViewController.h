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


@interface ViewController : UIViewController {
}

@property (nonatomic, retain) IBOutlet UITableView *eventTable;
@property (nonatomic, retain) IBOutlet UIButton *addNoteButton;
@property (nonatomic, retain) IBOutlet UIButton *signinButton;


@property (nonatomic, retain) PYConnection *pyConnection;

/**
 *called by Button on the UINavBar
 *This is a shortcut to a pushMenu static call
 **/
- (IBAction)siginButtonPressed:(id)sender;


@end

