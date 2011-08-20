//
//  Modelo.m
//  BCN
//
//  Created by Claudio Horvilleur on 5/13/10.
//  Copyright 2010 Cromasoft. All rights reserved.
//

#import "Model.h"
#import "Feed.h"
#import "Category.h"
#import "Entry.h"
#import "CommonConstants.h"

#define ARCHIVE_FILE	@"Feed.archive"
#define LAST_CHECK		@"lastCheck"
#define	FEED			@"feed"

@interface Model()

-(void)buildFromFeed;

@end

@implementation Model

@synthesize lastCheck, feed;

#pragma mark Initializations

+(Model*)createFromFile {
	NSString *archivePath = [[DataStorage applicationDocumentsDirectory] stringByAppendingPathComponent:ARCHIVE_FILE];
	Model* res = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
	if (res == nil) {
		res = [[[Model alloc] init] autorelease];
	}
	[res loadCategoriesInfo];
	[res buildFromFeed];
	return res;
}

/**
 * Build the model (mono or multi-page) from the feed (an Array of entries)
 */
-(void)buildFromFeed {
	if ((feed == nil) || ([feed.entries count] == 0)) {
		self.pages = nil;
		return;
	}
    [self buildPagesFromEntries:feed.entries];
}

-(void)updateFromEntries:(NSArray*)entries
                 updated:(NSDate*)update
          withAttributes:(NSDictionary*)attributes {
	self.feed = [Feed initFromEntries:entries updated:update withAttributes:attributes];	
	[self buildFromFeed];
}

#pragma mark -
#pragma mark Save/Restore

- (void)encodeWithCoder:(NSCoder *)encoder {
	if ([encoder allowsKeyedCoding]) {
		[encoder encodeObject:lastCheck forKey:LAST_CHECK];
		[encoder encodeObject:feed forKey:FEED];
	} else {
		[encoder encodeObject:lastCheck];
		[encoder encodeObject:feed];
	}
}

- (id)initWithCoder:(NSCoder *)decoder {
	if ([decoder allowsKeyedCoding]) {
		self.lastCheck = [decoder decodeObjectForKey:LAST_CHECK];
		self.feed = [decoder decodeObjectForKey:FEED];
	} else {
		self.lastCheck = [decoder decodeObject];
		self.feed = [decoder decodeObject];
	}
	return self;
}

-(void)saveToFile {
	NSString *archivePath = [[DataStorage applicationDocumentsDirectory] stringByAppendingPathComponent:ARCHIVE_FILE];
	BOOL res = [NSKeyedArchiver archiveRootObject:self
										   toFile:archivePath];
	if (res) {
		NSLog(@"We saved the feed to file");
	} else {
		NSLog(@"Could not write the archive file");
	}
}

#pragma mark -
#pragma mark General Methods

- (void)dealloc {
	[feed release];
	[lastCheck release];
    [super dealloc];
}

@end
