//
//  NewsView.h
//  CromaNews
//
//  Created by Claudio Horvilleur on 6/17/10.
//  Copyright 2010 Cromasoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Entry;

@interface NewsView : UIView {
	Entry* entry;
	NSDateFormatter* dateFormatter;
}

@property (nonatomic, retain) Entry* entry;
@property (nonatomic, retain) NSDateFormatter* dateFormatter;

@end
