//
//  HomeViewController.h
//  BCN
//
//  Created by Claudio Horvilleur on 8/5/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Model;

@interface HomeViewController : UIViewController {
    @private
    Model* model;
}

@property (nonatomic, retain) Model* model;

+(id)createWithModel:(Model*)model;
-(id)initWithModel:(Model*)model;

-(IBAction)indicadoresSelected:(id)sender;
-(IBAction)publicacionesSelected:(id)sender;
-(IBAction)notasSelected:(id)sender;
-(IBAction)conferenciasSelected:(id)sender;
-(IBAction)recienteSelected:(id)sender;
-(IBAction)marcadoresSelected:(id)sender;

@end
