//
//  ModelDataManager.m
//  BCN
//
//  Created by Claudio Horvilleur on 8/19/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import "ModelDataManager.h"
#import "Model.h"
#import "CommonConstants.h"
@implementation ModelDataManager

@synthesize model;

#pragma mark - Memory management

-(void)dealloc {
    [self disableAutomaticUpdate];
    [model release];
    [super dealloc];
}

#pragma mark - Control flags

#pragma mark - Updates management

-(void)enableAutomaticUpdate {
    if (notificationsEnabled) {
        return;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataUpdated:)
                                                 name:MODEL_UPDATED_NOTIFICATION
                                               object:nil];
    notificationsEnabled = YES;
}

-(void)disableAutomaticUpdate {
    if (!notificationsEnabled) {
        return;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MODEL_UPDATED_NOTIFICATION
                                                  object:nil];
    notificationsEnabled = NO;
}

-(void)dataUpdated:(NSNotification*)notification {
    [self updateData];
}


@end
