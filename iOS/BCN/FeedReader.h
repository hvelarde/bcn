//
//  FeedReader.h
//  CromaFeeds
//
//  Created by Claudio Horvilleur on 5/13/10.
//  Copyright 2010 Cromasoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Model;
@class Entry;
@class GalleryItem;

@interface FeedReader : NSObject <NSXMLParserDelegate>{
	@private
	Model* model;
	NSDate* updateDate;
	NSMutableString* tmpValue;
	BOOL inEntry;
	NSMutableArray* entries;
	Entry* entry;
	NSDateFormatter* rfc3339DateFormater;
	NSArray* sorters;
	NSTimer* triggerTimer;
	NSMutableDictionary* feedAttributes;
	GalleryItem* galleryItem;
	BOOL inGalleryItem;
    BOOL started;
	BOOL working;
}

@property (nonatomic, retain) Model* model;
@property (nonatomic, retain) NSDate* updateDate;
@property (nonatomic, retain) NSMutableString* tmpValue;
@property (nonatomic, retain) NSMutableArray* entries;
@property (nonatomic, retain) Entry* entry;
@property (nonatomic, retain) NSDateFormatter* rfc3339DateFormater;
@property (nonatomic, retain) NSArray* sorters;
@property (nonatomic, retain) NSTimer* triggerTimer;
@property (nonatomic, retain) NSMutableDictionary* feedAttributes;
@property (nonatomic, retain) GalleryItem* galleryItem;

+(id)createWithModel:(Model*)model;
-(id)initWithModel:(Model*)model;

-(void)startOperation;
-(void)stopOperation;
-(void)refreshInfo;

@end
