//
//  ImageDownloader.h
//  CromaNews
//
//  Created by Claudio Horvilleur on 6/30/10.
//  Copyright 2010 Cromasoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageDownloader : NSObject {
	NSString* imageURLString;
	CGFloat requiredWidth;
	CGFloat requiredHeight;
	
	@private
	NSMutableData* activeDownload;
	NSURLConnection* imageConnection;
}

@property (nonatomic, retain) NSString* imageURLString;
@property (nonatomic, retain) NSMutableData* activeDownload;
@property (nonatomic, retain) NSURLConnection* imageConnection;

-(id)initWithURLString:(NSString*)urlString requiredWidth:(CGFloat)width requiredHeight:(CGFloat)height;
-(id)initWithURLString:(NSString*)urlString;
-(void)startDownload;
-(void)cancelDownload;
-(void)imageDidLoad:(UIImage*)image; // To be implemented by subclasses
-(void)imageDidNotLoad; // To be implemented by subclasses

@end
