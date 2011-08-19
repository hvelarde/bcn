//
//  PublicacionWebViewController.h
//  BCN
//
//  Created by Claudio Horvilleur on 8/15/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebViewController.h"

@class Entry;

@interface PublicacionWebViewController : WebViewController {
}

+(id)createWithEntry:(Entry*)entry;
-(id)initWithEntry:(Entry*)entry;

@end
