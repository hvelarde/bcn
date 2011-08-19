//
//  Bookmarks.h
//  BCN
//
//  Created by Claudio Horvilleur on 8/19/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataStorage.h"

@class Entry;

@interface Bookmarks : DataStorage <NSCoding> {
    @private
    NSMutableArray* entries;
}

@property (nonatomic, retain) NSMutableArray* entries;

+(id)createFromFile;

-(void)prepareForQueries;
-(BOOL)addEntry:(Entry*)entry;
-(BOOL)removeEntry:(Entry*)entry;
-(void)saveToFile;

@end
