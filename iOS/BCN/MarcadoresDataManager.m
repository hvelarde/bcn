//
//  MarcadoresDataManager.m
//  BCN
//
//  Created by Claudio Horvilleur on 8/19/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import "MarcadoresDataManager.h"
#import "CommonConstants.h"
#import "Entry.h"
#import "TitleCell.h"
#import "NoteCell.h"
#import "NewsCell.h"
#import "NotaViewController.h"
#import "PublicacionWebViewController.h"
#import "VideoViewController.h"
#import "Bookmarks.h"
#import "MyTableViewController.h"

#define BUTTON_X_POS    10
#define BUTTON_Y_POS    15

#pragma mark - Private Interface

@interface MarcadoresDataManager()

-(void)refreshData;
-(void)editDoneSelected:(id)sender;

@end

#pragma mark - Implementation

@implementation MarcadoresDataManager

@synthesize bookmarks;
@synthesize notas;
@synthesize publicaciones;
@synthesize conferencias;
@synthesize editDoneButton;

#pragma mark - Creation

-(id)init {
    self = [super init];
    if (self) {
        self.bookmarks = [Bookmarks createFromFile];
    }
    return self;
}

#pragma mark - Memory Management

-(void)dealloc {
    [bookmarks release];
    [notas release];
    [publicaciones release];
    [conferencias release];
    [editDoneButton release];
    [super dealloc];
}

#pragma mark - Data Management

-(void)refreshData {
    [bookmarks prepareForQueries];
    self.notas = [bookmarks entriesInPage:PAGINA_NOTAS];
    self.publicaciones = [bookmarks entriesInPage:PAGINA_DOCUMENTOS];
    self.conferencias = [bookmarks entriesInPage:PAGINA_VIDEOS];
}

-(void)updateData {
    [self refreshData];
    [super updateData];
}

-(void)viewLoaded:(MyTableViewController*)controller {
    UIView* headerView = controller.headerView;
    self.editDoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* buttonImage = [UIImage imageNamed:@"editar.png"];
    [editDoneButton setImage:buttonImage forState:UIControlStateNormal];
    [editDoneButton addTarget:self
                       action:@selector(editDoneSelected:)
             forControlEvents:UIControlEventTouchUpInside];
    editDoneButton.frame = CGRectMake(BUTTON_X_POS, BUTTON_Y_POS, buttonImage.size.width, buttonImage.size.height);
    [headerView addSubview:editDoneButton];
}

#pragma mark - Actions

-(void)editDoneSelected:(id)sender {
    editing = !editing;
    if (editing) {
        [tableView setEditing:YES animated:YES];
        [editDoneButton setImage:[UIImage imageNamed:@"done.png"] forState:UIControlStateNormal];
        numDeletes = 0;
    } else {
        [tableView setEditing:NO animated:YES];
        [editDoneButton setImage:[UIImage imageNamed:@"editar.png"] forState:UIControlStateNormal];
        if (numDeletes > 0) {
            NSLog(@"Vamos a guardar");
            [bookmarks saveToFile];
        }
    }
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
            [cell defineTitle:NSLocalizedString(@"titulo_marcadores", @"Titulo de la pagina de marcadores")];
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

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section != 0;
}

-(void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle != UITableViewCellEditingStyleDelete) {
        return;
    }
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    Entry* entry = nil;
    switch (section) {
        case 0:
            break;
        case 1:
        {
            entry = [notas objectAtIndex:row];
            break;
        }
        case 2:
        {
            entry = [publicaciones objectAtIndex:row];
            break;
        }
        case 3:
        {
            entry = [conferencias objectAtIndex:row];
            break;
        }
        default:
            break;
    }
    if (entry == nil) {
        return;
    }
    [bookmarks removeEntry:entry];
    numDeletes++;
    [self updateData];
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
