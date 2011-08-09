//
//  BCNAppDelegate.h
//  BCN
//
//  Created by Claudio Horvilleur on 8/5/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Model;
@class FeedReader;

@interface BCNAppDelegate : NSObject <UIApplicationDelegate> {
    @private
    Model* model;
    FeedReader* feedReader;
    UINavigationController* navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) Model* model;
@property (nonatomic, retain) FeedReader* feedReader;
@property (nonatomic, retain) UINavigationController* navigationController;

@end
