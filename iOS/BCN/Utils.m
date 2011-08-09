//
//  Utils.m
//  BCN
//
//  Created by Claudio Horvilleur on 8/8/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import "Utils.h"
#import "CommonConstants.h"

#define TITLE_TAG   0

@implementation Utils

#pragma mark - Navigation bar configuration

+(void)buildTop:(UIViewController*)viewController {
    UIImage* image = [UIImage imageNamed:@"escudo.png"];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    viewController.navigationItem.titleView = imageView;
    [imageView release];
    // TODO Check if we have to place any other info on top
}

@end
