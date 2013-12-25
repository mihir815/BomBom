//
//  BBPostEntity.h
//  BomBom
//
//  Created by Alexey Kolmyk on 18.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBPostEntity : NSObject

@property (nonatomic, copy)		NSString	*title;
@property (nonatomic, copy)		NSString	*content;
@property (nonatomic, assign)	NSUInteger	contentBlobId;
@property (nonatomic, copy)		QBUUser		*user;
@property (nonatomic, copy)		NSDate		*date;
@property (nonatomic, copy)		NSString	*postID;

+ (id)createPostFromData:(QBCOCustomObject *)anObject;

@end
