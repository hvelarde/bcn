//
//  NewsView.m
//  CromaNews
//
//  Created by Claudio Horvilleur on 6/17/10.
//  Copyright 2010 Cromasoft. All rights reserved.
//

#import "NewsView.h"
#import "CommonConstants.h"
#import "Entry.h"

#pragma mark Font sizes

#define DATE_FONT_SIZE			10
#define TITLE_FONT_SIZE			16
#define DETAIL_FONT_SIZE		12

#pragma mark -
#pragma mark Sizes and positions

#define	LEFT_MARGIN				10
#define	RIGHT_MARGIN			10
#define MAX_IMAGE_WIDTH			60
#define TOP_MARGIN				8
#define	DATE_HEIGHT				12
#define TITLE_HEIGHT			42
#define DETAIL_HEIGHT			30

@implementation NewsView

@synthesize entry, dateFormatter;

#pragma mark -
#pragma mark View methods

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
		[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
		self.opaque = YES;
		self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
	UIColor* dateTextColor = [UIColor blueColor];
	UIFont* dateFont = [UIFont systemFontOfSize:DATE_FONT_SIZE];
	UIColor* titleTextColor = [UIColor blackColor];
	UIFont* titleFont = [UIFont systemFontOfSize:TITLE_FONT_SIZE];
	UIColor* detailTextColor = [UIColor blackColor];
	UIFont* detailFont = [UIFont systemFontOfSize:DETAIL_FONT_SIZE];
	CGRect contentRect = self.bounds;
	CGFloat boundsX = contentRect.origin.x;
	CGFloat boundsY = contentRect.origin.y;
	CGFloat hPos = boundsX + LEFT_MARGIN;
	CGFloat vPos = boundsY + TOP_MARGIN;
	CGFloat textsWidth = contentRect.size.width - LEFT_MARGIN - RIGHT_MARGIN;
	UIImage* image = [entry activeImage];
	if (image != nil) {
		textsWidth -= MAX_IMAGE_WIDTH;
		CGFloat imageVPos = boundsY + (contentRect.size.height - image.size.height) / 2;
		CGFloat imageHPos = hPos + textsWidth + (MAX_IMAGE_WIDTH - image.size.width) / 2;
		CGRect area = CGRectMake(imageHPos, imageVPos, image.size.width, image.size.height);
		[image drawInRect:area];
	}
	[dateTextColor set];
	CGRect area = CGRectMake(hPos, vPos, textsWidth, DATE_HEIGHT);
	NSDate* date = (NSDate*)[entry valueForKey:ENTRY_DATE_TIME];
	NSString* dateStr = [dateFormatter stringFromDate:date]; // Cambiarlo por la fecha del entry
	[dateStr drawInRect:area
			   withFont:dateFont
		  lineBreakMode:UILineBreakModeWordWrap
			  alignment:UITextAlignmentLeft];
	vPos += DATE_HEIGHT;
	[titleTextColor set];
	NSString* title = [entry valueForKey:ENTRY_TITLE];
	area = CGRectMake(hPos, vPos, textsWidth, TITLE_HEIGHT);
	[title drawInRect:area
			 withFont:titleFont
		lineBreakMode:UILineBreakModeTailTruncation
			alignment:UITextAlignmentLeft];
	vPos += TITLE_HEIGHT;
	[detailTextColor set];
	NSString* summary = [entry valueForKey:ENTRY_SUMMARY];
	area = CGRectMake(hPos, vPos, textsWidth, DETAIL_HEIGHT);
	[summary drawInRect:area
			 withFont:detailFont
		lineBreakMode:UILineBreakModeTailTruncation
			alignment:UITextAlignmentLeft];
}

#pragma mark -
#pragma mark General

- (void)dealloc {
	[dateFormatter release];
	[entry release];
    [super dealloc];
}


@end
