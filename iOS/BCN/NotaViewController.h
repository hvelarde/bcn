//
//  NotaViewController.h
//  BCN
//
//  Created by Claudio Horvilleur on 8/9/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class Entry;

@interface NotaViewController : BaseViewController {
    UIBarButtonItem* increaseFontItem;
    UIBarButtonItem* decreaseFontItem;
    UIScrollView* scrollView;
    @private
    Entry* entry;
    float fontSize;
}

@property (nonatomic, retain) Entry* entry;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* increaseFontItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* decreaseFontItem;
@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;

+(id)createWithEntry:(Entry*)entry;
-(id)initWithEntry:(Entry*)entry;

-(IBAction)bookmarkSelected:(id)sender;
-(IBAction)forwardSelected:(id)sender;
-(IBAction)increaseFontSelected:(id)sender;
-(IBAction)decreaseFontSelected:(id)sender;

@end
