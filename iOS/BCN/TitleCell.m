//
//  TitleCell.m
//  BCN
//
//  Created by Claudio Horvilleur on 8/8/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import "TitleCell.h"
#import "CommonConstants.h"

@implementation TitleCell

@synthesize titleLabel;

+(id)create {
    return [[[TitleCell alloc] init] autorelease];
}

- (id)init {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TITLE_CELL_IDENTIFIER];
    if (self) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 5.0, 300.0, 25.0)];
        titleLabel.font = [UIFont systemFontOfSize:14.0];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.textColor = [UIColor blueColor];
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
