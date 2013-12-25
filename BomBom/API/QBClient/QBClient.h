//
//  QBClient.h
//  BomBom
//
//  Created by Alexey Kolmyk on 16.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BBPostEntity.h"
#import "BBCommentEntity.h"

@interface QBClient : NSObject

+ (id)shared;

#pragma mark - Session

typedef void (^qbSessionBlock)(BOOL isCreated, NSError *anError);

-(void) createSessionQithBlock:(qbSessionBlock)aBlock;

-(void) createExtendedSessinWithBlock:(qbSessionBlock)aBlock;

-(BOOL) isCurrentSessionValid;

#pragma mark - Users

typedef void (^qbUserBlock)(QBUUser *aUser, NSError *anError);
typedef void (^qbUsersBlock)(NSArray *users, NSError *anError);

-(void)signUpWithLogin:(NSString *)aLogin
				  pass:(NSString *)aPass
				 block:(qbUserBlock)aBlock;

-(void)signInWithLogin:(NSString *)aLogin
				  pass:(NSString *)aPass
				 block:(qbUserBlock)aBlock;

-(void)updateCurrentUserBlobId:(NSUInteger)blobId
						 block:(qbUserBlock)aBlock;

-(void)updateCurrentUserLogin:(NSString *)aNewLogin
						 block:(qbUserBlock)aBlock;

-(void)updateCurrentUserEmail:(NSString *)aNewEmail
						block:(qbUserBlock)aBlock;

-(void)updateCurrentUserWithOldPassword:(NSString *)aOldPass
								newPass:(NSString *)aNewPass
								  block:(qbUserBlock)aBlock;

-(void)getUsersByIDs:(NSMutableString *)usersID
			   block:(qbUsersBlock)aBlock;

-(QBUUser *)getCurrentUser;

#pragma mark - Content

typedef void (^qbUploadContentBlock)(NSUInteger blobID, NSError *anError);
typedef void (^qbDownloadContentBlock)(NSData *data, NSError *anError);

-(void)uploadImage:(UIImage *)aImage
			 block:(qbUploadContentBlock)aBlock;

-(void)updateImage:(UIImage *)aNewImage
			blobID:(NSUInteger)blobID
			 block:(qbUploadContentBlock)aBlock;

-(void)downloadImageWithBlobId:(NSUInteger)blobID
						 block:(qbDownloadContentBlock)aBlock;


#pragma mark - Custom objects

typedef void (^qbItemsBlock)(NSMutableArray *items, NSError *anError);

typedef void (^qbCreatePostBlock)(BBPostEntity *post, NSError *anError);
typedef void (^qbPostsBlock)(NSMutableArray *posts, NSError *anError);

typedef void (^qbCreateCommentBlock)(BBCommentEntity *comment, NSError *anError);
typedef void (^qbCommentsBlock)(NSMutableArray *comments, NSError *anError);


-(void) createCustomObjectWithTitle:(NSString *)aTitle
							content:(NSString *)aContent
							 blobId:(NSUInteger)blobID
							  block:(qbCreatePostBlock)aBlock;

-(void) fetchMyStoriesWithBlock:(qbPostsBlock)aBlock;

-(void) pagingMyStoriesFromLastDate:(NSDate *)lastItemTime
						  withBlock:(qbPostsBlock)aBlock;



-(void) updateStoriesFromLastDate:(NSDate *)updateTime
						withBlock:(qbPostsBlock)aBlock;

-(void) fetchStoriesWithBlock:(qbPostsBlock)aBlock;

-(void) pagingStoriesFromLastDate:(NSDate *)lastItemTime
						withBlock:(qbPostsBlock)aBlock;



-(void) createCommentForObjectID:(NSString *)aPostID
						 comment:(NSString *)aComment
						   block:(qbCreateCommentBlock)aBlock;

-(void) updateCommentsForPost:(NSString *)postId
					 lastTime:(NSDate *)updateTime
						block:(qbPostsBlock)aBlock;

-(void) fetchCommentsForPost:(NSString *)postId
					   block:(qbCommentsBlock)aBlock;

-(void) pagingCommentsForPost:(NSString *)aPostID
				 fromLastDate:(NSDate *)lastItemTime
						block:(qbCommentsBlock)aBlock;

#pragma mark - Other

typedef void (^qbLogoutBlock)(BOOL isLogoitPerformed, NSError *anError);

-(void) logoutWithBlock:(qbLogoutBlock)aBlock;

+(void) showAlertForError:(NSError *)anError;

@end
