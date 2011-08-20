//
//  ConferenciasDataManager.m
//  BCN
//
//  Created by Claudio Horvilleur on 8/15/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import "ConferenciasDataManager.h"
#import "CommonConstants.h"
#import "Model.h"
#import "TitleCell.h"
#import "NewsCell.h"
#import "VideoViewController.h"

@implementation ConferenciasDataManager

@synthesize conferencias;

#pragma mark - Memory Management

-(void)dealloc {
    [conferencias release];
    [super dealloc];
}

#pragma mark - Data Management

-(void)updateData {
    self.conferencias = [model entriesInPage:PAGINA_VIDEOS];
    [super updateData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (conferencias == nil) {
        return 1;
    }
    return 1 + [conferencias count];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row == 0) {
        TitleCell* cell = (TitleCell*)[tv dequeueReusableCellWithIdentifier:TITLE_CELL_IDENTIFIER];
        if (cell == nil) {
            cell = [TitleCell create];
        }
        [cell defineTitle:NSLocalizedString(@"titulo_videos", @"Titulo de la pagina de videos")];
        return cell;
    }
    Entry* entry = [model entry:(row - 1) inPage:PAGINA_VIDEOS];
    NewsCell* cell = (NewsCell*) [tv dequeueReusableCellWithIdentifier:VIDEO_CELL_IDENTIFIER];
    if (cell == nil) {
        cell = [NewsCell createWithCellType:VIDEO_CELL_TYPE reuseIdentifier:VIDEO_CELL_IDENTIFIER];
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
    return VIDEO_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row == 0) {
        [tv deselectRowAtIndexPath:indexPath animated:NO];
        return;
    }
    Entry* entry = [model entry:(row - 1) inPage:PAGINA_VIDEOS];
    VideoViewController* vvc = [VideoViewController createWithEntry:entry];
    [navigationController pushViewController:vvc animated:YES];
    [tv deselectRowAtIndexPath:indexPath animated:NO];
}


@end
