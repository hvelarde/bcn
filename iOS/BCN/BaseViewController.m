//
//  BaseViewController.m
//  BCN
//
//  Created by Claudio Horvilleur on 8/9/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import "BaseViewController.h"


@implementation BaseViewController

#pragma mark - Actions

-(IBAction)homeButtonPushed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)backButtonPushed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
