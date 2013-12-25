//
//  BBCommentEntity.m
//  BomBom
//
//  Created by Alexey Kolmyk on 19.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "BBCommentEntity.h"

@implementation BBCommentEntity

+ (id)createCommentFromData:(QBCOCustomObject *)anObject {
	if (!anObject) {
		return nil;
	}
	
	NSMutableDictionary *fields = anObject.fields;
	if (!fields) {
		return nil;
	}
	BBCommentEntity *entity = [BBCommentEntity new];
	entity.comment = fields[@"comment"];
	
	QBUUser *user = [QBUUser user];
	user.ID = anObject.userID;
	entity.user = user;
	
	entity.date = anObject.createdAt;
	entity.commentID = anObject.ID;
	
	return entity;

}

@end
