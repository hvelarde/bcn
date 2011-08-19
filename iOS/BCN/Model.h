//
//  Model.h
//  CromaFeeds
//
//  Created by Claudio Horvilleur on 5/13/10.
//  Copyright 2010 Cromasoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataStorage.h"
@class Feed;
@class Entry;
@class Category;

@interface Model : DataStorage <NSCoding> {
	@private
	NSDate* lastCheck;
	Feed* feed;
}

@property (nonatomic, retain) NSDate* lastCheck;
@property (nonatomic, retain) Feed* feed;

+(Model*)createFromFile;

-(void)updateFromEntries:(NSArray*)entries
                 updated:(NSDate*)update
          withAttributes:(NSDictionary*)attributes;
-(void)saveToFile;

@end
