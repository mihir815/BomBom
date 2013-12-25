//
//  BBSignUpViewController.h
//  BomBom
//
//  Created by Alexey Kolmyk on 16.12.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BBTextField.h"

@interface BBSignUpViewController : UIViewController

@property (nonatomic, weak) IBOutlet BBTextField	*login;
@property (nonatomic, weak) IBOutlet BBTextField	*pass;
@property (nonatomic, weak) IBOutlet BBTextField	*confirmPass;
@property (nonatomic, weak)	IBOutlet UIImageView	*avatar;

- (IBAction)signUp:(id)sender;
- (IBAction)pickImage:(id)sender;

@end
