//
//  PublicacionWebViewController.m
//  BCN
//
//  Created by Claudio Horvilleur on 8/15/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import "PublicacionWebViewController.h"
#import "Entry.h"
#import "CommonConstants.h"

@implementation PublicacionWebViewController

#pragma mark - Creation

+(id)createWithEntry:(Entry*)entry {
    return [[[PublicacionWebViewController alloc] initWithEntry:entry] autorelease];
}

-(id)initWithEntry:(Entry*)e {
    NSString* pagina = [e valueForKey:CONTENT];
    self = [super initWithNibName:@"PublicacionWebViewController" page:pagina];
    if (self) {
        self.entry = e;
    }
    return self;
}

#pragma mark - Memory Management

-(void)dealloc {
    [super dealloc];
}

@end
