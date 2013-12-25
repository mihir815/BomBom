//
//  BBBasicViewController.h
//  BomBom
//
//  Created by Alexey Kolmyk on 16.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASlideMenuRootViewController.h"

#import "BBLoadMoreView.h"

@interface BBBasicViewController : UIViewController

@property (nonatomic,strong)	SASlideMenuViewController	*menuController;
@property (nonatomic, assign)	BOOL						isLoadingNow;
@property (nonatomic, strong)	UIRefreshControl			*pullRefresh;
@property (nonatomic, strong)	BBLoadMoreView				*loadMoreView;
@property (nonatomic, assign)	BOOL						isLoadedAllData;

-(void)showAlertWithText:(NSString *)aText;

@end
