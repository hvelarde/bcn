//
//  Video.m
//  CromaNews
//
//  Created by Claudio Horvilleur on 7/15/10.
//  Copyright 2010 Cromasoft. All rights reserved.
//

#import "Video.h"


@implementation Video

#pragma mark Creation and Initializations

+(Video*)createWithUrlString:(NSString*)urlString {
	Video* res = [[[Video alloc] initWithUrlString:urlString] autorelease];
	return res;
}


@end
