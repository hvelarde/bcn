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

@implementation Entry

@synthesize pagesWhereItAppears, attributes, image, imageURLString;

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
	NSLog(@"Pagina: %@", page);
	[pagesWhereItAppears addObject:page];
}

-(BOOL)appearsInPage:(NSString*)page {
	return [pagesWhereItAppears containsObject:page];
}

#pragma mark -
#pragma mark Image Management

-(void)defineImageFromLink:(NSString*)imageLink {
	self.imageURLString = imageLink;
	NSLog(@"image string: '%@' - '%@'", imageLink, imageURLString);
}

-(BOOL)hasImage {
	return (imageURLString != nil);
}

-(UIImage*)activeImage {
	if (image != nil) {
		return image;
	}
	if (![self hasImage]) {
		return nil;
	}
	return [UIImage imageNamed:@"light_gamers_57.png"];
}

-(BOOL)needImageLoading {
	return (imageURLString != nil) && (image == nil);
}

#pragma mark -
#pragma mark Save/Restore

- (void)encodeWithCoder:(NSCoder *)encoder {
	if ([encoder allowsKeyedCoding]) {
		[encoder encodeObject:attributes forKey:ATTRIBUTES];
		[encoder encodeObject:pagesWhereItAppears forKey:PAGES];
	} else {
		[encoder encodeObject:attributes];
		[encoder encodeObject:pagesWhereItAppears];
	}	
	// The rest of the data is volatile.
}

- (id)initWithCoder:(NSCoder *)decoder {
	if ([decoder allowsKeyedCoding]) {
		self.attributes = [decoder decodeObjectForKey:ATTRIBUTES];
		self.pagesWhereItAppears = [decoder decodeObjectForKey:PAGES];
	} else {
		self.attributes = [decoder decodeObject];
		self.pagesWhereItAppears = [decoder decodeObject];
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

#pragma mark -
#pragma mark general

-(void)dealloc {
	[imageURLString release];
	[image release];
	[attributes release];
	[pagesWhereItAppears release];
	[super dealloc];
}

@end
