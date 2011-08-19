//
//  DataStorage.h
//  BCN
//
//  Created by Claudio Horvilleur on 8/19/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Entry;

@interface DataStorage : NSObject {
    @protected
    NSArray* categories;
    NSArray* pages;
}

@property (nonatomic, retain) NSArray* categories;
@property (nonatomic, retain) NSArray* pages;

-(NSArray*)entriesInPage:(NSInteger)pageNumber;
-(NSInteger)numberOfEntriesInPage:(NSInteger)pageNumber;
-(Entry*)entry:(NSInteger)entryNumber inPage:(NSInteger)pageNumber;

-(void)loadCategoriesInfo;
-(void)buildPagesFromEntries:(NSArray*)entries;

+(NSString *)applicationDocumentsDirectory;

@end
