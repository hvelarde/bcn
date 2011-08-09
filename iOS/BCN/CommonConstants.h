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
#define	TYPE_IMAGE			@"image/"
#define	TYPE_VIDEO			@"video/"
#define	TAG_LENGTH			@"length"
#define	TAG_HREF			@"href"

#define TAG_MEDIA_CONTENT		@"media:content"
#define	TAG_MEDIA_TITLE			@"media:title"

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

#pragma mark - Content types
#define WEB_PAGE            @"webPage"

#pragma mark - Notifications
#define	MODEL_UPDATED_NOTIFICATION	@"modelUpdatedNotification"

#pragma mark - Pages numbers
#define PAGINA_NOTAS        0
#define PAGINA_DOCUMENTOS   1
#define PAGINA_VIDEOS       2

#pragma mark - Cells identifiers
#define TITLE_CELL_IDENTIFIER       @"TitleCell"
#define NOTE_CELL_IDENTIFIER        @"NoteCell"
#define DOCUMENT_CELL_IDENTIFIER    @"DocumentCell"
#define VIDEO_CELLL_IDENTIFIER      @"VideoCell"
