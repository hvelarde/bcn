//
//  DataStorage.m
//  BCN
//
//  Created by Claudio Horvilleur on 8/19/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import "DataStorage.h"
#import "CommonConstants.h"
#import "Entry.h"

#define CATEGORIES_CFG	@"Categories"

@implementation DataStorage

@synthesize categories;
@synthesize pages;

#pragma mark - Memory Management

-(void)dealloc {
    [categories release];
    [pages release];
    [super dealloc];
}

#pragma mark - Categories info

-(void)loadCategoriesInfo {
	NSString *defaultDBPath = [[NSBundle mainBundle]  pathForResource:CATEGORIES_CFG ofType:@"plist"];
	self.categories = [NSArray arrayWithContentsOfFile:defaultDBPath];
}

#pragma mark - Pages management

-(void)buildPagesFromEntries:(NSArray*)entries {
	int len = [categories count];
	NSMutableArray* newPages = [NSMutableArray arrayWithCapacity:len];
	for (int i = 0; i < len; i++) {
		NSDictionary* category = (NSDictionary*)[categories objectAtIndex:i];
		NSString* pageName = [category valueForKey:CAT_KEY] ;	
		NSMutableArray* pageEntries = [NSMutableArray array];
		[newPages addObject:pageEntries];
		NSEnumerator* enumerator = [entries objectEnumerator];
		Entry* entry;
		while ((entry = [enumerator nextObject]) != nil) {
			if (![entry appearsInPage:pageName]) {
				continue;
			}
			[pageEntries addObject:entry];
		}
//		NSLog(@"Page %@ ended up with %d entries", pageName, [entries count]);
	}
	self.pages = newPages;
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

#pragma mark - General File Access

+(NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                NSUserDomainMask,
                                                YES) lastObject];
}


@end
