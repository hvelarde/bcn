//
//  ImageDownloader.m
//  CromaNews
//
//  Created by Claudio Horvilleur on 6/30/10.
//  Copyright 2010 Cromasoft. All rights reserved.
//

#import "ImageDownloader.h"

@implementation ImageDownloader

@synthesize imageURLString, activeDownload, imageConnection;

#pragma mark -
#pragma mark Initialization

-(id)initWithURLString:(NSString*)urlString requiredWidth:(CGFloat)width requiredHeight:(CGFloat)height {
	self.imageURLString = urlString;
	requiredWidth = width;
	requiredHeight = height;
	return self;
}

-(id)initWithURLString:(NSString*)urlString {
	return [self initWithURLString:urlString requiredWidth:0 requiredHeight:0];
}

#pragma mark -
#pragma mark Download commands

- (void)startDownload
{
    self.activeDownload = [NSMutableData data];
//	NSLog(@"Link: '%@'", imageURLString);
    // alloc+init and start an NSURLConnection; release on completion/failure
	NSURL *url = [NSURL URLWithString:imageURLString];
	NSURLRequest * request = [NSURLRequest requestWithURL: url];
//	NSLog(@"URL:%@ - '%@'", [[request URL] absoluteString], imageURLString);
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest: request
															delegate:self];
    self.imageConnection = conn;
    [conn release];
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}

#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"Error: %@ ", [error localizedDescription]);
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
	[self imageDidNotLoad];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Set appIcon and clear temporary data/image
    UIImage* image = [[UIImage alloc] initWithData:self.activeDownload];
	UIImage* finalImage = nil;
	if ((requiredWidth != 0) && (requiredHeight != 0)) {
		CGFloat widthFactor = image.size.width / requiredWidth;
		CGFloat heightFactor = image.size.height / requiredHeight;
		CGSize itemSize;
		BOOL mustResize = YES;
		if (widthFactor > heightFactor) {
			if (widthFactor == 1) {
				mustResize = NO;
			} else {
				CGFloat factor = heightFactor / widthFactor;
				itemSize = CGSizeMake(requiredWidth, requiredHeight * factor);
			}
		} else {
			if (heightFactor == 1) {
				mustResize = NO;
			} else {
				CGFloat factor = widthFactor / heightFactor;
				itemSize = CGSizeMake(requiredWidth * factor, requiredHeight);
			}
		}
		if (mustResize) {
			UIGraphicsBeginImageContext(itemSize);
			CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
			[image drawInRect:imageRect];
			finalImage = UIGraphicsGetImageFromCurrentImageContext();
			UIGraphicsEndImageContext();
		}
	}
    [self imageDidLoad:(finalImage ? finalImage : image)];
	[image release];
    // Release the connection now that it's finished
    self.imageConnection = nil;
}

#pragma mark -
#pragma mark General

-(void)dealloc {
	[imageURLString release];
	[activeDownload release];
	[imageConnection release];
	[super dealloc];
}

#pragma mark -
#pragma mark Abstract methods

-(void)imageDidLoad:(UIImage*)image {
	// The subclasses must replace this method to back feed the rest of the system
}

-(void)imageDidNotLoad {
	// The subclasses must replace this method to back feed the rest of the system
}

@end
