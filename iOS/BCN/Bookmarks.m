//
//  Bookmarks.m
//  BCN
//
//  Created by Claudio Horvilleur on 8/19/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import "Bookmarks.h"
#import "Entry.h"

#define ENTRIES         @"entries"
#define ARCHIVE_FILE    @"bookmarks.archive"

@implementation Bookmarks

@synthesize entries;

#pragma mark - Creation

+(id)createFromFile {
	NSString *archivePath = [[DataStorage applicationDocumentsDirectory] stringByAppendingPathComponent:ARCHIVE_FILE];
	Bookmarks* res = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
	if (res == nil) {
		res = [[[Bookmarks alloc] init] autorelease];
        res.entries = [NSMutableArray arrayWithCapacity:1];
	}
	return res;
}

#pragma mark - Data Management

-(void)prepareForQueries {
    [self loadCategoriesInfo];
    [self buildPagesFromEntries:entries];
}

-(BOOL)addEntry:(Entry*)entry {
    if ([entries containsObject:entry]) {
        return NO;
    }
    [entries insertObject:entry atIndex:0];
    [self saveToFile];
    return YES;
}

-(BOOL)removeEntry:(Entry*)entry {
    NSInteger entryIndex = [entries indexOfObject:entry];
    if (entryIndex == NSNotFound) {
        return NO;
    }
    [entries removeObjectAtIndex:entryIndex];
    return YES;
    
}

#pragma mark - Memory Management

-(void)dealloc {
    [entries release];
    [super dealloc];
}

#pragma mark -
#pragma mark Save/Restore

- (void)encodeWithCoder:(NSCoder *)encoder {
	if ([encoder allowsKeyedCoding]) {
		[encoder encodeObject:entries forKey:ENTRIES];
	} else {
		[encoder encodeObject:entries];
	}
}

- (id)initWithCoder:(NSCoder *)decoder {
	if ([decoder allowsKeyedCoding]) {
		self.entries = [decoder decodeObjectForKey:ENTRIES];
	} else {
		self.entries = [decoder decodeObject];
	}
	return self;
}

-(void)saveToFile {
	NSString *archivePath = [[DataStorage applicationDocumentsDirectory] stringByAppendingPathComponent:ARCHIVE_FILE];
	BOOL res = [NSKeyedArchiver archiveRootObject:self
										   toFile:archivePath];
	if (res) {
		NSLog(@"We saved the bookmarks to file");
	} else {
		NSLog(@"Could not write the bookmarks to file");
	}
}

@end
