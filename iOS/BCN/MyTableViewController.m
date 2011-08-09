//
//  MyViewController.m
//  BCN
//
//  Created by Claudio Horvilleur on 8/8/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import "MyTableViewController.h"
#import "DataManager.h"

@implementation MyTableViewController

@synthesize tableView;
@synthesize dataManager;

+(id)createWithDataManager:(DataManager*)dataManager {
    return [[[MyTableViewController alloc] initWithDataManager:dataManager] autorelease];
}

- (id)initWithDataManager:(DataManager*)dm
{
    self = [super initWithNibName:@"MyTableViewController" bundle:nil];
    if (self) {
        self.dataManager = dm;
    }
    return self;
}

#pragma mark - Memory management
- (void)dealloc
{
    [tableView release];
    [dataManager release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    dataManager.tableView = tableView;
    dataManager.navigationController = self.navigationController;
    tableView.dataSource = dataManager;
    tableView.delegate = dataManager;
    [dataManager updateData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
