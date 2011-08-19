//
//  ConferenciasDataManager.h
//  BCN
//
//  Created by Claudio Horvilleur on 8/15/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelDataManager.h"

@interface ConferenciasDataManager : ModelDataManager {
    @private
    NSArray* conferencias;
}

@property (nonatomic, retain) NSArray* conferencias;

@end
