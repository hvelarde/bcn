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
#import "IconDownloader.h"
#import "Entry.h"

#pragma mark - Private Interface

@interface PublicacionesDataManager()

-(void)decrementCountForDownloader:(IconDownloader*)downloader;

@end

#pragma mark - Implementation

@implementation PublicacionesDataManager

@synthesize pagina;
@synthesize tituloLista;
@synthesize publicaciones;
@synthesize imageDownloadsInProgress;

#pragma mark - Creation

-(id)init {
    self = [super init];
    if (self) {
        self.imageDownloadsInProgress = [NSMutableSet setWithCapacity:5];
    }
    return self;
}

#pragma mark - Memory Management

-(void)dealloc {
    [tituloLista release];
    [publicaciones release];
    [imageDownloadsInProgress release];
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
        return 1;
    }
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

#pragma mark - Icon/images Management

- (void)startIconDownload:(Entry *)entry {
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
    IconDownloader* iconDownloader = [[IconDownloader alloc] initWithEntry:entry];
    iconDownloader.delegate = self;
    [imageDownloadsInProgress addObject:iconDownloader];
    [iconDownloader startDownload];
    [iconDownloader release];   
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows {
    NSArray *visiblePaths = [tableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visiblePaths)
    {
        NSInteger row = indexPath.row;
        if (row == 0) {
            continue;
        }
        Entry *entry = [model entry:(row - 1) inPage:pagina];
        if ([entry needImageLoading])
        {
            [self startIconDownload:entry];
        }
    }
}

-(void)decrementCountForDownloader:(IconDownloader*)downloader {
    if ([imageDownloadsInProgress containsObject:downloader]) {
        [imageDownloadsInProgress removeObject:downloader];
        int count = [imageDownloadsInProgress count];
        if (count == 0) {
            UIApplication* app = [UIApplication sharedApplication];
            app.networkActivityIndicatorVisible = NO;
        }
    }
}

-(void)iconDidNotLoad:(IconDownloader *)downloader {
    [self decrementCountForDownloader:downloader];
}

-(void)iconDidLoad:(IconDownloader *)downloader {
    [self decrementCountForDownloader:downloader];
}

#pragma mark -  Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

-(void)viewAppeared {
    [self loadImagesForOnscreenRows];
}

@end
