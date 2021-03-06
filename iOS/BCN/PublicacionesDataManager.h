//
//  PublicacionesDataManager.h
//  BCN
//
//  Created by Claudio Horvilleur on 8/15/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelDataManager.h"
#import "IconDownloaderDelegate.h"

@interface PublicacionesDataManager : ModelDataManager <IconDownloaderDelegate> {
    NSInteger pagina;
    NSString* tituloLista;
    @private
    NSArray* publicaciones;
    NSMutableSet *imageDownloadsInProgress;
}

@property NSInteger pagina;
@property (nonatomic, retain) NSString* tituloLista;
@property (nonatomic, retain) NSArray* publicaciones;
@property (nonatomic, retain) NSMutableSet *imageDownloadsInProgress;

@end
