//
//  BBSignInViewController.h
//  BomBom
//
//  Created by Alexey Kolmyk on 16.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBTextField.h"

@interface BBSignInViewController : UIViewController

@property (nonatomic, weak) IBOutlet BBTextField *login;
@property (nonatomic, weak) IBOutlet BBTextField *pass;

- (IBAction)signIn:(id)sender;

@end
