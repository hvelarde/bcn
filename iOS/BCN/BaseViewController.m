//
//  BaseViewController.m
//  BCN
//
//  Created by Claudio Horvilleur on 8/9/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import "BaseViewController.h"
#import "Entry.h"
#import "Bookmarks.h"
#import "CommonConstants.h"
#import "SHK.h"
#import "SHKTwitter.h"
#import "SHKFacebook.h"

#define BOOKMARK_ALERT_TAG  1
#define FORWARD_ALERT_TAG   2

#pragma mark - Private interface

@interface BaseViewController()

-(void)displayAlert:(NSString*)title msg:(NSString*)msg;
-(void)displayAlert:(NSString*)title;
-(void)sendToFacebook;
-(void)sendToTwitter;
-(void)sendToEmail;
-(void)sendToClipboard;

@end

#pragma mark - Implementation

@implementation BaseViewController

@synthesize entry;
@synthesize shkSharer;

#pragma mark - Actions

-(IBAction)homeButtonPushed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)backButtonPushed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// Should be overriden by those children who have a filter option
-(IBAction)buscarButtonPushed:(id)sender {
    NSLog(@"Buscar");
}

-(IBAction)bookmarkSelected:(id)sender {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"agregar_noticia",
                                                                              @"Mensaje de agregar noticia")
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"boton_cancelar", @"Boton de Cancelar")
                                          otherButtonTitles:NSLocalizedString(@"boton_aceptar", @"Boton de Aceptar"), nil];
    alert.tag = BOOKMARK_ALERT_TAG;
    [alert show];
    [alert release];
}

-(IBAction)forwardSelected:(id)sender {
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"boton_cancelar", @"Boton de Cancelar")
                                          otherButtonTitles:
                          NSLocalizedString(@"boton_facebook", @"Boton de enviar a facebook"),
                          NSLocalizedString(@"boton_twitter", @"Boton de enviar a twitter"),
                          NSLocalizedString(@"boton_email", @"Boton de enviar a email"),
                          NSLocalizedString(@"boton_clipboard", @"Boton de enviar a clipboard"),
                          nil];
    alert.tag = FORWARD_ALERT_TAG;
    [alert show];
    [alert release];
}


#pragma mark - Memory Management

-(void)dealloc {
    [entry release];
    [shkSharer release];
    [super dealloc];
}

#pragma mark - UIAlertViewDelegate Implementation

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) {
        return;
    }
    NSString* msg = nil;
    if (entry != nil) {
        switch (alertView.tag) {
            case BOOKMARK_ALERT_TAG:
            {
                Bookmarks* bookmarks = [Bookmarks createFromFile];
                if ([bookmarks addEntry:entry]) {
                    msg = NSLocalizedString(@"noticia_agregada", @"Mensaje de noticia agregada");
                } else {
                    msg = NSLocalizedString(@"noticia_no_agregada", @"Mensaje de noticia no agregada");
                }
            }
                break;
            case FORWARD_ALERT_TAG:
                switch (buttonIndex - [alertView firstOtherButtonIndex]) {
                    case 0:
                        // [self sendToFacebook];
                        [self performSelector:@selector(sendToFacebook) withObject:nil afterDelay:0];
                        break;
                    case 1:
                        [self sendToTwitter];
                        break;
                    case 2:
                        [self sendToEmail];
                        break;
                    case 3:
                        [self sendToClipboard];
                        break;
                        
                    default:
                        break;
                }
            default:
                break;
        }
    } else {
        msg = NSLocalizedString(@"ERROR_NO_ENTRY", @"Error por querer guardar una noticia que no se tiene");
    }
    [self displayAlert:msg];
}

#pragma mark - Forward processing
-(void)sendToFacebook {
    NSLog(@"Facebook");
    SHKItem* item = [SHKItem URL:[NSURL URLWithString:[entry valueForKey:CONTENT]]
                           title:[entry valueForKey:ENTRY_TITLE]];
    self.shkSharer = [SHKFacebook shareItem:item];
    /*
    [SHK setRootViewController:self.navigationController];
    shkSharer.shareDelegate = self;
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
	[actionSheet showFromToolbar:self.navigationController.toolbar]; 
     */
}

-(void)sendToTwitter {
    NSLog(@"Twitter");
    self.shkSharer = [SHKTwitter shareURL:[NSURL URLWithString:[entry valueForKey:CONTENT]]
                                    title:NSLocalizedString(@"titulo_twitter", @"Titulo para los envios a twitter")];
    shkSharer.shareDelegate = self;
}

-(void)sendToEmail {
    NSLog(@"eMail");
    if (![MFMailComposeViewController canSendMail]) {
        [self displayAlert:NSLocalizedString(@"configurar_correo", @"El mail no esta configurado")];
         return;
    }
    MFMailComposeViewController* mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer setSubject:[entry valueForKey:ENTRY_TITLE]];
    [mailComposer setMessageBody:[entry valueForKey:CONTENT] isHTML:NO];
    [self presentModalViewController:mailComposer animated:YES];
    [mailComposer release];
}

-(void)sendToClipboard {
    NSLog(@"Clipboard");
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [entry valueForKey:CONTENT];
}

#pragma mark - General Alert displays

-(void)displayAlert:(NSString*)title msg:(NSString*)msg {
    if (title == nil) {
        return;
    }
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"CONTINUE_BUTTON", @"Continuar")
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(void)displayAlert:(NSString*)title {
    [self displayAlert:title msg:nil];
}

#pragma mark - Mail Delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    NSString* msg = nil;
    NSString* title = nil;
    switch (result) {
        case MFMailComposeResultCancelled:
            title = NSLocalizedString(@"email_canceled", @"Correo cancelado");
            break;
        case MFMailComposeResultSent:
            title = NSLocalizedString(@"email_sent", @"Correo enviado");
            break;
        case MFMailComposeResultSaved:
            title = NSLocalizedString(@"email_saved", @"Correo guardado");
            break;
        case MFMailComposeResultFailed:
            title = NSLocalizedString(@"NO_MAIL", @"No se puede enviar el correo");
            msg = NSLocalizedString(@"email_failed", @"Fallo envio correo");
            break;
            
        default:
            break;
    }
    [self displayAlert:title msg:msg];
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - SHKSharerDelegate implementation

- (void)sharerStartedSending:(SHKSharer *)sharer{
    NSLog(@"Sharer Started");
}

- (void)sharerFinishedSending:(SHKSharer *)sharer{
    NSLog(@"Sharer Finished");
    [self displayAlert:NSLocalizedString(@"share_sent", @"Envio exitoso")];
    self.shkSharer = nil;
}

- (void)sharer:(SHKSharer *)sharer failedWithError:(NSError *)error shouldRelogin:(BOOL)shouldRelogin{
    NSLog(@"Sharer Failed");
    [self displayAlert:NSLocalizedString(@"share_error", @"Error de envio")];
    self.shkSharer = nil;
}

- (void)sharerCancelledSending:(SHKSharer *)sharer {
    NSLog(@"Sharer Cancel");
    [self displayAlert:NSLocalizedString(@"share_cancel", @"Cancelaron el envio")];
    self.shkSharer = nil;
}

@end
