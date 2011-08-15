//
//  NewsCell.m
//  CromaNews
//
//  Created by Claudio Horvilleur on 6/17/10.
//  Copyright 2010 Cromasoft. All rights reserved.
//

#import "NewsCell.h"
#import "NewsView.h"

@implementation NewsCell

@synthesize newsView;

#pragma mark Table Cell methods

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		CGRect tzvFrame = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
		NSLog(@"W: %f, h: %f", tzvFrame.size.width, tzvFrame.size.height);
		self.newsView = [[[NewsView alloc] initWithFrame:tzvFrame] autorelease];
		newsView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.contentView addSubview:newsView];
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -
#pragma mark Data Management

-(void)setEntry:(Entry*)entry {
	newsView.entry = entry;
}

#pragma mark -
#pragma mark General

- (void)dealloc {
	[newsView release];
    [super dealloc];
}


@end
