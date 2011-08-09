//
//  NoteCell.m
//  BCN
//
//  Created by Claudio Horvilleur on 8/8/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import "NoteCell.h"
#import "CommonConstants.h"
#import "Entry.h"

@implementation NoteCell

+(id)create {
    return [[[NoteCell alloc] init] autorelease];
}

- (id)init {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NOTE_CELL_IDENTIFIER];
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

-(void)defineContent:(Entry*)entry {
    self.textLabel.text = [entry valueForKey:ENTRY_TITLE];
    self.detailTextLabel.text = [NSDateFormatter localizedStringFromDate:[entry valueForKey:ENTRY_DATE_TIME]
                                                               dateStyle:NSDateFormatterLongStyle
                                                               timeStyle:NSDateFormatterNoStyle];
}


@end
