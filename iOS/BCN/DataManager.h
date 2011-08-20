//
//  DataManager.h
//  BCN
//
//  Created by Claudio Horvilleur on 8/8/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Model;
@class MyTableViewController;

@interface DataManager : NSObject <UITableViewDataSource, UITableViewDelegate> {
    UITableView* tableView;
    UINavigationController* navigationController;
}

@property (nonatomic, retain) UITableView* tableView;
@property (nonatomic, retain) UINavigationController* navigationController;

-(void)updateData;
-(BOOL)hideBackButton;
-(void)viewLoaded:(MyTableViewController*)controller;
-(void)viewAppeared;

@end
