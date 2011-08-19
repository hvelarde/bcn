//
//  ModelDataManager.h
//  BCN
//
//  Created by Claudio Horvilleur on 8/19/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"

@interface ModelDataManager : DataManager {
    Model* model;
    @private
    BOOL notificationsEnabled;
}

@property (nonatomic, retain) Model* model;

-(void)enableAutomaticUpdate;
-(void)disableAutomaticUpdate;

@end
