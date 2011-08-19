//
//  TitleCell.m
//  BCN
//
//  Created by Claudio Horvilleur on 8/8/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import "TitleCell.h"
#import "CommonConstants.h"

#define RED_FACTOR      (71.0 / 255.0)
#define GREEN_FACTOR    (107.0 / 255.0)
#define BLUE_FACTOR     (157.0 / 255.0)

@implementation TitleCell

@synthesize titleLabel;

+(id)create {
    return [[[TitleCell alloc] init] autorelease];
}

- (id)init {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TITLE_CELL_IDENTIFIER];
    if (self) {
		NSLog(@"W: %f, h: %f", self.contentView.bounds.size.width, self.contentView.bounds.size.height);
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 5.0, 320.0, 34.0)];
        titleLabel.font = [UIFont systemFontOfSize:24.0];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor colorWithRed:RED_FACTOR
                                                     green:GREEN_FACTOR
                                                      blue:BLUE_FACTOR
                                                     alpha:1.0];
        [self.contentView addSubview:titleLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)dealloc
{
    [titleLabel release];
    [super dealloc];
}

-(void)defineTitle:(NSString*)title {
    titleLabel.text = title;
}

@end
