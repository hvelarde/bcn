//
//  WebViewController.m
//  BCN
//
//  Created by Claudio Horvilleur on 8/9/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import "WebViewController.h"


#pragma mark - Private Interface

@interface WebViewController()

-(void)apagarTrabajando;
-(void)prenderTrabajando;

@end

#pragma mark - Implementation

@implementation WebViewController

@synthesize pagina;
@synthesize webView;
@synthesize activityIndicator;

#pragma mark - Creation
+(id)createWithPage:(NSString*)page {
    return [[[WebViewController alloc] initWithPage:page] autorelease];
}

-(id)initWithPage:(NSString*)page {
    self = [super initWithNibName:@"WebViewController" bundle:nil];
    if (self) {
        self.pagina = page;
    }
    return self;
}

#pragma mark - Memory Management

- (void)dealloc {
    [webView release];
    [activityIndicator release];
    [pagina release];
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
    [self apagarTrabajando];
 }

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (pagina != nil) {
        NSString* pg = [pagina stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSURL* url = [NSURL URLWithString:pg];
        NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
        [webView loadRequest:urlRequest];       
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self apagarTrabajando];
}

#pragma mark - Activity indicators

-(void)apagarTrabajando {
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;
    [activityIndicator stopAnimating];
}

-(void)prenderTrabajando {
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
    [activityIndicator startAnimating];
}

#pragma mark -
#pragma mark WebView Delegate Methods

-(void)webView:(UIWebView *)view didFailLoadWithError:(NSError *)error {
    [self apagarTrabajando];
}

-(void)webViewDidFinishLoad:(UIWebView *)view {
    [self apagarTrabajando];
}

-(void)webViewDidStartLoad:(UIWebView *)view {
    [self prenderTrabajando];
}

@end
