//
//  FeedReader.m
//  CromaFeeds
//
//  Created by Claudio Horvilleur on 5/13/10.
//  Copyright 2010 Cromasoft. All rights reserved.
//

#import "FeedReader.h"
#import "Model.h"
#import "Entry.h"
#import "Feed.h"
#import "CommonConstants.h"

#pragma mark - Private Methods Declaration
@interface FeedReader ()

-(void)triggerARefreshFromTimer:(NSTimer*)timer;
-(void)updateModel;
-(void)showError:(NSError *)parseError;
-(void)foregroundShowError:(NSError *)parseError;
-(void)loadData;
-(NSDate*)dateFromZulu:(NSString*)str;
-(void)stopIndicator;
-(void)sendNotification;

@end

#pragma mark - Start implementation

@implementation FeedReader

@synthesize model;
@synthesize updateDate;
@synthesize tmpValue;
@synthesize entries;
@synthesize entry;
@synthesize rfc3339DateFormater;
@synthesize sorters;
@synthesize triggerTimer;
@synthesize feedAttributes;

#pragma mark Initializations

+(id)createWithModel:(Model*)model {
    return [[[FeedReader alloc] initWithModel:model] autorelease];
}

-(id)initWithModel:(Model*)mdl {
    self = [super init];
    if (self) {
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss Z"];
        self.model = mdl;
        self.rfc3339DateFormater = df;
        NSMutableArray* st = [NSMutableArray arrayWithCapacity:2];
        NSSortDescriptor* sd;
        sd = [[NSSortDescriptor alloc] initWithKey:CATEGORY
                                         ascending:YES];
        [st addObject:sd];
        [sd release];
        sd = [[NSSortDescriptor alloc] initWithKey:ENTRY_DATE_TIME
                                         ascending:NO];
        [st addObject:sd];
        [sd release];
        self.sorters = sorters;
    }
	return self;
}

#pragma mark -
#pragma mark Operation control

-(void)startOperation {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger minutes = [defaults integerForKey:@"actualizacion_periodicidad_preference"];
    NSLog(@"Automatic feed refresh every %d minutes", minutes);
    if (minutes == 0) {
        minutes = 5;
    }
    self.triggerTimer = [NSTimer scheduledTimerWithTimeInterval:minutes * 60.0
                                                         target:self
                                                       selector:@selector(triggerARefreshFromTimer:)
                                                       userInfo:nil
                                                        repeats:YES];
    started = YES;
}

-(void)stopOperation {
    started = NO;
	[triggerTimer invalidate];
	self.triggerTimer = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)triggerARefreshFromTimer:(NSTimer*)timer {
    [self refreshInfo];
}

-(void)refreshInfo {
    if (working || !started) {
        return;
    }
	working = YES;
	NSLog(@"Starting the update");
	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = YES;
    [self performSelectorInBackground:@selector(updateModel) withObject:nil];
    
}

-(void)stopIndicator {
	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = NO;    
}

#pragma mark -
#pragma mark Error display

-(void)showError:(NSError *)parseError {
    [self performSelectorOnMainThread:@selector(foregroundShowError:)
                           withObject:parseError
                        waitUntilDone:NO];
}

-(void)foregroundShowError:(NSError *)parseError {
	NSString* errorMsg;
	if (parseError == nil) {
		errorMsg = NSLocalizedString(@"ERROR_SIN_RED", @"No hay red para obtener la información");
	} else {
		NSInteger errorCode = [parseError code];
		if (errorCode > 5) {
			errorMsg =  NSLocalizedString(@"ERROR_FORMATO_INVALIDO", @"Los datos recibidos tienen un formato inválido.");
		}else {
			errorMsg = NSLocalizedString(@"ERROR_SIN_INFORMACION", @"No se pudo obtener la información");
		}
	}
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ALERT_TITLE", @"Error durante la actualización")
													message:errorMsg
												   delegate:nil
										  cancelButtonTitle:NSLocalizedString(@"CONTINUE_BUTTON", @"Continuar")
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

#pragma mark -
#pragma mark Info processing

-(void)loadData {
	self.updateDate = nil;
	self.feedAttributes = [NSMutableDictionary dictionaryWithCapacity:5];
	NSString* feedURL = NSLocalizedString(@"FEED_URL", @"URL of the feed");
	// NSLog(feedURL);
	NSURL* url = [NSURL URLWithString:feedURL];
	NSXMLParser* parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	if (parser == nil) {
		//NSLog(@"Could not init the parser with the atom URL");
		[self showError:nil];
		return;
	}
	// Define the environment
	[parser setDelegate:self];
	inEntry = NO;
	self.entries = [NSMutableArray arrayWithCapacity:30];
	BOOL res = [parser parse];
	[parser release];
	if (!res) {
		self.updateDate = nil;
	}
}

-(void)updateModel {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[self loadData];
	if ((updateDate != nil) &&
        ((model.feed == nil) ||
         ([updateDate compare:model.feed.lastUpdate] == NSOrderedDescending))) {
            [entries sortUsingDescriptors:sorters];
            [model updateFromEntries:entries updated:updateDate  withAttributes:feedAttributes];
            [model saveToFile];
            [self performSelectorOnMainThread:@selector(sendNotification) withObject:nil waitUntilDone:YES];
	}
	self.entries = nil;
	model.lastCheck = [NSDate date];
	[pool drain];
    [self performSelectorOnMainThread:@selector(stopIndicator)
                           withObject:nil
                        waitUntilDone:NO];
	working = NO;
}

-(void)sendNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:MODEL_UPDATED_NOTIFICATION
                                                        object:self];
    NSLog(@"The model has been updated");
}

-(NSDate*)dateFromZulu:(NSString*)str {
	if (str == nil) {
		NSLog(@"Error getting date");
		return [NSDate date];
	}
	NSDate *ret = [rfc3339DateFormater dateFromString:[str stringByReplacingOccurrencesOfString:@"Z" withString:@" +0000"]];
	if (ret == nil) {
		ret = [NSDate date];
		NSLog(@"Error formatting date (%@)",str);       
	}   
	return ret;     
}
	
#pragma mark -
#pragma mark Parser delegate methods

-(void)         parser:(NSXMLParser *)parser
       didStartElement:(NSString *)elementName
          namespaceURI:(NSString *)namespaceURI
         qualifiedName:(NSString *)qualifiedName
            attributes:(NSDictionary *)attributeDict {
	//NSlog([NSString stringWithFormat:@"Start Element: %@", elementName]);
	if ([elementName isEqualToString:TAG_ENTRY]) {
		inEntry = YES;
		self.entry = [Entry entry];
		[entries addObject:entry];
	} else if ([elementName isEqualToString:TAG_CONTENT]){
		if (!inEntry) {
			[parser abortParsing];
			return;
		}
		/*
		NSString *src = [attributeDict objectForKey:TAG_SRC];
		[entry setValue:[src stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:CONTENT];
		NSString* type = [attributeDict objectForKey:TAG_TYPE];
		[entry setValue:type forKey:CONTENT_TYPE];
		 */
	} else if  ([elementName isEqualToString:TAG_CATEGORY]){
		if (inEntry) {
			NSString *term = [attributeDict objectForKey:TAG_TERM];
			//NSlog([NSString stringWithFormat:@"Category: %@", term]);
			[entry includeInPage:term];
		}
	} else if ([elementName isEqualToString:TAG_LINK]) {
		if (!inEntry) {
			self.tmpValue = nil;
			return;
		}
		NSString* rel =[attributeDict objectForKey:TAG_REL];
        NSString* type = [attributeDict objectForKey:TAG_TYPE];
        NSString* href = [attributeDict objectForKey:TAG_HREF];
		if ([rel isEqualToString:REL_ENCLOSURE]) {
			if ([type hasPrefix:TYPE_IMAGE]) {
                NSString* tmp = [href stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [entry setValue:tmp forKey:ENTRY_ICON];
                [entry defineImageFromLink:tmp];
			} else if ([type hasSuffix:TYPE_PDF]) {
                [entry setValue:[href stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:CONTENT];
                [entry setValue:WEB_PAGE forKey:CONTENT_TYPE];
            }
        } else if ([rel isEqualToString:REL_ALTERNATE]) {
            if ([type hasSuffix:TYPE_PDF]) {
                [entry setValue:[href stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:CONTENT];
                [entry setValue:WEB_PAGE forKey:CONTENT_TYPE];
            } else if ([type hasPrefix:TYPE_VIDEO]) {
                [entry setValue:[href stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:VIDEO];
            }
		} else {
			// Para BCN aqui es donde esta el link al contenido
			[entry setValue:[href stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:CONTENT];
			[entry setValue:WEB_PAGE forKey:CONTENT_TYPE];
		}
	} else if ([elementName isEqualToString:TAG_MEDIA_CONTENT]) {
		if (!inEntry) {
			[parser abortParsing];
			return;
		}
		NSString* medium = [attributeDict objectForKey:TAG_MEDIUM];
		NSString* urlString = [attributeDict objectForKey:TAG_URL];
		if ([medium isEqualToString:MEDIUM_VIDEO]) {
            [entry setValue:[urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:VIDEO];
			inGalleryItem = YES;
		}
	}
	self.tmpValue = nil;
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	//NSlog([NSString stringWithFormat:@"End Element: %@, value: %@", elementName, self.tmpValue]);
	if ([elementName isEqualToString:TAG_ENTRY]) {
		inEntry = NO;
		self.entry = nil;
	} else if ([elementName isEqualToString:TAG_MEDIA_CONTENT]) {
		inGalleryItem = NO;
	} else if ([elementName isEqualToString:TAG_UPDATED]) {
		NSDate* date = [self dateFromZulu:tmpValue];
//		NSDateFormatter* df = [[NSDateFormatter alloc] init];
//		[df setDateFormat:@"yyyy MMM dd  HH:mm:ss z"];
//		NSLog([NSString stringWithFormat:@"%@ -> %@", [df stringFromDate:date], tmpValue]);
//		[df release];
		if (inEntry) {
			[entry setValue:date forKey:ENTRY_DATE_TIME];
		} else {
			self.updateDate = date;
		}
	} else if ([elementName isEqualToString:TAG_TITLE]) {
		if (inEntry) {
			[entry setValue:tmpValue forKey:ENTRY_TITLE];
		} else {
			[feedAttributes setValue:tmpValue forKey:TAG_TITLE];
		}
	} else if ([elementName isEqualToString:TAG_CONTENT]) {
		if (inEntry) {
			[entry setValue:tmpValue forKey:ENTRY_SUMMARY];
		}
	} else if ([elementName isEqualToString:TAG_SUMMARY]) {
		if (inEntry) {
			[entry setValue:tmpValue forKey:ENTRY_CONTENT_INFO];
		}
	} else if ([elementName isEqualToString:TAG_MEDIA_TITLE]) {
		if (!inGalleryItem) {
			//[parser abortParsing]; // We accept the element but we do nothing with it
		} else {
			// galleryItem.title = tmpValue;
		}
	}
	self.tmpValue = nil;
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	//NSlog(@"some characters");
	if (!tmpValue) {
		self.tmpValue = [[NSMutableString alloc] initWithCapacity:50];
	}
	[self.tmpValue appendString:string];
}

-(void)parserDidStartDocument:(NSXMLParser *)parser {
	//NSlog(@"Arranca parseo");
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
	//NSlog(@"Termina parseo");
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSLog(@"parseErrorOccurred: %d - %@", [parseError code], [parseError localizedDescription]);
	[self showError:parseError];
}

-(void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validError {
	NSLog(@"validationErrorOccurred: %d - %@", [validError code], [validError localizedDescription]);
	[self showError:validError];
}

-(void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock {
	//NSlog(@"Se encontro CDATA");
	[parser abortParsing];
}

#pragma mark -
#pragma mark Generic methods

-(void)dealloc {
	[feedAttributes release];
	[triggerTimer release];
	[sorters release];
	[rfc3339DateFormater release];
	[entry release];
	[entries release];
	[tmpValue release];
	[model release];
	[super dealloc];
}

@end
