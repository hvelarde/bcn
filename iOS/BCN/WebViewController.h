//
//  WebViewController.h
//  BCN
//
//  Created by Claudio Horvilleur on 8/9/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface WebViewController : BaseViewController <UIWebViewDelegate> {
    UIWebView* webView;
    UIActivityIndicatorView* activityIndicator;
    @private
    NSString* pagina;
}

@property (nonatomic, retain) IBOutlet UIWebView* webView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* activityIndicator;
@property (nonatomic, retain) NSString* pagina;

-(id)initWithNibName:(NSString*)nibName page:(NSString*)page;


@end
