//
//  BaseViewController.h
//  BCN
//
//  Created by Claudio Horvilleur on 8/9/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Entry;

@interface BaseViewController : UIViewController <UIAlertViewDelegate> {
    @protected
    Entry* entry;
}

@property (nonatomic, retain) Entry* entry;

-(IBAction)homeButtonPushed:(id)sender;
-(IBAction)backButtonPushed:(id)sender;
-(IBAction)buscarButtonPushed:(id)sender;
-(IBAction)bookmarkSelected:(id)sender;
-(IBAction)forwardSelected:(id)sender;

@end
