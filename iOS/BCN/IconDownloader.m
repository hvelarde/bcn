/*
 File: IconDownloader.h 
 Adapted from the Apple´s "LazyTableImages" software available on the
 development kit, wich is copyrighted by Apple Inc.
 */

#import "IconDownloader.h"
#import "Entry.h"
#import "CommonConstants.h"

@implementation IconDownloader

@synthesize entry;
@synthesize delegate;

#pragma mark Initialization
-(id)initWithEntry:(Entry*)e {
    self = [super initWithURLString:e.imageURLString
					  requiredWidth:kAppIconWidth
					 requiredHeight:kAppIconHeight];
    if (self) {
        self.entry = e;
        entry.imageIsLoading = YES;
    }
	return self;
}

#pragma mark -
#pragma mark General

- (void)dealloc {
    [entry release];
    [delegate release];
    [super dealloc];
}

#pragma mark -
#pragma mark ImageDownloader methods overloading

-(void)imageDidLoad:(UIImage*)image {
	[entry storeLoadedImage:image];
    [delegate iconDidLoad:self];
}

-(void)imageDidNotLoad {
	entry.imageIsLoading = NO;
    [delegate iconDidNotLoad:self];
}

@end

