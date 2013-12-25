//
//  BBPostEntity.m
//  BomBom
//
//  Created by Alexey Kolmyk on 18.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "BBPostEntity.h"

@implementation BBPostEntity

+ (id)createPostFromData:(QBCOCustomObject *)anObject {
	if (!anObject) {
		return nil;
	}
	
	NSMutableDictionary *fields = anObject.fields;
	if (!fields) {
		return nil;
	}
	BBPostEntity *entity = [BBPostEntity new];
	entity.content = fields[@"content"];
	entity.contentBlobId = [fields[@"blobId"] integerValue];
	entity.title = fields[@"title"];
	
	QBUUser *user = [QBUUser user];
	user.ID = anObject.userID;
	entity.user = user;
	
	entity.date = anObject.createdAt;
	entity.postID = anObject.ID;
	
	return entity;
}

@end
