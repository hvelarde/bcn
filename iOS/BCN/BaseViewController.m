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

@implementation BaseViewController

@synthesize entry;

#pragma mark - Actions

-(IBAction)homeButtonPushed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)backButtonPushed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

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
    [alert show];
    [alert release];
}

-(IBAction)forwardSelected:(id)sender {
    NSLog(@"Forward");
}


#pragma mark - Memory Management

-(void)dealloc {
    [entry release];
    [super dealloc];
}

#pragma mark - UIAlertViewDelegate Implementation

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [alertView firstOtherButtonIndex]) {
        // Solo atendemos al primer boton que no es el de cancelar
        return;
    }
    NSString* msg = nil;
    if (entry != nil) {
        Bookmarks* bookmarks = [Bookmarks createFromFile];
        if ([bookmarks addEntry:entry]) {
            msg = NSLocalizedString(@"noticia_agregada", @"Mensaje de noticia agregada");
        } else {
            msg = NSLocalizedString(@"noticia_no_agregada", @"Mensaje de noticia no agregada");
        }
    } else {
        msg = NSLocalizedString(@"ERROR_NO_ENTRY", @"Error por querer guardar una noticia que no se tiene");
    }
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:msg
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"CONTINUE_BUTTON", @"Continuar")
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

@end
