//
//  QBClient.m
//  BomBom
//
//  Created by Alexey Kolmyk on 16.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "QBClient.h"

@interface QBClient () <QBActionStatusDelegate>

@property (nonatomic, copy)	QBUUser *currentUser;

@end


@implementation QBClient

+ (id)shared {
	static QBClient *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
	
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[[self class] alloc] init];
		
        [QBSettings setApplicationID:QBAppID];
        [QBSettings setAuthorizationKey:QBAuthKey];
        [QBSettings setAuthorizationSecret:QBAuthSecret];
    });
	
    return _sharedInstance;
}

#pragma mark - Session

-(void) createSessionQithBlock:(qbSessionBlock)aBlock {
    void (^block)(Result *) = ^(Result *result) {
        if (!result.success) {
			aBlock(NO, [self errorWithQBResult:result]);
        } else {
			aBlock(YES, nil);
        }
    };
    [QBAuth createSessionWithDelegate:self
                              context:(__bridge_retained void *)(block)];
}


-(void) createExtendedSessinWithBlock:(qbSessionBlock)aBlock {

	if (!self.currentUser) {
		aBlock(NO, nil);
		return;
	}
	
	QBASessionCreationRequest *extendedRequest = [QBASessionCreationRequest new];
	extendedRequest.userLogin = self.currentUser.login;
	extendedRequest.userPassword = self.currentUser.password;
	
	void (^block)(Result *) = ^(Result *result) {
        if (!result.success) {
			aBlock(NO, [self errorWithQBResult:result]);
        } else {
			aBlock(YES, nil);
        }
    };
    [QBAuth createSessionWithExtendedRequest:extendedRequest
									delegate:self
									 context:(__bridge_retained void *)(block)];
	
}

-(BOOL) isCurrentSessionValid {
	return [[QBBaseModule sharedModule].tokenExpirationDate compare:[NSDate date]] == NSOrderedDescending;
}

#pragma mark - Users

-(QBUUser *)getCurrentUser {
	return self.currentUser;
}

-(void)signUpWithLogin:(NSString *)aLogin
				  pass:(NSString *)aPass
				 block:(qbUserBlock)aBlock {
	
	if (aLogin.length == 0 || aPass.length == 0) {
		aBlock(nil, nil);
		return;
	}
		
	void (^block)(Result *) = ^(Result *result) {
        if (!result.success) {
           aBlock(nil, [self errorWithQBResult:result]);
        }else{
			QBUUserResult *res = (QBUUserResult *)result;
			aBlock(res.user, nil);
		}
    };
	
	QBUUser *user	= [QBUUser new];
	user.password	= aPass;
	user.login		= aLogin;
	
	[QBUsers signUp:user
		   delegate:self
			context:(__bridge_retained void *)(block)];
	
}

-(void)signInWithLogin:(NSString *)aLogin
				  pass:(NSString *)aPass
				 block:(qbUserBlock)aBlock {
	
	if (aLogin.length == 0 || aPass.length == 0){
		aBlock(nil, nil);
		return;
	}
	
	void (^block)(Result *) = ^(Result *result) {
        if (!result.success) {
			aBlock(nil, [self errorWithQBResult:result]);
        }else{
			QBUUserLogInResult *userLogInResult = (QBUUserLogInResult *)result;
            self.currentUser = userLogInResult.user;
			self.currentUser.password = aPass;
			aBlock(userLogInResult.user, nil);
		}
    };
	
	[QBUsers logInWithUserLogin:aLogin
                       password:aPass
                       delegate:self
                        context:(__bridge_retained void *)(block)];
	
}

-(void)updateCurrentUserBlobId:(NSUInteger)blobId
						 block:(qbUserBlock)aBlock {
	if (blobId == 0){
		aBlock(nil, nil);
		return;
	}
	
	QBUUser *updatedUser = [self.currentUser copy];
	updatedUser.blobID = blobId;
	updatedUser.password = nil;
	
	[self updateCurrentUser:updatedUser block:aBlock];
}

-(void)updateCurrentUserLogin:(NSString *)aNewLogin
						block:(qbUserBlock)aBlock {
	if (!aNewLogin || aNewLogin.length == 0) {
		aBlock(nil, nil);
		return;
	}
	
	QBUUser *updatedUser = [self.currentUser copy];
	updatedUser.login = aNewLogin;
	updatedUser.password = nil;
	
	[self updateCurrentUser:updatedUser block:aBlock];
}

-(void)updateCurrentUserEmail:(NSString *)aNewEmail
						block:(qbUserBlock)aBlock {
	
	QBUUser *updatedUser = [self.currentUser copy];
	updatedUser.email = aNewEmail;
	updatedUser.password = nil;
	
	[self updateCurrentUser:updatedUser block:aBlock];
}

-(void)updateCurrentUserWithOldPassword:(NSString *)aOldPass
								newPass:(NSString *)aNewPass
								  block:(qbUserBlock)aBlock {
	
	QBUUser *updatedUser = [self.currentUser copy];
	updatedUser.oldPassword = aOldPass;
	updatedUser.password = aNewPass;
	
	[self updateCurrentUser:updatedUser block:aBlock];
}

-(void)getUsersByIDs:(NSMutableString *)usersID
			   block:(qbUsersBlock)aBlock {
	if (usersID.length == 0 || !usersID){
		aBlock(nil, nil);
		return;
	}
	
	void (^block)(Result *) = ^(Result *result) {
        if (!result.success) {
            aBlock (nil, [self errorWithQBResult:result]);
        } else {
            QBUUserPagedResult *usersResult = (QBUUserPagedResult *)result;
			aBlock (usersResult.users, nil);
        }
    };

	[QBUsers usersWithIDs:usersID
				 delegate:self
				  context:(__bridge_retained void *)(block)];
}


-(void)updateCurrentUser:(QBUUser *)updatedUser
				   block:(qbUserBlock)aBlock {
	
	if (!updatedUser || self.currentUser == nil) {
		aBlock(nil, nil);
		return;
	}

	NSString *newPass = [updatedUser.password copy];
	
	void (^block)(Result *) = ^(Result *result) {
        if (!result.success) {
            aBlock (nil, [self errorWithQBResult:result]);
        } else {
            QBUUserResult *userUpdateResult = (QBUUserResult *)result;
			self.currentUser = userUpdateResult.user;
			self.currentUser.password = newPass;
			aBlock (self.currentUser, nil);
        }
    };
	
	[QBUsers updateUser:updatedUser
               delegate:self
                context:(__bridge_retained void *)(block)];
}

#pragma mark - Content

-(void)uploadImage:(UIImage *)aImage
			 block:(qbUploadContentBlock)aBlock {
	
	if (!aImage) {
        aBlock(0, nil);
        return;
    }
	
    void (^block)(Result *) = ^(Result *result) {
        if (!result.success) {
            aBlock(0, [self errorWithQBResult:result]);
        } else {
            QBCFileUploadTaskResult *fileUploadTaskResult = (QBCFileUploadTaskResult *)result;
            aBlock(fileUploadTaskResult.uploadedBlob.ID, nil);
        }
    };
	
	[QBContent TUploadFile:[NSData dataWithData:UIImageJPEGRepresentation(aImage, 1.0f)]
                  fileName:@"filename"
               contentType:@"image/png"
                  isPublic:YES
                  delegate:self
                   context:(__bridge_retained void *)(block)];
}

-(void)updateImage:(UIImage *)aNewImage
			blobID:(NSUInteger)blobID
			 block:(qbUploadContentBlock)aBlock; {
	
	if (blobID <= 0 || !aNewImage) {
        aBlock(0, nil);
        return;
    }
	
	void (^block)(Result *) = ^(Result *result) {
        if (!result.success) {
            aBlock(0, [self errorWithQBResult:result]);
        } else {
            QBCFileUploadTaskResult *fileUploadTaskResult = (QBCFileUploadTaskResult *)result;
            aBlock(fileUploadTaskResult.uploadedBlob.ID, nil);
        }
    };
	
	QBCBlob *updatedImage = [QBCBlob blob];
	updatedImage.ID = blobID;
	
	[QBContent TUpdateFileWithData:[NSData dataWithData:UIImageJPEGRepresentation(aNewImage, 1.0f)]
							  file:updatedImage
						  delegate:self
						   context:(__bridge_retained void *)(block)];
}

-(void)downloadImageWithBlobId:(NSUInteger)blobID
						 block:(qbDownloadContentBlock)aBlock {
	if (blobID <= 0) {
        aBlock(nil, nil);
        return;
    }
	
    void (^block)(Result *) = ^(Result *result) {
        if (!result.success) {
            aBlock(nil, [self errorWithQBResult:result]);
        } else {
            QBCFileDownloadTaskResult *fileDownloadTaskResult = (QBCFileDownloadTaskResult *)result;
            aBlock(fileDownloadTaskResult.file, nil);
        }
    };
    [QBContent TDownloadFileWithBlobID:blobID
                              delegate:self
                               context:(__bridge_retained void *)(block)];
}

#pragma mark - Custom objects

-(void) createCustomObjectWithTitle:(NSString *)aTitle
							content:(NSString *)aContent
							 blobId:(NSUInteger)blobID
							  block:(qbCreatePostBlock)aBlock {
	if (aTitle.length == 0 || !aTitle) {
		aBlock(nil, nil);
		return;
	}

	
	if (aContent.length == 0 || !aContent) {
		aBlock(nil, nil);
		return;
	}
	
	QBCOCustomObject *customObject = [QBCOCustomObject customObject];
	
	customObject.className = @"BBPostEntity";
	
	// Object fields
	[customObject.fields setObject:aTitle forKey:@"title"];
	[customObject.fields setObject:aContent forKey:@"content"];
	
	if (blobID > 0) {
		[customObject.fields setObject:@(blobID) forKey:@"blobId"];
	}else {
		[customObject.fields setObject:@0 forKey:@"blobId"];
	}
	
    void (^block)(Result *) = ^(Result *result) {
        if (!result.success) {
			aBlock(nil, [self errorWithQBResult:result]);
        } else {
            QBCOCustomObjectResult *customObjectResult = (QBCOCustomObjectResult *)result;
			BBPostEntity *createdPost = [BBPostEntity createPostFromData:customObjectResult.object];
            aBlock(createdPost, nil);
        }
    };
	
    [QBCustomObjects createObject:customObject
                         delegate:self
                          context:(__bridge_retained void *)(block)];
}

//-(void) fetchMyStoriesWithPaging:(BOOL)isLoadMore
//					   withBlock:(qbPostsBlock)aBlock {
//	
//	if (!self.currentUser) {
//		aBlock(nil, nil);
//		return;
//	}
//	
//	NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
//	[getRequest setObject:@"created_at" forKey:@"sort_desc"];
//	[getRequest setObject:@(self.currentUser.ID) forKey:@"user_id"];
//	if (isLoadMore) {
//		[getRequest setObject:@(self.myStoriesCounter) forKey:@"skip"];
//	}else{
//		[getRequest setObject:@0 forKey:@"skip"];
//	}
//	[getRequest setObject:@10 forKey:@"limit"];
//	
//	[self fetchCustomObjectWithExtendedRequest:getRequest
//										 class:@"BBPostEntity"
//										 block:^(NSMutableArray *items, NSError *anError) {
//		if ([items count] > 0 || !items) {
//			NSMutableArray *stories = [NSMutableArray new];
//			for (QBCOCustomObject *co in items) {
//				BBPostEntity *story = [BBPostEntity createPostFromData:co];
//				story.user = self.currentUser;
//				[stories addObject:story];
//			}
//			self.myStoriesCounter += [stories count];
//			aBlock(stories, nil);
//			
//		}else{
//			aBlock(nil, anError);
//		}
//	}];
//}

-(void) fetchMyStoriesWithBlock:(qbPostsBlock)aBlock {
	[self fetchStoriesForCurrentUser:YES
						  withUpdate:nil
						  withPaging:nil
							   block:aBlock];
}

-(void) pagingMyStoriesFromLastDate:(NSDate *)lastItemTime
						  withBlock:(qbPostsBlock)aBlock {
	
	if (!lastItemTime) {
		aBlock(nil, nil);
		return;
	}
	
	[self fetchStoriesForCurrentUser:YES
						  withUpdate:nil
						  withPaging:lastItemTime
							   block:aBlock];
}

-(void) updateStoriesFromLastDate:(NSDate *)updateTime
						withBlock:(qbPostsBlock)aBlock {
	
	[self fetchStoriesForCurrentUser:NO
						  withUpdate:(updateTime ? updateTime : nil)
						  withPaging:nil
							   block:aBlock];
}


-(void) fetchStoriesWithBlock:(qbPostsBlock)aBlock {
	[self fetchStoriesForCurrentUser:NO
						  withUpdate:nil
						  withPaging:nil
							   block:aBlock];
}

-(void) pagingStoriesFromLastDate:(NSDate *)lastItemTime
						withBlock:(qbPostsBlock)aBlock {
	
	if (!lastItemTime) {
		aBlock(nil, nil);
		return;
	}
	
	[self fetchStoriesForCurrentUser:NO
						  withUpdate:nil
						  withPaging:lastItemTime
							   block:aBlock];
}

-(void) fetchStoriesForCurrentUser:(BOOL)forCurrenrtUser
						withUpdate:(NSDate *)firstPostTime
						withPaging:(NSDate *)lastPostTime
							 block:(qbPostsBlock)aBlock {
	
	NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
	[getRequest setObject:@"created_at" forKey:@"sort_desc"];
	[getRequest setObject:@0 forKey:@"skip"];
	[getRequest setObject:@10 forKey:@"limit"];
	
	if (forCurrenrtUser) {
		
		if (!self.currentUser) {
			aBlock (nil, nil);
			return;
		}
		[getRequest setObject:@(self.currentUser.ID) forKey:@"user_id"];
	}
	
	if (firstPostTime) {
		NSTimeInterval convertedTime = [firstPostTime timeIntervalSince1970];
		[getRequest setObject:@(convertedTime) forKey:@"created_at[gt]"];
	
	}else if (lastPostTime) {
		NSTimeInterval convertedTime = [lastPostTime timeIntervalSince1970];
		[getRequest setObject:@(convertedTime) forKey:@"created_at[lt]"];
	}
	
	[self fetchCustomObjectWithExtendedRequest:getRequest
										 class:@"BBPostEntity"
										 block:^(NSMutableArray *items, NSError *anError) {
											 if ([items count] > 0 || !items) {
												 NSMutableArray *stories = [NSMutableArray new];
												 NSMutableSet *userIDs = [NSMutableSet new];
												 for (QBCOCustomObject *co in items) {
													 BBPostEntity *story = [BBPostEntity createPostFromData:co];
													 if (forCurrenrtUser) {
														 story.user = self.currentUser;
													 }
													 [stories addObject:story];
													 [userIDs addObject:@(story.user.ID)];
												 }
												 if (forCurrenrtUser) {
													 aBlock(stories, nil);
													 return;
												 }
												 
												 NSMutableString *usersId = [self createStringIDFromUsersSet:userIDs];
												 [self getUsersByIDs:usersId block:^(NSArray *users, NSError *anError) {
													 if (users.count == 0 || users) {
														 
														 for (BBPostEntity *story in stories) {
															 story.user = [self getUserById:story.user.ID fromResult:users];
														 }
														 
														 aBlock(stories, nil);
													 }else{
														 aBlock(nil, anError);
													 }
													 
												 }];
											 }else{
												 aBlock(nil, anError);
											 }
										 }];
}

-(void) createCommentForObjectID:(NSString *)aPostID
						 comment:(NSString *)aComment
						   block:(qbCreateCommentBlock)aBlock {
	
	if (aPostID.length == 0 || !aPostID) {
		aBlock(nil, nil);
		return;
	}
	
	
	if (aComment.length == 0 || !aComment) {
		aBlock(nil, nil);
		return;
	}
	
	if (!self.currentUser) {
		aBlock(nil, nil);
		return;
	}
	
	QBCOCustomObject *customObject = [QBCOCustomObject customObject];
	
	customObject.className = @"BBCommentEntity";
	customObject.parentID = aPostID;
	
	// Object fields
	[customObject.fields setObject:aComment forKey:@"comment"];
	[customObject.fields setObject:@(self.currentUser.ID) forKey:@"authorId"];
	
	
    void (^block)(Result *) = ^(Result *result) {
        if (!result.success) {
			aBlock(nil, [self errorWithQBResult:result]);
        } else {
            QBCOCustomObjectResult *customObjectResult = (QBCOCustomObjectResult *)result;
			BBCommentEntity *comment = [BBCommentEntity createCommentFromData:customObjectResult.object];
			comment.user = self.currentUser;
            aBlock(comment, nil);
        }
    };
	
    [QBCustomObjects createObject:customObject
                         delegate:self
                          context:(__bridge_retained void *)(block)];
}


-(void) updateCommentsForPost:(NSString *)postId
					 lastTime:(NSDate *)updateTime
						block:(qbPostsBlock)aBlock {
	
	[self fetchCommentsForPost:postId
				  withUpdating:(updateTime ? updateTime : nil)
					withPaging:nil
						 block:aBlock];
}

-(void) fetchCommentsForPost:(NSString *)postId
					   block:(qbCommentsBlock)aBlock {
	
	[self fetchCommentsForPost:postId
				  withUpdating:nil
					withPaging:nil
						 block:aBlock];
}

-(void) pagingCommentsForPost:(NSString *)aPostID
				 fromLastDate:(NSDate *)lastItemTime
						block:(qbCommentsBlock)aBlock {
	
	if (!aPostID) {
		aBlock(nil, nil);
		return;
	}
	
	[self fetchCommentsForPost:aPostID
				  withUpdating:nil
					withPaging:lastItemTime
						 block:aBlock];
}

-(void) fetchCommentsForPost:(NSString *)postId
				withUpdating:(NSDate *)firstCommentTime
				  withPaging:(NSDate *)lastCommentTime
					   block:(qbCommentsBlock)aBlock {
	
	if (!postId || postId.length == 0) {
		aBlock(nil, nil);
		return;
	}
	
	NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
	[getRequest setObject:@"created_at" forKey:@"sort_desc"];
	[getRequest setObject:postId forKey:@"_parent_id"];
	[getRequest setObject:@0 forKey:@"skip"];
	[getRequest setObject:@10 forKey:@"limit"];
	
	if (firstCommentTime) {
		NSTimeInterval convertedTime = [firstCommentTime timeIntervalSince1970];
		[getRequest setObject:@(convertedTime) forKey:@"created_at[gt]"];
		
	}else if (lastCommentTime) {
		NSTimeInterval convertedTime = [lastCommentTime timeIntervalSince1970];
		[getRequest setObject:@(convertedTime) forKey:@"created_at[lt]"];
	}
	
	[self fetchCustomObjectWithExtendedRequest:getRequest
										 class:@"BBCommentEntity"
										 block:^(NSMutableArray *items, NSError *anError) {
											 if ([items count] > 0 || !items) {
												 NSMutableArray *comments = [NSMutableArray new];
												 NSMutableSet *userIDs = [NSMutableSet new];
												 for (QBCOCustomObject *co in items) {
													 BBCommentEntity *comment = [BBCommentEntity createCommentFromData:co];
													 [comments addObject:comment];
													 [userIDs addObject:@(comment.user.ID)];
												 }
												 NSMutableString *usersId = [self createStringIDFromUsersSet:userIDs];
												 [self getUsersByIDs:usersId block:^(NSArray *users, NSError *anError) {
													 if (users.count == 0 || users) {
														 
														 for (BBPostEntity *story in comments) {
															 story.user = [self getUserById:story.user.ID fromResult:users];
														 }
														 aBlock(comments, nil);
													 }else{
														 aBlock(nil, anError);
													 }
													 
												 }];
											 }else{
												 aBlock(nil, anError);
											 }
										 }];
}

-(void) fetchCustomObjectWithExtendedRequest:(NSMutableDictionary *)request
									   class:(NSString *)className
									   block:(qbItemsBlock)aBlock {
	if (className.length == 0 || !className) {
		aBlock (nil, nil);
		return;
	}
	
	void (^block)(Result *) = ^(Result *result) {
		if (!result.success) {
			aBlock(nil, [self errorWithQBResult:result]);
        } else {
			QBCOCustomObjectPagedResult *customObjectPagedResult = (QBCOCustomObjectPagedResult *)result;
			 aBlock([customObjectPagedResult.objects mutableCopy], nil);
		}
	};
	
	[QBCustomObjects objectsWithClassName:className
						  extendedRequest:request
								 delegate:self
								  context:(__bridge_retained void *)(block)];
	
}


-(void) logoutWithBlock:(qbLogoutBlock)aBlock {
	
	void (^block)(Result *) = ^(Result *result) {
		if (!result.success) {
			aBlock(NO, [self errorWithQBResult:result]);
		}else{
			self.currentUser = nil;
			aBlock(YES, nil);
		}
	};
	
	[QBUsers logOutWithDelegate:self context:(__bridge_retained void *)(block)];
}


#pragma mark -
#pragma mark - Error

- (NSError *)errorWithQBResult:(Result*)aResult {
    if (!aResult
		|| aResult.success) {
        return nil;
    }
    NSMutableDictionary *userInfo = nil;
    if ([aResult.errors count]) {
        userInfo = [NSMutableDictionary dictionaryWithObject:[aResult.errors objectAtIndex:0]
                                                      forKey:@"userInfo"];
    }
    NSError *error = [NSError errorWithDomain:@"userInfo"
                                         code:aResult.status
                                     userInfo:userInfo];
    return error;
}

+ (void) showAlertForError:(NSError *)anError {
	NSString *text = [anError.userInfo objectForKey:@"userInfo"];
	
	UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil
														 message:text
														delegate:nil
											   cancelButtonTitle:@"Ok"
											   otherButtonTitles:nil];
	[errorAlert show];
}


#pragma mark -
#pragma mark QBActionStatusDelegate

- (void)completedWithResult:(Result *)result
                    context:(void *)contextInfo {
    void(^myBlock)(Result *result) = (__bridge void (^)(Result *__strong))(contextInfo);
    myBlock(result);
    Block_release(contextInfo);
}

#pragma mark -
#pragma mark Private

-(NSMutableString *)createStringIDFromUsersSet:(NSMutableSet *)userSet {
	NSMutableString *retVal = [NSMutableString new];
	
	for (NSNumber *userId in userSet) {
		[retVal appendString:[NSString stringWithFormat:@"%ld,", (long)userId.integerValue]];
	}
	
	return retVal;
}

-(QBUUser *) getUserById:(NSUInteger)userID
			  fromResult:(NSArray *)users {
	if (users.count == 0 || !users) {
		return nil;
	}
	
	if (userID <= 0) {
		return nil;
	}
	
	for (QBUUser *user in users) {
		if (user.ID == userID) {
			return user;
		}
	}
	return nil;
}


@end
