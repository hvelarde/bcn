/*
     File: IconDownloader.h 
 
	Adapted from the Apple´s "LazyTableImages" software available on the
	development kit, wich is copyrighted by Apple Inc.
*/

#import "ImageDownloader.h"
#import "IconDownloaderDelegate.h"

@class Entry;

@interface IconDownloader : ImageDownloader {
    id<IconDownloaderDelegate> delegate;
	@private
    Entry *entry;
}

@property (nonatomic, retain) Entry *entry;
@property (nonatomic, retain) id<IconDownloaderDelegate>delegate;

-(id)initWithEntry:(Entry*)entry;

@end