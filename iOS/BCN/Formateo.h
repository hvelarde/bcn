//
//  Formateo.h
//  CROMASOFT
//
//  Created by Claudio Horvilleur on 11/10/10.
//  Copyright 2010 Cromasoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

#define	TEXTO_EFECTO_NORMAL			0x0
#define	TEXTO_EFECTO_BOLD			0x1

@class TextView;

@interface Formateo : NSObject {
    float fontSize;
	@private
	CFDictionaryRef normalAttrs;
	CFDictionaryRef normalBoldAttrs;
	CTFontRef fontBold;
	CTFontRef fontNormal;
}

+(id)createWithFontSize:(float)fontSize;
-(id)initWithFontSize:(float)fontSize;

-(NSMutableAttributedString*)preparaBuffer;
-(void)finalizaBuffer:(NSMutableAttributedString*)buffer;

-(void)ponFinLinea:(NSMutableAttributedString*)buffer;
-(void)ponCambioParrafo:(NSMutableAttributedString*)buffer;
-(void)agregaElemento:(NSString*)contenido buffer:(NSMutableAttributedString*)buffer efecto:(NSInteger)efecto;
-(void)agregaParrafo:(NSString*)contenido buffer:(NSMutableAttributedString*)buffer;
-(void)agregaLinea:(NSString*)contenido buffer:(NSMutableAttributedString*)buffer;
-(void)agregaParrafoBold:(NSString*)titulo buffer:(NSMutableAttributedString*)buffer;
-(void)agregaLineaBold:(NSString*)contenido buffer:(NSMutableAttributedString*)buffer;

-(UIImage*)armaContenidoFlotante:(NSMutableAttributedString*)contenido
                           ancho:(NSInteger)width
                      altoMaximo:(NSInteger)maxHeight;
-(UIImage*)armaContenido:(NSMutableAttributedString*)contenido
                   ancho:(NSInteger)width
                    alto:(NSInteger)height;
-(NSArray*)armaContenido:(NSMutableAttributedString*)contenido
				  ancho1:(NSInteger)width1
				  ancho2:(NSInteger)width2
					alto:(NSInteger)height;
-(NSArray*)armaContenido:(NSMutableAttributedString*)contenido
				   ancho:(NSInteger)width
				   alto1:(NSInteger)height1
				   alto2:(NSInteger)height2
				numCols1:(NSInteger)numCols1;
@end
