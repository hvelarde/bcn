//
//  PublicacionesDataManager.h
//  BCN
//
//  Created by Claudio Horvilleur on 8/15/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"

@interface PublicacionesDataManager : DataManager {
    NSInteger pagina;
    NSString* tituloLista;
    @private
    NSArray* publicaciones;
}

@property NSInteger pagina;
@property (nonatomic, retain) NSString* tituloLista;
@property (nonatomic, retain) NSArray* publicaciones;

@end
