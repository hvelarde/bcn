//
//  NotaWebViewController.h
//  BCN
//
//  Created by Claudio Horvilleur on 8/15/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebViewController.h"

@interface NotaWebViewController : WebViewController {
    
}

+(id)createWithPage:(NSString*)page;
-(id)initWithPage:(NSString*)page;

@end
