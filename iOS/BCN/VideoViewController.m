//
//  VideoViewController.m
//  BCN
//
//  Created by Claudio Horvilleur on 8/15/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import "VideoViewController.h"
#import "CommonConstants.h"
#import "Entry.h"

@implementation VideoViewController

@synthesize display;
@synthesize video;

#pragma mark - Creation

+(id)createWithEntry:(Entry*)entry {
    return [[[VideoViewController alloc] initWithEntry:entry] autorelease];
}

-(id)initWithEntry:(Entry*)e {
    self = [super initWithNibName:@"VideoViewController" bundle:nil];
    if (self) {
        self.entry = e;
        self.video = [e valueForKey:VIDEO];
    }
    return self;
}

#pragma mark - Memory Management

- (void)dealloc {
    [video release];
    [display release];
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
    // Do any additional setup after loading the view from its nib.
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
