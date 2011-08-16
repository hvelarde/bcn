//
//  PublicacionesDataManager.m
//  BCN
//
//  Created by Claudio Horvilleur on 8/15/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import "PublicacionesDataManager.h"
#import "TitleCell.h"
#import "Model.h"
#import "CommonConstants.h"
#import "NewsCell.h"
#import "PublicacionWebViewController.h"

@implementation PublicacionesDataManager

@synthesize pagina;
@synthesize tituloLista;
@synthesize publicaciones;

#pragma mark - Memory Management

-(void)dealloc {
    [tituloLista release];
    [publicaciones release];
    [super dealloc];
}

#pragma mark - Data Management

-(void)updateData {
    self.publicaciones = [model entriesInPage:pagina];
    [super updateData];
}

#pragma mark - Control flags

-(BOOL)hideBackButton {
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (publicaciones == nil) {
        NSLog(@"No hay modelo");
        return 1;
    }
    NSLog(@"El modelo tiene %d publicaciones", [publicaciones count]);
    return 1 + [publicaciones count];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row == 0) {
        TitleCell* cell = (TitleCell*)[tv dequeueReusableCellWithIdentifier:TITLE_CELL_IDENTIFIER];
        if (cell == nil) {
            cell = [TitleCell create];
        }
        [cell defineTitle:tituloLista];
        return cell;
    }
    Entry* entry = [model entry:(row - 1) inPage:pagina];
    NewsCell* cell = (NewsCell*) [tv dequeueReusableCellWithIdentifier:DOCUMENT_CELL_IDENTIFIER];
    if (cell == nil) {
        cell = [NewsCell createWithCellType:DOCUMENT_CELL_TYPE reuseIdentifier:DOCUMENT_CELL_IDENTIFIER];
    }
    [cell setEntry:entry];
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row == 0) {
        return TITLE_CELL_HEIGHT;
    }
    return DOCUMENT_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row == 0) {
        [tv deselectRowAtIndexPath:indexPath animated:NO];
        return;
    }
    Entry* entry = [model entry:(row - 1) inPage:pagina];
    UIViewController *detailViewController = [PublicacionWebViewController createWithEntry:entry];
    [navigationController pushViewController:detailViewController animated:YES];
    [tv deselectRowAtIndexPath:indexPath animated:NO];
}

@end
