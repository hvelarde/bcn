//
//  SimpleCell.m
//  BCN
//
//  Created by Claudio Horvilleur on 8/9/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import "SimpleCell.h"
#import "CommonConstants.h"

@implementation SimpleCell

#pragma mark - Creation

+(id)create {
    return [[[SimpleCell alloc] init] autorelease];
}

- (id)init {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SIMPLE_CELL_IDENTIFIER];
    if (self) {
        // TODO Check if it must be modified
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark - Content Management
-(void)defineContent:(NSString*)content {
    self.textLabel.text = content;
}

@end
