//
//  ConferenciasDataManager.h
//  BCN
//
//  Created by Claudio Horvilleur on 8/15/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"

@interface ConferenciasDataManager : DataManager {
    @private
    NSArray* conferencias;
}

@property (nonatomic, retain) NSArray* conferencias;

@end
