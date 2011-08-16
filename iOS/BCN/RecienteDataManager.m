//
//  RecienteDataManager.m
//  BCN
//
//  Created by Claudio Horvilleur on 8/15/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import "RecienteDataManager.h"
#import "CommonConstants.h"
#import "Model.h"
#import "Entry.h"
#import "TitleCell.h"
#import "NoteCell.h"
#import "NewsCell.h"
#import "NotaViewController.h"
#import "PublicacionWebViewController.h"
#import "VideoViewController.h"

#pragma mark - Private Interface

@interface RecienteDataManager()

-(NSArray*)entriesInPage:(NSInteger)page after:(NSDate*)date;

@end

#pragma mark - Implementation

@implementation RecienteDataManager

@synthesize notas;
@synthesize publicaciones;
@synthesize conferencias;

#pragma mark - Memory Management

-(void)dealloc {
    [notas release];
    [publicaciones release];
    [conferencias release];
    [super dealloc];
}

#pragma mark - Data Management

-(void)updateData {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDate* now = [NSDate date];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents* components = [calendar components:unitFlags
                                               fromDate:now];
    NSDate* today = [calendar dateFromComponents:components];
    NSDateComponents* dateDelay = [[NSDateComponents alloc] init];
    [dateDelay setDay:-7];
    NSDate* limit = [calendar dateByAddingComponents:dateDelay toDate:today options:0];
    [dateDelay release];
    self.notas = [self entriesInPage:PAGINA_NOTAS after:limit];
    self.publicaciones = [self entriesInPage:PAGINA_DOCUMENTOS after:limit];
    self.conferencias = [self entriesInPage:PAGINA_VIDEOS after:limit];
    [super updateData];
}

-(NSArray*)entriesInPage:(NSInteger)page after:(NSDate *)date {
    NSArray* all = [model entriesInPage:page];
    NSMutableArray* resp = [NSMutableArray arrayWithCapacity:5];
    NSInteger count = [all count];
    for (int i = 0; i < count; i++) {
        Entry* entry = [all objectAtIndex:i];
        NSDate* entryDate = [entry valueForKey:ENTRY_DATE_TIME];
        if ([date timeIntervalSinceDate:entryDate] > 0) {
            continue;
        }
        [resp addObject:entry];
    }
    return resp;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 1:
            return NSLocalizedString(@"titulo_notas", @"Titulo de la pagina de notas");
        case 2:
            return NSLocalizedString(@"publicaciones", @"Titulo de la pagina listado de publicaciones");
        case 3:
            return NSLocalizedString(@"titulo_videos", @"Titulo de la pagina de videos");
        default:
            return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return [notas count];
        case 2:
            return [publicaciones count];
        case 3:
            return [conferencias count];
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case 0:
        {
            TitleCell* cell = (TitleCell*)[tv dequeueReusableCellWithIdentifier:TITLE_CELL_IDENTIFIER];
            if (cell == nil) {
                cell = [TitleCell create];
            }
            [cell defineTitle:NSLocalizedString(@"titulo_recientes", @"Titulo de la pagina de recientes")];
            return cell;
        }
        case 1:
        {
            NoteCell* cell = (NoteCell*) [tv dequeueReusableCellWithIdentifier:NOTE_CELL_IDENTIFIER];
            if (cell == nil) {
                cell = [NoteCell create];
            }
            Entry* entry = [notas objectAtIndex:row];
            [cell defineContent:entry];
            return cell;
        }
        case 2:
        {
            NewsCell* cell = (NewsCell*) [tv dequeueReusableCellWithIdentifier:DOCUMENT_CELL_IDENTIFIER];
            if (cell == nil) {
                cell = [NewsCell createWithCellType:DOCUMENT_CELL_TYPE reuseIdentifier:DOCUMENT_CELL_IDENTIFIER];
            }
            Entry* entry = [publicaciones objectAtIndex:row];
            [cell setEntry:entry];
            return cell;
        }
        case 3:
        {
            NewsCell* cell = (NewsCell*) [tv dequeueReusableCellWithIdentifier:VIDEO_CELL_IDENTIFIER];
            if (cell == nil) {
                cell = [NewsCell createWithCellType:VIDEO_CELL_TYPE reuseIdentifier:VIDEO_CELL_IDENTIFIER];
            }
            Entry* entry = [conferencias objectAtIndex:row];
            [cell setEntry:entry];
            return cell;
        }
        default:
            return nil;
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    switch (section) {
        case 0:
            return TITLE_CELL_HEIGHT;
        case 1:
            return NOTE_CELL_HEIGHT;
        case 2:
            return DOCUMENT_CELL_HEIGHT;
        case 3:
            return VIDEO_CELL_HEIGHT;
        default:
            return SIMPLE_CELL_HEIGHT;
    }
}


- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    UIViewController* detailViewController = nil;
    switch (section) {
        case 0:
            break;
        case 1:
        {
            Entry* entry = [notas objectAtIndex:row];
            detailViewController = [NotaViewController createWithEntry:entry];
            break;
        }
        case 2:
        {
            Entry* entry = [publicaciones objectAtIndex:row];
            detailViewController = [PublicacionWebViewController createWithEntry:entry];
            break;
        }
        case 3:
        {
            Entry* entry = [conferencias objectAtIndex:row];
            detailViewController = [VideoViewController createWithEntry:entry];
            break;
        }
        default:
            break;
    }
    if (detailViewController != nil) {
        [navigationController pushViewController:detailViewController animated:YES];

    }
    [tv deselectRowAtIndexPath:indexPath animated:NO];
}

@end
