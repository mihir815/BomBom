//
//  BBProfileCell.h
//  BomBom
//
//  Created by Alexey Kolmyk on 17.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum BBProfileCellType{
	BBProfileCellTypeNone = 0,
	BBProfileCellTypeAvatar,
	BBProfileCellTypeLogin,
	BBProfileCellTypeEmail,
	BBProfileCellTypePassword
	
}BBProfileCellType;

@protocol BBProfileCellDelegate;

@interface BBProfileCell : UITableViewCell

@property (nonatomic, weak)	id<BBProfileCellDelegate> delegate;
@property (nonatomic, assign) BBProfileCellType		  type;

-(IBAction)buttonDidPressed:(id)sender;

-(void) configureFieldWithTopText:(NSString *)topText
					   bottomText:(NSString *)bottomText
						 delegate:(id)delegate
							 type:(BBProfileCellType)aType;

-(void) configureForAvatar:(NSUInteger)blobID
				  delegate:(id)delegate
					  type:(BBProfileCellType)aType;

@end


@protocol BBProfileCellDelegate <NSObject>

@optional
-(void)changeUserData:(BBProfileCellType)aType;

@end