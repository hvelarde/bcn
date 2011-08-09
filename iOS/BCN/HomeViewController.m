//
//  HomeViewController.m
//  BCN
//
//  Created by Claudio Horvilleur on 8/5/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import "HomeViewController.h"
#import "NotasDataManager.h"
#import "MyTableViewController.h"

@implementation HomeViewController

@synthesize model;

#pragma mark - Creation

+(id)createWithModel:(Model*)model {
    return [[[HomeViewController alloc] initWithModel:model] autorelease];
}

-(id)initWithModel:(Model*)mod {
    self = [super initWithNibName:@"HomeViewController" bundle:nil];
    if (self) {
        self.model = mod;
    }
    return self;
}

#pragma mark - Memory Management
- (void)dealloc
{
    [model release];
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

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
}

#pragma mark - Actions

-(IBAction)indicadoresSelected:(id)sender {
    // TODO Activar pantalla de indicadores
    NSLog(@"indicadoresSelected");
}

-(IBAction)publicacionesSelected:(id)sender {
    // TODO Activar pantalla de publicaciones
    NSLog(@"publicacionesSelected");
}

-(IBAction)notasSelected:(id)sender {
    NotasDataManager* dataManager = [[NotasDataManager alloc] init];
    dataManager.model = model;
    MyTableViewController* mvc = [MyTableViewController createWithDataManager:dataManager];
    [dataManager release];
    [self.navigationController pushViewController:mvc animated:YES];
}

-(IBAction)conferenciasSelected:(id)sender {
    // TODO Activar pantalla de conferencias
    NSLog(@"conferenciasSelected");
}

-(IBAction)recienteSelected:(id)sender {
    // TODO Activar pantalla de recientes
    NSLog(@"recienteSelected");
}

-(IBAction)marcadoresSelected:(id)sender {
    // TODO Activar pantalla de marcadores
    NSLog(@"marcadoresSelected");
}

@end
