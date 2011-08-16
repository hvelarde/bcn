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

#define TITLE_FONT_SIZE     20
#define DETAIL_FONT_SIZE    20
#define DATE_FONT_SIZE      10
#define TITLE_HEIGHT        25
#define DETAIL_HEIGHT       25
#define DATE_HEIGHT         15
#define LEFT_MARGIN         10
#define RIGHT_MARGIN        10
#define TOP_MARGIN          5
#define MAX_IMAGE_WIDTH     60

@implementation NewsView

@synthesize entry;
@synthesize dateFormatter;

#pragma mark -
#pragma mark Creation methods

+(id)createWithFrame:(CGRect)frame cellType:(NSInteger)cellType {
    return [[[NewsView alloc] initWithFrame:frame cellType:cellType] autorelease];
}

-(id)initWithFrame:(CGRect)frame cellType:(NSInteger)cellType {
    if ((self = [super initWithFrame:frame]) != nil) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        newsCellType = cellType;
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        if (newsCellType == VIDEO_CELL_TYPE) {
            [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        } else {
            [dateFormatter setDateFormat:@"MMMM YYYY"];
        }
        self.backgroundColor = [UIColor whiteColor];
        self.opaque = YES;
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
	UIImage* image = [UIImage imageNamed:((newsCellType == DOCUMENT_CELL_TYPE) ?
                                          @"document-icon.png" : @"video-icon.png")];
	if (image != nil) {
		textsWidth -= MAX_IMAGE_WIDTH;
		CGFloat imageVPos = boundsY + (contentRect.size.height - image.size.height) / 2;
		CGFloat imageHPos = hPos + textsWidth + (MAX_IMAGE_WIDTH - image.size.width) / 2;
		CGRect area = CGRectMake(imageHPos, imageVPos, image.size.width, image.size.height);
		[image drawInRect:area];
	}
	[titleTextColor set];
	NSString* title = [entry valueForKey:ENTRY_TITLE];
	CGRect area = CGRectMake(hPos, vPos, textsWidth, TITLE_HEIGHT);
	[title drawInRect:area
			 withFont:titleFont
		lineBreakMode:UILineBreakModeTailTruncation
			alignment:UITextAlignmentLeft];
	vPos += TITLE_HEIGHT;
	[detailTextColor set];
	NSString* summary = [entry valueForKey:ENTRY_CONTENT_INFO];
	area = CGRectMake(hPos, vPos, textsWidth, DETAIL_HEIGHT);
	[summary drawInRect:area
			 withFont:detailFont
		lineBreakMode:UILineBreakModeTailTruncation
			alignment:UITextAlignmentLeft];
    vPos += DETAIL_HEIGHT;
	[dateTextColor set];
	area = CGRectMake(hPos, vPos, textsWidth, DATE_HEIGHT);
	NSDate* date = (NSDate*)[entry valueForKey:ENTRY_DATE_TIME];
	NSString* dateStr = [dateFormatter stringFromDate:date];
	[dateStr drawInRect:area
			   withFont:dateFont
		  lineBreakMode:UILineBreakModeWordWrap
			  alignment:UITextAlignmentLeft];
	//vPos += DATE_HEIGHT;
}

#pragma mark -
#pragma mark General

- (void)dealloc {
	[dateFormatter release];
	[entry release];
    [super dealloc];
}


@end
