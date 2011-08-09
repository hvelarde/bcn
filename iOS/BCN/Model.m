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
#define CATEGORIES_CFG	@"Categories"
#define LAST_CHECK		@"lastCheck"
#define	FEED			@"feed"

@interface Model()

-(void)loadCategoriesInfo;
-(NSString *)applicationDocumentsDirectory;
-(void)buildFromFeed;

@end

@implementation Model

@synthesize lastCheck, pages, feed, categories, writableDBPath;

#pragma mark Initializations

+(Model*)createFromFile {
	NSString* baseDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
	NSString *archivePath = [baseDir stringByAppendingPathComponent:ARCHIVE_FILE];
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
		NSLog(@"We have no data for building the model");
		self.pages = nil;
		return;
	}
	int len = [categories count];
	NSMutableArray* newPages = [NSMutableArray arrayWithCapacity:len];
	for (int i = 0; i < len; i++) {
		NSDictionary* category = (NSDictionary*)[categories objectAtIndex:i];
		NSString* pageName = [category valueForKey:CAT_KEY] ;	
		NSMutableArray* entries = [NSMutableArray array];
		[newPages addObject:entries];
		NSEnumerator* enumerator = [feed.entries objectEnumerator];
		Entry* entry;
		while ((entry = [enumerator nextObject]) != nil) {
			if (![entry appearsInPage:pageName]) {
				continue;
			}
			[entries addObject:entry];
		}
		NSLog(@"Page %@ ended up with %d entries", pageName, [entries count]);
	}
	self.pages = newPages;
}

-(void)updateFromEntries:(NSArray*)entries updated:(NSDate*)update withAttributes:(NSDictionary*)attributes {
	NSLog(@"We received %d entries", [entries count]);
	self.feed = [Feed initFromEntries:entries updated:update withAttributes:attributes];	
	[self buildFromFeed];
}

#pragma mark -
#pragma mark Categories info

-(void)loadCategoriesInfo {
	NSString *defaultDBPath = [[NSBundle mainBundle]  pathForResource:CATEGORIES_CFG ofType:@"plist"];
	self.categories = [NSArray arrayWithContentsOfFile:defaultDBPath];
}

#pragma mark -
#pragma mark Queries to model info.

-(NSArray*)entriesInPage:(NSInteger)pageNumber {
	if (pageNumber >= [pages count]) {
		return nil;
	}
	return (NSArray*)[pages objectAtIndex:pageNumber];
}

-(NSInteger)numberOfEntriesInPage:(NSInteger)pageNumber {
	NSArray* entries = [self entriesInPage:pageNumber];
	if (entries == nil) {
		return 0;
	}
	return [entries count];
}

-(Entry*)entry:(NSInteger)entryNumber inPage:(NSInteger)pageNumber {
	NSArray* entries = [self entriesInPage:pageNumber];
	if (entries == nil) {
		return nil;
	}
	if (entryNumber >= [entries count]) {
		return nil;
	}
	return [entries objectAtIndex:entryNumber];
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
	NSString *archivePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:ARCHIVE_FILE];
	NSLog(archivePath, nil);
	BOOL res = [NSKeyedArchiver archiveRootObject:self
										   toFile:archivePath];
	if (res) {
		NSLog(@"We saved the feed to file");
	} else {
		NSLog(@"Could not write the archive file");
	}
}

-(NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                NSUserDomainMask,
                                                YES) lastObject];
}

#pragma mark -
#pragma mark General Methods

- (void)dealloc {
	[writableDBPath release];
	[categories release];
	[pages release];
	[feed release];
	[lastCheck release];
    [super dealloc];
}

@end
