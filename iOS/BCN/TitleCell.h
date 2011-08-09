//
//  TitleCell.h
//  BCN
//
//  Created by Claudio Horvilleur on 8/8/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TitleCell : UITableViewCell {
    @private
    UILabel* titleLabel;
}

@property (nonatomic, retain) UILabel* titleLabel;

+(id)create;
-(void)defineTitle:(NSString*)title;

@end
