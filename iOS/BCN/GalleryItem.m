//
//  GalleryItem.m
//  CromaNews
//
//  Created by Claudio Horvilleur on 7/15/10.
//  Copyright 2010 Cromasoft. All rights reserved.
//

#import "GalleryItem.h"

#define	ATTRIBUTES				@"attributes"
#define	URL_STRING				@"urlString"
#define TITLE					@"title"
#define THUMBNAIL_URL_STRING	@"thumbnailUrlString"

@implementation GalleryItem

@synthesize urlString, title, attributes, thumbnailUrlString, thumbnailImage;

#pragma mark Creation and Initializations

-(id)initWithUrlString:(NSString*)str {
	self.urlString = str;
	return self;
}

#pragma mark -
#pragma mark Thumnail Image Management

-(BOOL)needThumbnailImageLoading {
	return (thumbnailImage == nil);
}

#pragma mark -
#pragma mark Save/Restore

- (void)encodeWithCoder:(NSCoder *)encoder {
	if ([encoder allowsKeyedCoding]) {
		[encoder encodeObject:attributes forKey:ATTRIBUTES];
		[encoder encodeObject:urlString forKey:URL_STRING];
		[encoder encodeObject:title forKey:TITLE];
		[encoder encodeObject:thumbnailUrlString forKey:THUMBNAIL_URL_STRING];
	} else {
		[encoder encodeObject:attributes];
		[encoder encodeObject:urlString];
		[encoder encodeObject:title];
		[encoder encodeObject:thumbnailUrlString];
	}	
	// The rest of the data is volatile.
}

- (id)initWithCoder:(NSCoder *)decoder {
	if ([decoder allowsKeyedCoding]) {
		self.attributes = [decoder decodeObjectForKey:ATTRIBUTES];
		self.urlString = [decoder decodeObjectForKey:URL_STRING];
		self.title = [decoder decodeObjectForKey:TITLE];
		self.thumbnailUrlString = [decoder decodeObjectForKey:THUMBNAIL_URL_STRING];
	} else {
		self.attributes = [decoder decodeObject];
		self.urlString = [decoder decodeObject];
		self.title = [decoder decodeObject];
		self.thumbnailUrlString = [decoder decodeObject];
	}
	return self;
}

#pragma mark -
#pragma mark General

-(void)dealloc {
	[attributes release];
	[thumbnailImage release];
	[thumbnailUrlString release];
	[title release];
	[urlString release];
	[super dealloc];
}


@end
