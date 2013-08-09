//
//  ADNAppDelegate.h
//  ADNChallenge
//
//  Created by Joefrey Kibuule on 8/8/13.
//  Copyright (c) 2013 Joefrey Kibuule. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADNViewController;

@interface ADNAppDelegate : UIResponder <UIApplicationDelegate>
{
    IBOutlet UIWindow *window;
    IBOutlet UINavigationController *navigationController;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;

@end
