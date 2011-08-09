//
//  Model.h
//  CromaFeeds
//
//  Created by Claudio Horvilleur on 5/13/10.
//  Copyright 2010 Cromasoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Feed;
@class Entry;
@class Category;

@interface Model : NSObject <NSCoding> {
	NSArray* categories;
	@private
	NSDate* lastCheck;
	NSArray* pages;
	Feed* feed;
	NSString* writableDBPath;
}

@property (nonatomic, retain) NSDate* lastCheck;
@property (nonatomic, retain) NSArray* pages;
@property (nonatomic, retain) Feed* feed;
@property (nonatomic, retain) NSArray* categories;
@property (nonatomic, retain) NSString* writableDBPath;

+(Model*)createFromFile;

-(NSArray*)entriesInPage:(NSInteger)pageNumber;
-(NSInteger)numberOfEntriesInPage:(NSInteger)pageNumber;
-(Entry*)entry:(NSInteger)entryNumber inPage:(NSInteger)pageNumber;

-(void)updateFromEntries:(NSArray*)entries updated:(NSDate*)update withAttributes:(NSDictionary*)attributes;
-(void)saveToFile;

@end
