//
//  BBCommentEntity.h
//  BomBom
//
//  Created by Alexey Kolmyk on 19.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBCommentEntity : NSObject

@property (nonatomic, copy)		QBUUser		*user;
@property (nonatomic, copy)		NSString	*comment;
@property (nonatomic, copy)		NSDate		*date;
@property (nonatomic, copy)		NSString	*commentID;

+ (id)createCommentFromData:(QBCOCustomObject *)anObject;

@end
