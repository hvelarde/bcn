//
//  Feed.m
//  CromaFeeds
//
//  Created by Claudio Horvilleur on 5/24/10.
//  Copyright 2010 Cromasoft. All rights reserved.
//

#import "Feed.h"

#define	LAST_UPDATE	@"lastUpdate"
#define ENTRIES		@"entries"
#define ATTRIBUTES	@"attributes"

@implementation Feed

@synthesize lastUpdate, entries, attributes;

#pragma mark Creation
+(id)initFromEntries:(NSArray*)entries updated:(NSDate*)update withAttributes:(NSDictionary*)attributes {
	Feed* res = [[[Feed alloc] init] autorelease];
	res.entries = entries;
	res.lastUpdate = update;
	res.attributes = attributes;
	return res;
}

#pragma mark -
#pragma mark Save/Restore

- (void)encodeWithCoder:(NSCoder *)encoder {
	if ([encoder allowsKeyedCoding]) {
		[encoder encodeObject:lastUpdate forKey:LAST_UPDATE];
		[encoder encodeObject:entries forKey:ENTRIES];
		[encoder encodeObject:attributes forKey:ATTRIBUTES];
	} else {
		[encoder encodeObject:lastUpdate];
		[encoder encodeObject:entries];
		[encoder encodeObject:attributes];
	}
}

- (id)initWithCoder:(NSCoder *)decoder {
	if ([decoder allowsKeyedCoding]) {
		self.lastUpdate = [decoder decodeObjectForKey:LAST_UPDATE];
		self.entries = [decoder decodeObjectForKey:ENTRIES];
		self.attributes = [decoder decodeObjectForKey:ATTRIBUTES];
	} else {
		self.lastUpdate = [decoder decodeObject];
		self.entries = [decoder decodeObject];
		self.attributes = [decoder decodeObject];
	}
	return self;
}

#pragma mark -
#pragma mark General

-(void)dealloc {
	[lastUpdate release];
	[entries release];
	[super dealloc];
}

@end
