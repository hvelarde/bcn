/*
 *  CommonConstants.h
 *  CromaFeeds
 *
 *  Created by Claudio Horvilleur on 5/24/10.
 *  Copyright 2010 Cromasoft. All rights reserved.
 *
 */

#pragma mark - Categories plist fields
#define CAT_KEY			@"key"
#define CAT_LABEL		@"label"
#define	CAT_ICON		@"icon"

#pragma mark - XML tags
#define	TAG_ENTRY			@"entry"
#define TAG_UPDATED			@"updated"
#define TAG_TITLE			@"title"
#define TAG_CONTENT			@"content"
#define TAG_CATEGORY		@"category"
#define TAG_TERM			@"term"
#define	TAG_TYPE			@"type"
#define	TAG_LINK			@"link"
#define	TAG_REL				@"rel"
#define	REL_ENCLOSURE		@"enclosure"
#define REL_ALTERNATE       @"alternate"
#define	TYPE_IMAGE			@"image/"
#define	TYPE_VIDEO			@"video/"
#define TYPE_PDF            @"/pdf"
#define	TAG_LENGTH			@"length"
#define	TAG_HREF			@"href"
#define TAG_SUMMARY         @"summary"
#define TAG_ID              @"id"

#define TAG_MEDIA_CONTENT	@"media:content"
#define	TAG_MEDIA_TITLE		@"media:title"

#define	TAG_URL				@"url"
#define	TAG_MEDIUM			@"medium"
#define MEDIUM_IMAGE		@"image"
#define MEDIUM_VIDEO		@"video"


#pragma mark - Dictionaries keys
#define CONTENT				TAG_CONTENT
#define CATEGORY			TAG_CATEGORY
#define ENTRY_SUMMARY       @"summary"
#define	ENTRY_TITLE			TAG_TITLE
#define	ENTRY_DATE_TIME		TAG_UPDATED
#define ENTRY_ICON          @"icon"
#define	CONTENT_TYPE		TAG_TYPE
#define IMAGE_LENGTH		@"imageLength"
#define ENTRY_CONTENT_INFO  @"contentInfo"
#define VIDEO               @"video"


#pragma mark - Content types
#define WEB_PAGE            @"webPage"

#pragma mark - Notifications
#define	MODEL_UPDATED_NOTIFICATION	@"modelUpdatedNotification"

#pragma mark - Cells identifiers
#define TITLE_CELL_IDENTIFIER       @"TitleCell"
#define NOTE_CELL_IDENTIFIER        @"NoteCell"
#define DOCUMENT_CELL_IDENTIFIER    @"DocumentCell"
#define VIDEO_CELL_IDENTIFIER      @"VideoCell"
#define SIMPLE_CELL_IDENTIFIER      @"SimpleCell"

#pragma mark - Cells size
#define SIMPLE_CELL_HEIGHT          44
#define TITLE_CELL_HEIGHT           SIMPLE_CELL_HEIGHT
#define NOTE_CELL_HEIGHT            SIMPLE_CELL_HEIGHT
#define DOCUMENT_CELL_HEIGHT        75
#define VIDEO_CELL_HEIGHT           75

#pragma mark - Special cells type
#define DOCUMENT_CELL_TYPE      0
#define VIDEO_CELL_TYPE         1

#pragma mark - Pages numbers
#define PAGINA_NOTAS                    0
#define PAGINA_DOCUMENTOS               1
#define PAGINA_VIDEOS                   2
#define PAGINA_informemonetario         3
#define PAGINA_inflacion                4
#define PAGINA_imae                     5
#define PAGINA_pconstruccion            6
#define PAGINA_fiscal                   7
#define PAGINA_sectorexterno            8
#define PAGINA_boletineconomico         9
#define PAGINA_boletinfinanciero        10
#define PAGINA_finanzasublicas          11
#define PAGINA_construccionprivada      12
#define PAGINA_deudapublica             13
#define PAGINA_deudaexterna             14
#define PAGINA_cuentasnacionales        15
#define PAGINA_balanzapagos             16
#define PAGINA_informeanual             17
#define PAGINA_deudaanual               18
#define PAGINA_metodologias             19
#define PAGINA_investigaciones          20
#define PAGINA_informesespeciales       21
#define PAGINA_acuerdosinternacionales  22
