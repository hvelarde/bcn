//
//  NotasDataManager.h
//  BCN
//
//  Created by Claudio Horvilleur on 8/8/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelDataManager.h"

@interface NotasDataManager : ModelDataManager {
    @private
    NSArray* notas;
}

@property (nonatomic, retain) NSArray* notas;

@end
