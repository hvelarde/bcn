//
//  DataManager.m
//  BCN
//
//  Created by Claudio Horvilleur on 8/8/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import "DataManager.h"
#import "Model.h"
#import "CommonConstants.h"

@implementation DataManager

@synthesize model;
@synthesize tableView;
@synthesize navigationController;

#pragma mark - Memory management

-(void)dealloc {
    [self disableAutomaticUpdate];
    [model release];
    [tableView release];
    [navigationController release];
    [super dealloc];
}

#pragma mark - Control flags

-(BOOL)hideBackButton {
    return YES;
}

#pragma mark - Data access

// In general MUST be overriden by specific implementations
-(void)updateData {
    [tableView reloadData];
}

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

#pragma mark - DataSource

// The next two methods MUST BE OVERRIDEN!!!!
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

@end
