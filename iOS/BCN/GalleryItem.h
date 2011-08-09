//
//  GalleryItem.h
//  CromaNews
//
//  Created by Claudio Horvilleur on 7/15/10.
//  Copyright 2010 Cromasoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GalleryItem : NSObject <NSCoding> {
	NSMutableDictionary* attributes;
	NSString* urlString;
	NSString* title;
	NSString* thumbnailUrlString;
	UIImage* thumbnailImage;
}

@property (nonatomic, retain) NSMutableDictionary* attributes;
@property (nonatomic, retain) NSString* urlString;
@property (nonatomic, retain) NSString* title; 
@property (nonatomic, retain) NSString* thumbnailUrlString; 
@property (nonatomic, retain) UIImage* thumbnailImage;


-(id)initWithUrlString:(NSString*)urlString;
-(BOOL)needThumbnailImageLoading;

@end
