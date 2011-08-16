//
//  NewsCell.h
//  CromaNews
//
//  Created by Claudio Horvilleur on 6/17/10.
//  Copyright 2010 Cromasoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsView;
@class Entry;

@interface NewsCell : UITableViewCell {
	NewsView* newsView;
}

@property (nonatomic, retain) NewsView* newsView;

+(id)createWithCellType:(NSInteger)cellType reuseIdentifier:(NSString *)reuseIdentifier;
- (id)initWithCellType:(NSInteger)cellType reuseIdentifier:(NSString *)reuseIdentifier;

-(void)setEntry:(Entry*)entry;

@end
