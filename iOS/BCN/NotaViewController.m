//
//  NotaViewController.m
//  BCN
//
//  Created by Claudio Horvilleur on 8/9/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import "NotaViewController.h"
#import "Entry.h"
#import "Formateo.h"
#import "CommonConstants.h"
#import "WebViewController.h"

#define BUTTONS_HEIGHT  50
#define MARGIN          10

#pragma mark - Private interface

@interface NotaViewController()

-(void)buildContent;
-(void)pdfSelected:(id)sender;
-(void)conferenciaSelected:(id)sender;

@end

#pragma mark - Implementation
@implementation NotaViewController

@synthesize entry;
@synthesize increaseFontItem;
@synthesize decreaseFontItem;
@synthesize scrollView;

#pragma mark - Creation

+(id)createWithEntry:(Entry*)entry {
    return [[[NotaViewController alloc] initWithEntry:entry] autorelease];
}

-(id)initWithEntry:(Entry*)e {
    self = [super initWithNibName:@"NotaViewController" bundle:nil];
    if (self) {
        self.entry = e;
        fontSize = 16.0;
    }
    return self;
}

#pragma mark - Memory Management

- (void)dealloc {
    [entry release];
    [increaseFontItem release];
    [decreaseFontItem release];
    [scrollView release];
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
    [self buildContent];
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

#pragma mark - Actions

-(IBAction)bookmarkSelected:(id)sender {
    NSLog(@"bookmark");
}

-(IBAction)forwardSelected:(id)sender {
    NSLog(@"Forward");
}

-(IBAction)increaseFontSelected:(id)sender {
    NSLog(@"Increase Font");
}

-(IBAction)decreaseFontSelected:(id)sender {
    NSLog(@"Decrease Font");
}

-(void)pdfSelected:(id)sender {
    NSString* pagina = [entry valueForKey:CONTENT];
    WebViewController* wvc = [WebViewController createWithPage:pagina];
    [self.navigationController pushViewController:wvc animated:YES];
}

-(void)conferenciaSelected:(id)sender {
    NSLog(@"Ver conferencia");
}

#pragma mark - Content Management

-(void)buildContent {
    NSEnumerator* enumerator = [scrollView.subviews reverseObjectEnumerator];
    UIView* hijo = nil;
    while ((hijo = (UIView*)[enumerator nextObject]) != nil) {
        [hijo removeFromSuperview];
    }
    CGRect frm = scrollView.frame;
    Formateo* formateo = [Formateo createWithFontSize:fontSize];
    NSMutableAttributedString* contenido = [formateo preparaBuffer];
    NSString* linea;
    linea = [entry valueForKey:ENTRY_TITLE];
    NSLog(@"Titulo: '%@'", linea);
    [formateo agregaParrafoBold:linea
                         buffer:contenido];
    linea = [entry valueForKey:ENTRY_SUMMARY];
    NSLog(@"Resumen: '%@'", linea);
    [formateo agregaParrafo:linea
                     buffer:contenido];
    [formateo finalizaBuffer:contenido];
    NSInteger textWidth = frm.size.width - 2 * MARGIN; 
    UIImage* imagenTexto = [formateo armaContenidoFlotante:contenido ancho:frm.size.width altoMaximo:1000];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:imagenTexto];
    imageView.frame = CGRectMake(MARGIN, MARGIN, textWidth, imagenTexto.size.height);
    [scrollView addSubview:imageView];
    NSInteger pos = imagenTexto.size.height + 2 * MARGIN;
    if ((pos + BUTTONS_HEIGHT) < frm.size.height) {
        pos = frm.size.height - BUTTONS_HEIGHT;
    }
    UIButton* pdfButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* buttonImage = [UIImage imageNamed:@"nota-pdf.png"];
    [pdfButton setImage:buttonImage forState:UIControlStateNormal];
    [pdfButton addTarget:self
                  action:@selector(pdfSelected:)
        forControlEvents:UIControlEventTouchUpInside];
    pdfButton.frame = CGRectMake(MARGIN, pos, buttonImage.size.width, buttonImage.size.height);
    [scrollView addSubview:pdfButton];
    UIButton* conferenciaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [conferenciaButton addTarget:self
                          action:@selector(conferenciaSelected:)
                forControlEvents:UIControlEventTouchUpInside];
    buttonImage = [UIImage imageNamed:@"nota-conferencia.png"];
    [conferenciaButton setImage:buttonImage forState:UIControlStateNormal];
    NSInteger buttonWidth = buttonImage.size.width;
    conferenciaButton.frame = CGRectMake(frm.size.width - MARGIN - buttonWidth, pos, buttonWidth, buttonImage.size.height);
    conferenciaButton.enabled = NO; // TODO Ver cuando se activa
    [scrollView addSubview:conferenciaButton];
    scrollView.contentSize = CGSizeMake(frm.size.width, pos + BUTTONS_HEIGHT);
}

@end
