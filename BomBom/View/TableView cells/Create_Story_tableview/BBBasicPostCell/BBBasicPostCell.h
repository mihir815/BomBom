//
//  BBBasicPostCell.h
//  BomBom
//
//  Created by Alexey Kolmyk on 18.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BBPostCellDelegate;

@interface BBBasicPostCell : UITableViewCell

@property (nonatomic, weak) IBOutlet id<BBPostCellDelegate>	delegate;

- (UITextField *) getPostTextField;
- (UITextView *) getPostTextView;

- (void) configurePostImage:(UIImage *)postImage;

@end

@protocol BBPostCellDelegate <NSObject>

@optional
-(void)didSelectImagePressed;
-(void)didCancelImagePressed;
-(void)createPostDidPressed;

@end

