//
//  Category.h
//  CromaFeeds
//
//  Created by Claudio Horvilleur on 5/24/10.
//  Copyright 2010 Cromasoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Entry;

@interface Category : NSObject {
	NSString* title;
	NSMutableArray* entries;
}

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSMutableArray* entries;

+(id)initWithTitle:(NSString*)title;
-(void)addEntry:(Entry*)entry;

@end
