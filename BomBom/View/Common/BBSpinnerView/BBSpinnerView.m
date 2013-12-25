//
//  BBSpinnerView.m
//  BomBom
//
//  Created by Alexey Kolmyk on 16.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "BBSpinnerView.h"

static UIView *backgroundView = nil;


@implementation BBSpinnerView

+ (void)showSpinner {
    if (!backgroundView) {
        backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
        backgroundView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        indicator.center = backgroundView.center;
        [backgroundView addSubview:indicator];
        [indicator startAnimating];
    }
    [[[[UIApplication sharedApplication] windows] lastObject] addSubview:backgroundView];
}

+ (void)hideSpinner {
    if (backgroundView) {
        [backgroundView removeFromSuperview];
        backgroundView = nil;
    }
}

@end
