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

@synthesize tableView;
@synthesize navigationController;

#pragma mark - Memory management

-(void)dealloc {
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

-(void)viewLoaded:(MyTableViewController*)controller {
    // To be overriden when the data manager has specific things to do after the view is loaded.
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
