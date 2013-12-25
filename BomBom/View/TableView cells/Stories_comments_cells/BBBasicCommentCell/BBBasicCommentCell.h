//
//  BBBasicCommentCell.h
//  BomBom
//
//  Created by Alexey Kolmyk on 19.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BBPostEntity.h"
#import "BBCommentEntity.h"

@interface BBBasicCommentCell : UITableViewCell

-(void) configureForPost:(BBPostEntity *)post;

-(void) configureForComment:(BBCommentEntity *)comment;

+(CGFloat) heightForTextInCell:(NSString *)aTitle;

+(CGFloat) heightForCommentCell:(NSString *)comment;



@end
