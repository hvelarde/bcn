//
//  MyViewController.h
//  BCN
//
//  Created by Claudio Horvilleur on 8/8/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class DataManager;

@interface MyTableViewController : BaseViewController {
    UITableView* tableView;
    DataManager* dataManager;
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) DataManager* dataManager;

+(id)createWithDataManager:(DataManager*)dataManager;
-(id)initWithDataManager:(DataManager*)dataManager;

@end
