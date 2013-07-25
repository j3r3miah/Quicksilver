//
// QSHistoryController.m
// Quicksilver
//
// Created by Alcor on 5/17/05.
// Copyright 2005 Blacktree, Inc. All rights reserved.
//

#import "QSHistoryController.h"
#import "QSCommand.h"

#define MAXHIST 50

id QSHist;

@implementation QSHistoryController

+ (id)sharedInstance {
	if (!QSHist) QSHist = [[[self class] allocWithZone:nil] init];
	return QSHist;
}

- (id)init {
	self = [super init];
	if (self != nil) {
		objectHistory = [[NSMutableArray alloc] init];
		commandHistory = [[NSMutableArray alloc] init];
		actionHistory = [[NSMutableArray alloc] init];
	}
	return self;
}

- (NSArray *)recentObjects {return objectHistory;}
- (NSArray *)recentCommands {return commandHistory;}
- (NSArray *)recentActions {return actionHistory;}

- (void)addAction:(id)action {
	[actionHistory addObject:action];
	[actionHistory removeObject:action];
	[actionHistory insertObject:action atIndex:0];
	while ([actionHistory count] > MAXHIST)
		[actionHistory removeLastObject];
}
- (void)addCommand:(QSCommand *)command {
	if ([[[command dObject] identifier] isEqualToString:@"QSLastCommandProxy"]) {
        // If we're re-running the last command, don't change anything
        return;
	}
	if (command)
		[commandHistory insertObject:command atIndex:0];
	while ([commandHistory count] > MAXHIST)
		[commandHistory removeLastObject];
	[[NSNotificationCenter defaultCenter] postNotificationName:QSCatalogEntryInvalidated object:@"QSPresetCommandHistory"];
}

- (void)addObject:(id)object {
    if ([object isKindOfClass:[QSRankedObject class]] ) {
        object = [object object];
    }
	[objectHistory removeObject:object];
	[objectHistory insertObject:object atIndex:0];
	while ([objectHistory count] > MAXHIST)
		[objectHistory removeLastObject];
	[[NSNotificationCenter defaultCenter] postNotificationName:QSCatalogEntryInvalidated object:@"QSPresetObjectHistory"];
}

@end
