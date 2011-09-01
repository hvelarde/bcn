//
//  BaseViewController.h
//  BCN
//
//  Created by Claudio Horvilleur on 8/9/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "SHKSharer.h"

@class Entry;

@interface BaseViewController : UIViewController <UIAlertViewDelegate, MFMailComposeViewControllerDelegate, SHKSharerDelegate> {
    @protected
    Entry* entry;
    SHKSharer* shkSharer;
}

@property (nonatomic, retain) Entry* entry;
@property (nonatomic, retain) SHKSharer* shkSharer;

-(IBAction)homeButtonPushed:(id)sender;
-(IBAction)backButtonPushed:(id)sender;
-(IBAction)buscarButtonPushed:(id)sender;
-(IBAction)bookmarkSelected:(id)sender;
-(IBAction)forwardSelected:(id)sender;

@end
