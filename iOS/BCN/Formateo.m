//
//  Formateo.m
//  ABILIA
//
//  Created by Claudio Horvilleur on 11/10/10.
//  Copyright 2010 Cromasoft. All rights reserved.
//

#import "Formateo.h"

#pragma mark -
#pragma mark Strings de contenido

#define FIN_PARRAFO			@"\u2029"
#define	FIN_LINEA			@"\u2028"


CTFontRef CreateFont(NSString* iPostScriptName, CGFloat iSize)
{
	assert(iPostScriptName != NULL);
	return CTFontCreateWithName((CFStringRef)iPostScriptName, iSize, NULL);
}

#pragma mark - Private interface

@interface Formateo()

-(CTFontRef)getFontNormal;
-(CTFontRef)getFontBold;

-(CFDictionaryRef)buildAttrsConFont:(CTFontRef)font style:(CTParagraphStyleRef)style;
-(CFDictionaryRef)buildNormalAttrsConFont:(CTFontRef)font;
-(CFDictionaryRef)getNormalAttrs;
-(CFDictionaryRef)getNormalBoldAttrs;

@end

#pragma mark - Implementation

@implementation Formateo

#pragma mark -
#pragma mark Creacion

+(id)createWithFontSize:(float)fontSize {
    return [[[Formateo alloc] initWithFontSize:fontSize] autorelease];
}

-(id)initWithFontSize:(float)fs {
	if ((self = [super init])) {
        fontSize = fs;
	}
	return self;
}

#pragma mark -
#pragma mark Definiciones de Fonts

-(CTFontRef)getFontNormal {
	if (fontNormal == NULL) {
		fontNormal = CreateFont(@"HelveticaNeue", fontSize);
	}
	return fontNormal;
}
		
-(CTFontRef)getFontBold {
	if (fontBold == NULL) {
		fontBold = CreateFont(@"HelveticaNeue-Bold", fontSize);
	}
	return fontBold;
}

#pragma mark -
#pragma mark Definiciones de atributos

static CTTextAlignment alignment = kCTNaturalTextAlignment;
static CGFloat paragraphSpacing = 10.0f;

// Aramado de atributos generales
-(CFDictionaryRef)buildAttrsConFont:(CTFontRef)font style:(CTParagraphStyleRef)style {
	CFTypeRef values[] = { font, style };
	CFStringRef keys[] = { kCTFontAttributeName, kCTParagraphStyleAttributeName };
	CFDictionaryRef attrs = CFDictionaryCreate(kCFAllocatorDefault,
											   (const void**)&keys,
											   (const void**)&values,
											   2,
											   &kCFTypeDictionaryKeyCallBacks,
											   &kCFTypeDictionaryValueCallBacks);
	return attrs;
}

// Armado de atributos normales con espacio despues del parrafo
-(CFDictionaryRef)buildNormalAttrsConFont:(CTFontRef)font {
	CTParagraphStyleSetting settings[] = {
		{kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment},
		{kCTParagraphStyleSpecifierParagraphSpacing, sizeof(paragraphSpacing), &paragraphSpacing}
	};
	CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, 2);
	CFDictionaryRef attrs = [self buildAttrsConFont:font style:paragraphStyle];
	CFRelease(paragraphStyle);
	return attrs;
}

-(CFDictionaryRef)getNormalAttrs {
	if (normalAttrs == NULL) {
		normalAttrs = [self buildNormalAttrsConFont:[self getFontNormal]];
	}
	return normalAttrs;
}

-(CFDictionaryRef)getNormalBoldAttrs {
	if (normalBoldAttrs == NULL) {
		normalBoldAttrs = [self buildNormalAttrsConFont:[self getFontBold]];
	}
	return normalBoldAttrs;
}

#pragma mark -
#pragma mark Manejo del Buffer

-(NSMutableAttributedString*)preparaBuffer {
	NSMutableAttributedString* res = [[[NSMutableAttributedString alloc] initWithString:@""] autorelease];
	[res beginEditing];
	return res;
}

-(void)finalizaBuffer:(NSMutableAttributedString*)buffer {
	[buffer endEditing];
}

#pragma mark -
#pragma mark Armado de los elementos

-(void)ponFinLinea:(NSMutableAttributedString*)buffer {
	[self agregaElemento:FIN_LINEA buffer:buffer efecto:TEXTO_EFECTO_NORMAL];
}

-(void)ponCambioParrafo:(NSMutableAttributedString*)buffer {
	[self agregaElemento:FIN_PARRAFO buffer:buffer efecto:TEXTO_EFECTO_NORMAL];
}

-(void)agregaElemento:(NSString*)contenido
               buffer:(NSMutableAttributedString*)buffer
               efecto:(NSInteger)efecto {
	if ((contenido == nil) || ([contenido length] == 0)) {
		return;
	}
    CFDictionaryRef attrs = (efecto == TEXTO_EFECTO_BOLD) ? [self getNormalBoldAttrs] : [self getNormalAttrs];
	CFAttributedStringRef parrafo = CFAttributedStringCreate(kCFAllocatorDefault,
                                                             (CFStringRef)contenido,
                                                             attrs);
	[buffer appendAttributedString:(NSAttributedString*)parrafo];
	CFRelease(parrafo);
}

-(void)agregaParrafo:(NSString *)contenido buffer:(NSMutableAttributedString *)buffer {
	[self agregaElemento:contenido buffer:buffer efecto:TEXTO_EFECTO_NORMAL];
	[self ponCambioParrafo:buffer];
}

-(void)agregaLinea:(NSString*)contenido buffer:(NSMutableAttributedString*)buffer {
	[self agregaElemento:contenido buffer:buffer efecto:TEXTO_EFECTO_NORMAL];
	[self ponFinLinea:buffer];
}

-(void)agregaParrafoBold:(NSString *)contenido buffer:(NSMutableAttributedString *)buffer {
	[self agregaElemento:contenido buffer:buffer efecto:TEXTO_EFECTO_BOLD];
	[self ponCambioParrafo:buffer];
}

-(void)agregaLineaBold:(NSString*)contenido buffer:(NSMutableAttributedString*)buffer {
	[self agregaElemento:contenido buffer:buffer efecto:TEXTO_EFECTO_BOLD];
	[self ponFinLinea:buffer];
}

#pragma mark -
#pragma mark Conversion a imagenes por columna

-(UIImage*)armaContenidoFlotante:(NSMutableAttributedString*)contenido
                           ancho:(NSInteger)width
                      altoMaximo:(NSInteger)maxHeight {
	CFAttributedStringRef attrStr = (CFAttributedStringRef)contenido;
	CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrStr);
	CGSize constraint = CGSizeMake(width, maxHeight);
	CFRange fitRange;
	CFRange stringRange = CFRangeMake(0, 0);
	CGSize realSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, stringRange, NULL, constraint, &fitRange);
	int realHeight = ((int)realSize.height) + 1;
	CGRect area = CGRectMake(0, 0, width, realHeight);
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathAddRect(path, NULL, area);
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();	
	CGContextRef context = CGBitmapContextCreate(NULL, width, realHeight, 8, 4 * width,
												 colorSpace, kCGImageAlphaPremultipliedFirst);
	CTFrameRef frm = CTFramesetterCreateFrame(framesetter, stringRange, path, NULL);
	CTFrameDraw(frm, context);
	CFRelease(frm);
	CGImageRef cgImage = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
	UIImage* image = [UIImage imageWithCGImage:cgImage];
	CFRelease(cgImage);
	CGPathRelease(path);
	// Limpieza general
	CFRelease(framesetter);	
	return image;
}

-(UIImage*)armaContenido:(NSMutableAttributedString*)contenido
                   ancho:(NSInteger)width
                    alto:(NSInteger)height {
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CFAttributedStringRef attrStr = (CFAttributedStringRef)contenido;
	CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrStr);
	CGMutablePathRef path = CGPathCreateMutable();
	CGRect area = CGRectMake(0, 0, width, height);
	CGPathAddRect(path, NULL, area);
	CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedFirst);
	CTFrameRef frm = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
	CTFrameDraw(frm, context);
	CFRelease(frm);
	CGImageRef cgImage = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	UIImage* image = [UIImage imageWithCGImage:cgImage];
	CFRelease(cgImage);
	CGPathRelease(path);
	// Limpieza general
	CFRelease(framesetter);
	CGColorSpaceRelease(colorSpace);
	
	return image;
}

-(NSArray*)armaContenido:(NSMutableAttributedString*)contenido
				  ancho1:(NSInteger)width1
				  ancho2:(NSInteger)width2
					alto:(NSInteger)height {
	// Para el resultado
	NSMutableArray* resp = [NSMutableArray arrayWithCapacity:3];
	
	// Ambiente general para el armado
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CFAttributedStringRef attrStr = (CFAttributedStringRef)contenido;
	CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrStr);
	CFIndex startIndex = 0;
	CFIndex endIndex = [contenido length];
	
	// Primera columna
	CGMutablePathRef path1 = CGPathCreateMutable();
	CGRect area = CGRectMake(0, 0, width1, height);
	CGPathAddRect(path1, NULL, area);
	CGContextRef context = CGBitmapContextCreate(NULL, width1, height, 8, 4 * width1, colorSpace, kCGImageAlphaPremultipliedFirst);
	CTFrameRef frm = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path1, NULL);
	CTFrameDraw(frm, context);
	CFRange frameRange = CTFrameGetVisibleStringRange(frm);
	startIndex += frameRange.length;
	CFRelease(frm);
	CGImageRef cgImage = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	[resp addObject:[UIImage imageWithCGImage:cgImage]];
	CFRelease(cgImage);
	CGPathRelease(path1);
	
	// Siguientes columnas
	if ((startIndex < endIndex) && (width2 > 0)) {
		CGMutablePathRef path2 = CGPathCreateMutable();
        area = CGRectMake(0, 0, width2, height);
		CGPathAddRect(path2, NULL, area);
		while (startIndex < endIndex) {
			// Cada una de las columnas
            context = CGBitmapContextCreate(NULL, width2, height, 8, 4 * width2,
														 colorSpace, kCGImageAlphaPremultipliedFirst);
            frm = CTFramesetterCreateFrame(framesetter, CFRangeMake(startIndex, 0), path2, NULL);
			CTFrameDraw(frm, context);
            frameRange = CTFrameGetVisibleStringRange(frm);
			startIndex += frameRange.length;
			CFRelease(frm);
            cgImage = CGBitmapContextCreateImage(context);
			CGContextRelease(context);
			[resp addObject:[UIImage imageWithCGImage:cgImage]];
			CFRelease(cgImage);
		}
		CGPathRelease(path2);
	}
	
	// Limpieza general
	CFRelease(framesetter);
	CGColorSpaceRelease(colorSpace);
	
	return resp;
}

-(NSArray*)armaContenido:(NSMutableAttributedString*)contenido
				   ancho:(NSInteger)width
				   alto1:(NSInteger)height1
				   alto2:(NSInteger)height2
				numCols1:(NSInteger)numCols1 {
	// Para el resultado
	NSMutableArray* resp = [NSMutableArray arrayWithCapacity:3];
	
	// Ambiente general para el armado
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CFAttributedStringRef attrStr = (CFAttributedStringRef)contenido;
	CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrStr);
	CFIndex startIndex = 0;
	CFIndex endIndex = [contenido length];
	NSInteger numCol = 0;
	
	// Definiciones para las columnas
	CGMutablePathRef path1 = CGPathCreateMutable();
	CGRect area1 = CGRectMake(0, 0, width, height1);
	CGPathAddRect(path1, NULL, area1);
	CGMutablePathRef path2 = CGPathCreateMutable();
	CGRect area2 = CGRectMake(0, 0, width, height2);
	CGPathAddRect(path2, NULL, area2);
	
	// Armado de las columnas
	while (startIndex < endIndex) {
		CGContextRef context = CGBitmapContextCreate(NULL, width, (numCol < numCols1) ? height1 : height2, 8, 4 * width,
													 colorSpace, kCGImageAlphaPremultipliedFirst);
		CTFrameRef frm =
		CTFramesetterCreateFrame(framesetter, CFRangeMake(startIndex, 0), (numCol < numCols1) ? path1: path2, NULL);
		CTFrameDraw(frm, context);
		CFRange frameRange = CTFrameGetVisibleStringRange(frm);
		startIndex += frameRange.length;
		CFRelease(frm);
		CGImageRef cgImage = CGBitmapContextCreateImage(context);
		CGContextRelease(context);
		[resp addObject:[UIImage imageWithCGImage:cgImage]];
		CFRelease(cgImage);
		numCol++;
	}
	
	// Limpieza general
	CGPathRelease(path1);
	CGPathRelease(path2);
	CFRelease(framesetter);
	CGColorSpaceRelease(colorSpace);
	
	return resp;
}



#pragma mark - Memory Management

- (void)dealloc {
	NSLog(@"dealloc de: %@", NSStringFromClass([self class]));
	if (normalAttrs != NULL) {
		CFRelease(normalAttrs);
	}
	if (normalBoldAttrs != NULL) {
		CFRelease(normalBoldAttrs);
	}
	if (fontBold != NULL) {
		CFRelease(fontBold);
	}
	if (fontNormal != NULL) {
		CFRelease(fontNormal);
	}
    [super dealloc];
}

@end
