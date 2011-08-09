//
//  NoteCell.h
//  BCN
//
//  Created by Claudio Horvilleur on 8/8/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Entry;

@interface NoteCell : UITableViewCell {
    
}

+(id)create;

-(void)defineContent:(Entry*)entry;

@end
