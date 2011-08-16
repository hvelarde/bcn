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

#pragma mark - Creation

+(id)createWithCellType:(NSInteger)cellType reuseIdentifier:(NSString *)reuseIdentifier {
    return [[[NewsCell alloc] initWithCellType:cellType reuseIdentifier:reuseIdentifier] autorelease];
}

- (id)initWithCellType:(NSInteger)cellType reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) != nil) {
        // Initialization code
		CGRect tzvFrame = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
		self.newsView = [NewsView createWithFrame:tzvFrame cellType:cellType];		
		[self.contentView addSubview:newsView];
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

#pragma mark - Table Cell methods

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
