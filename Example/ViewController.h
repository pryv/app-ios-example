//
//  ViewController.h
//  Example
//
//  Created by Perki on 11.03.15.
//  Copyright (c) 2015 Pryv. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface ViewController : UIViewController {
    UIButton IBOutlet *addNoteButton;
    UITableView IBOutlet *eventTable;
}

@property (nonatomic, retain) IBOutlet UIButton *signinButton;

/**
 *called by Button on the UINavBar
 *This is a shortcut to a pushMenu static call
 **/
- (IBAction)siginButtonPressed:(id)sender;


@end

