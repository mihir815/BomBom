//
//  BBImagePicker.h
//  BomBom
//
//  Created by Alexey Kolmyk on 17.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum BBImageStatus {
	BBImageStatusCanceled = 0,
	BBImageStatusSelected,
}BBImageStatus;

typedef void (^imageBlock)(UIImage *image, BBImageStatus status);

@interface BBImagePicker : NSObject

+ (id)shared;

- (void) getImageFromGalleryForViewController:(UIViewController *)vc
									withBlock:(imageBlock)aBlock;

@end
