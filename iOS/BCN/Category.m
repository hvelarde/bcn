//
//  Category.m
//  CromaFeeds
//
//  Created by Claudio Horvilleur on 5/24/10.
//  Copyright 2010 Cromasoft. All rights reserved.
//

#import "Category.h"


@implementation Category

@synthesize title, entries;

#pragma mark Creation

+(id)initWithTitle:(NSString*)title {
	Category* res = [[[Category alloc] init] autorelease];
	res.title = title;
	res.entries = [NSMutableArray array];
	return res;
}

#pragma mark -
#pragma mark Entries management

-(void)addEntry:(Entry*)entry {
	[entries addObject:entry];
}

#pragma mark -
#pragma mark General

-(void)dealloc {
	[title release];
	[entries release];
	[super dealloc];
}

@end
