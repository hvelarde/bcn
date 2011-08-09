//
//  Entry.h
//  CromaFeeds
//
//  Created by Claudio Horvilleur on 5/24/10.
//  Copyright 2010 Cromasoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Photo;
@class Video;

@interface Entry : NSObject <NSCoding, NSCopying> {
	NSMutableDictionary* attributes;
	NSMutableSet* pagesWhereItAppears;
	UIImage* image;
	NSString* imageURLString;
	NSMutableArray* photoGallery;
	NSMutableArray* videoGallery;
}
@property (nonatomic, retain) NSMutableDictionary* attributes;
@property (nonatomic, retain) NSMutableSet* pagesWhereItAppears;
@property (nonatomic, retain) UIImage* image;
@property (nonatomic, retain) NSString* imageURLString;
@property (nonatomic, retain) NSMutableArray* photoGallery;
@property (nonatomic, retain) NSMutableArray* videoGallery;

+(Entry*)entry;

-(void)setVolatileFieldsToInitialValue;
-(BOOL)appearsInPage:(NSString*)page;
-(void)includeInPage:(NSString*)page;
-(id)valueForKey:(NSString*)key;
-(void)setValue:(NSObject*)value forKey:(NSString*)key;
-(void)defineImageFromLink:(NSString*)imageLink ;
-(UIImage*)activeImage;
-(BOOL)needImageLoading;
-(void)addPhotoToGallery:(Photo*)photo;
-(BOOL)hasPhotoGallery;
-(void)addVideoToGallery:(Video*)video;
-(BOOL)hasVideoGallery;
-(BOOL)hasImage;

@end
