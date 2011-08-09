//
//  DataManager.h
//  BCN
//
//  Created by Claudio Horvilleur on 8/8/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Model;

@interface DataManager : NSObject <UITableViewDataSource, UITableViewDelegate> {
    Model* model;
    UITableView* tableView;
    UINavigationController* navigationController;
    @private
    BOOL notificationsEnabled;
}

@property (nonatomic, retain) Model* model;
@property (nonatomic, retain) UITableView* tableView;
@property (nonatomic, retain) UINavigationController* navigationController;

-(void)updateData;
-(void)enableAutomaticUpdate;
-(void)disableAutomaticUpdate;

@end
