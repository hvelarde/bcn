//
//  Entry.m
//  CromaFeeds
//
//  Created by Claudio Horvilleur on 5/24/10.
//  Copyright 2010 Cromasoft. All rights reserved.
//

#import "Entry.h"
#import "CommonConstants.h"

#define	ATTRIBUTES		@"attributes"
#define PAGES			@"pages"
#define ENTRY_ID        @"entryId"

@implementation Entry

@synthesize pagesWhereItAppears, attributes, image, imageURLString, entryId;
@synthesize imageIsLoading;
@synthesize newsView;

#pragma mark Creation

+(Entry*)entry {
	Entry* entry = [[[Entry alloc] init] autorelease];
	entry.attributes =[NSMutableDictionary dictionaryWithCapacity:5];
	entry.pagesWhereItAppears = [NSMutableSet setWithCapacity:5];
	[entry setVolatileFieldsToInitialValue];
	return entry;
}

#pragma mark -
#pragma mark Attributes management

-(id)valueForKey:(NSString*)key {
	return [attributes valueForKey:key];
}

-(void)setValue:(NSObject*)value forKey:(NSString*)key {
	[attributes setValue:value forKey:key];
}

#pragma mark -
#pragma mark Pages data

-(void)includeInPage:(NSString*)page {
	[pagesWhereItAppears addObject:page];
}

-(BOOL)appearsInPage:(NSString*)page {
	return [pagesWhereItAppears containsObject:page];
}

#pragma mark -
#pragma mark Image Management

-(void)defineImageFromLink:(NSString*)imageLink {
	self.imageURLString = imageLink;
//	NSLog(@"image string: '%@' - '%@'", imageLink, imageURLString);
}

-(BOOL)hasImage {
	return (imageURLString != nil);
}

-(UIImage*)activeImage {
    return image;
}

-(BOOL)needImageLoading {
//    NSLog(@"Asking for image: %@", imageURLString);
	return [self hasImage] && (image == nil);
}

-(void)storeLoadedImage:(UIImage*)loadedImage {
    self.image = loadedImage;
    self.imageIsLoading = NO;
    if (newsView != nil) {
        [newsView setNeedsDisplay];
    }
}

#pragma mark -
#pragma mark Save/Restore

- (void)encodeWithCoder:(NSCoder *)encoder {
	if ([encoder allowsKeyedCoding]) {
		[encoder encodeObject:attributes forKey:ATTRIBUTES];
		[encoder encodeObject:pagesWhereItAppears forKey:PAGES];
        [encoder encodeObject:entryId forKey:ENTRY_ID];
	} else {
		[encoder encodeObject:attributes];
		[encoder encodeObject:pagesWhereItAppears];
        [encoder encodeObject:entryId];
	}	
	// The rest of the data is volatile.
}

- (id)initWithCoder:(NSCoder *)decoder {
	if ([decoder allowsKeyedCoding]) {
		self.attributes = [decoder decodeObjectForKey:ATTRIBUTES];
		self.pagesWhereItAppears = [decoder decodeObjectForKey:PAGES];
        self.entryId = [decoder decodeObjectForKey:ENTRY_ID];
	} else {
		self.attributes = [decoder decodeObject];
		self.pagesWhereItAppears = [decoder decodeObject];
        self.entryId = [decoder decodeObject];
	}
    NSString* icon = [self valueForKey:ENTRY_ICON];
    if (icon != nil) {
        [self defineImageFromLink:icon];
    }
	[self setVolatileFieldsToInitialValue];
	return self;
}

-(void)setVolatileFieldsToInitialValue {
	// TODO Set values for non volatil fields
}

#pragma mark -
#pragma mark NSCopying implementation

- (id)copyWithZone:(NSZone *)zone
{
    return NSCopyObject(self, 0, zone);
}

#pragma mark - Memory Management

-(void)dealloc {
	[imageURLString release];
	[image release];
	[attributes release];
	[pagesWhereItAppears release];
    [entryId release];
	[super dealloc];
}

#pragma mark - Compares only by EntryId

-(BOOL)isEqual:(id)anObject {
    if (![anObject isKindOfClass:[Entry class]]) {
        return NO;
    }
    Entry* other = anObject;
    if (entryId == nil) {
        return other.entryId == nil;
    }
    return [entryId isEqual:other.entryId];
}

-(NSUInteger)hash {
    if (entryId == nil) {
        return 0;
    }
    return [entryId hash];
}

@end
