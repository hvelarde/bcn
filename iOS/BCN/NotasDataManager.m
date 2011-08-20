//
//  NotasDataManager.m
//  BCN
//
//  Created by Claudio Horvilleur on 8/8/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import "NotasDataManager.h"
#import "Model.h"
#import "CommonConstants.h"
#import "TitleCell.h"
#import "NoteCell.h"
#import "NotaViewController.h"

@implementation NotasDataManager

@synthesize notas;

#pragma mark - Memory Management
-(void)dealloc {
    [notas release];
    [super dealloc];
}

#pragma mark - Data Management

-(void)updateData {
    self.notas = [model entriesInPage:PAGINA_NOTAS];
    [super updateData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (notas == nil) {
        return 1;
    }
    return 1 + [notas count];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row == 0) {
        TitleCell* cell = (TitleCell*)[tv dequeueReusableCellWithIdentifier:TITLE_CELL_IDENTIFIER];
        if (cell == nil) {
            cell = [TitleCell create];
        }
        [cell defineTitle:NSLocalizedString(@"titulo_notas", @"Titulo de la pagina de notas")];
        return cell;
    }
    Entry* entry = [model entry:(row - 1) inPage:PAGINA_NOTAS];
    NoteCell* cell = (NoteCell*) [tv dequeueReusableCellWithIdentifier:NOTE_CELL_IDENTIFIER];
    if (cell == nil) {
        cell = [NoteCell create];
    }
    [cell defineContent:entry];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row == 0) {
        [tv deselectRowAtIndexPath:indexPath animated:NO];
        return;
    }
    Entry* entry = [model entry:(row - 1) inPage:PAGINA_NOTAS];
    UIViewController *detailViewController = [NotaViewController createWithEntry:entry];
    [navigationController pushViewController:detailViewController animated:YES];
    [tv deselectRowAtIndexPath:indexPath animated:NO];
}

@end
