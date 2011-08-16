//
//  NotaWebViewController.m
//  BCN
//
//  Created by Claudio Horvilleur on 8/15/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import "NotaWebViewController.h"


@implementation NotaWebViewController

#pragma mark - Creation

+(id)createWithPage:(NSString*)page {
    return [[[NotaWebViewController alloc] initWithPage:page] autorelease];
}

-(id)initWithPage:(NSString*)page {
    return [super initWithNibName:@"NotaWebViewController" page:page];
}

@end
