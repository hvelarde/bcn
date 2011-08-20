//
//  IconDownloaderDelegate.h
//  BCN
//
//  Created by Claudio Horvilleur on 8/19/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IconDownloader;

@protocol IconDownloaderDelegate <NSObject>

- (void)iconDidLoad:(IconDownloader*)downloader;
- (void)iconDidNotLoad:(IconDownloader*)downloader;

@end
