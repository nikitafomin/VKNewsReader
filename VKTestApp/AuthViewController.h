//
//  AuthViewController.h
//  VKTestApp
//
//  Created by Nikita Fomin on 14/02/14.
//  Copyright (c) 2014 Nikita Fomin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthViewController : UIViewController <VKSdkDelegate>

@property (strong, nonatomic) IBOutlet UIButton *signInClick;

- (IBAction)signInClick:(id)sender;

@end
