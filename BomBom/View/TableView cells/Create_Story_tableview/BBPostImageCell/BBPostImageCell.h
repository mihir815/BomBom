//
//  BBPostImageCell.h
//  BomBom
//
//  Created by Alexey Kolmyk on 18.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "BBBasicPostCell.h"

@interface BBPostImageCell : BBBasicPostCell

@property	(nonatomic, weak)	IBOutlet	UIImageView		*postImage;

-(IBAction)selectImage:(id)sender;
-(IBAction)clearImage:(id)sender;
-(IBAction)tapOnImage:(id)sender;

@end
