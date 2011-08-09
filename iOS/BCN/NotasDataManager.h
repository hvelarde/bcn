//
//  NotasDataManager.h
//  BCN
//
//  Created by Claudio Horvilleur on 8/8/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"

@interface NotasDataManager : DataManager {
    @private
    NSArray* notas;
}

@property (nonatomic, retain) NSArray* notas;

@end
