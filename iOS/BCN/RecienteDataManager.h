//
//  RecienteDataManager.h
//  BCN
//
//  Created by Claudio Horvilleur on 8/15/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelDataManager.h"

@interface RecienteDataManager : ModelDataManager {
    @private
    NSArray* notas;
    NSArray* publicaciones;
    NSArray* conferencias;
}

@property (nonatomic, retain) NSArray* notas;
@property (nonatomic, retain) NSArray* publicaciones;
@property (nonatomic, retain) NSArray* conferencias;

@end
