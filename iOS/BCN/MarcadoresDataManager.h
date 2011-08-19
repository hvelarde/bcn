//
//  MarcadoresDataManager.h
//  BCN
//
//  Created by Claudio Horvilleur on 8/19/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"

@class Bookmarks;


@interface MarcadoresDataManager : DataManager {
    @private
    Bookmarks* bookmarks;
    NSArray* notas;
    NSArray* publicaciones;
    NSArray* conferencias;
    UIButton* editDoneButton;
    BOOL editing;
    NSInteger numDeletes;
}

@property (nonatomic, retain) Bookmarks* bookmarks;
@property (nonatomic, retain) NSArray* notas;
@property (nonatomic, retain) NSArray* publicaciones;
@property (nonatomic, retain) NSArray* conferencias;
@property (nonatomic, retain) UIButton* editDoneButton;

@end
