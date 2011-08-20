//
//  Entry.h
//  CromaFeeds
//
//  Created by Claudio Horvilleur on 5/24/10.
//  Copyright 2010 Cromasoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Video;

@interface Entry : NSObject <NSCoding, NSCopying> {
	NSMutableDictionary* attributes;
	NSMutableSet* pagesWhereItAppears;
	UIImage* image;
	NSString* imageURLString;
    NSString* entryId;
    BOOL imageIsLoading;
    UIView* newsView;
}

@property (nonatomic, retain) NSMutableDictionary* attributes;
@property (nonatomic, retain) NSMutableSet* pagesWhereItAppears;
@property (nonatomic, retain) UIImage* image;
@property (nonatomic, retain) NSString* imageURLString;
@property (nonatomic, retain) NSString* entryId;
@property (nonatomic, retain) UIView* newsView;
@property BOOL imageIsLoading;

+(Entry*)entry;

-(void)setVolatileFieldsToInitialValue;
-(BOOL)appearsInPage:(NSString*)page;
-(void)includeInPage:(NSString*)page;
-(id)valueForKey:(NSString*)key;
-(void)setValue:(NSObject*)value forKey:(NSString*)key;
-(void)defineImageFromLink:(NSString*)imageLink ;
-(BOOL)needImageLoading;
-(BOOL)hasImage;
-(void)storeLoadedImage:(UIImage*)loadedImage;

@end
