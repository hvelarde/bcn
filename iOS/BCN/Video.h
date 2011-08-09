//
//  Video.h
//  CromaNews
//
//  Created by Claudio Horvilleur on 7/15/10.
//  Copyright 2010 Cromasoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GalleryItem.h"

@interface Video : GalleryItem {

}

+(Video*)createWithUrlString:(NSString*)urlString;

@end
