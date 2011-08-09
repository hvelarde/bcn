//
//  Feed.h
//  CromaFeeds
//
//  Created by Claudio Horvilleur on 5/24/10.
//  Copyright 2010 Cromasoft. All rights reserved.
//
// Feed loaded from the net in a storable package

#import <Foundation/Foundation.h>

@interface Feed : NSObject <NSCoding> {
	NSDate* lastUpdate;
	NSArray* entries;
	NSDictionary* attributes;
}

@property (nonatomic, retain) NSDate* lastUpdate;
@property (nonatomic, retain) NSArray* entries;
@property (nonatomic, retain) NSDictionary* attributes;

+(id)initFromEntries:(NSArray*)entries updated:(NSDate*)update withAttributes:(NSDictionary*)attributes;
@end
