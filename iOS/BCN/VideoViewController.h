//
//  VideoViewController.h
//  BCN
//
//  Created by Claudio Horvilleur on 8/15/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class Entry;

@interface VideoViewController : BaseViewController {
    UIView* display;
    @private
    NSString* video;
}

@property (nonatomic, retain) NSString* video;
@property (nonatomic, retain) UIView* display;

+(id)createWithEntry:(Entry*)entry;
-(id)initWithEntry:(Entry*)entry;

@end
