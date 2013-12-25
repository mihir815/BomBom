//
//  UIImageView+QBContent.m
//  BomBom
//
//  Created by Alexey Kolmyk on 17.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "UIImageView+QBContent.h"

#import "QBClient.h"

@implementation UIImageView (QBContent)

-(void)loadImageWithBlobId:(NSUInteger)blobId {
	
	[self loadImageWithBlobId:blobId completion:nil];
}


-(void)loadImageWithBlobId:(NSUInteger)blobId completion:(qbImageBlock)aBlock {
	if (blobId <= 0) {
		return;
	}
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[[QBClient shared] downloadImageWithBlobId:blobId block:^(NSData *data, NSError *anError) {
			if (data) {
				dispatch_async(dispatch_get_main_queue(), ^{
					if (!self){
						return;
					}
					self.image = [UIImage imageWithData:data];
					if (aBlock) {
						aBlock(YES, nil);
					}
				});
			
			}else{
				if (aBlock) {
					aBlock(NO, anError);
				}
			}
		}];
	});
}

@end
