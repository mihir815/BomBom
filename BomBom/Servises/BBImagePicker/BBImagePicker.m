//
//  BBImagePicker.m
//  BomBom
//
//  Created by Alexey Kolmyk on 17.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "BBImagePicker.h"

@interface BBImagePicker () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong)	UIImagePickerController *picker;
@property (nonatomic, weak)		UIViewController		*vc;
@property (nonatomic, copy)     imageBlock				completionBlock;

@end

@implementation BBImagePicker

+ (id)shared {
	static BBImagePicker *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
	
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[[self class] alloc] init];
		
		_sharedInstance.picker = [UIImagePickerController new];
		_sharedInstance.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		_sharedInstance.picker.delegate = _sharedInstance;
    });
	
    return _sharedInstance;
}

- (void) getImageFromGalleryForViewController:(UIViewController *)vc
									withBlock:(imageBlock)aBlock {
	
	self.completionBlock = aBlock;
	
	[vc presentViewController:self.picker
					 animated:YES
				   completion:nil];
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
   
	[picker dismissViewControllerAnimated:YES completion:^ {
		UIImage *selectedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
		self.completionBlock(selectedImage, BBImageStatusSelected);
	}];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];

	[picker dismissViewControllerAnimated:YES completion:^{
		self.completionBlock(nil, BBImageStatusCanceled);
    }];
	
}



@end
