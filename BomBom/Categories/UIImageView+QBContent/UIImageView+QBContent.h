//
//  UIImageView+QBContent.h
//  BomBom
//
//  Created by Alexey Kolmyk on 17.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (QBContent)

typedef void (^qbImageBlock)(BOOL isLoaded, NSError *anError);

-(void)loadImageWithBlobId:(NSUInteger)blobId;

-(void)loadImageWithBlobId:(NSUInteger)blobId completion:(qbImageBlock)aBlock;

@end
