//
//  RootViewController.h
//  ADNChallenge
//
//  Created by Joefrey Kibuule on 8/8/13.
//  Copyright (c) 2013 Joefrey Kibuule. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ADNStream.h"

@class ADNStream;

@interface RootViewController : UITableViewController <ADNStreamDelegate>
{
    // UI elements
    UIRefreshControl *refreshControl;
    
    // Data elements
    ADNStream *globalStream;
}

@property (nonatomic, retain) UIRefreshControl *refreshControl;

@property (nonatomic, retain) ADNStream *globalStream;

- (void)streamRefreshedWithError:(NSError *)error;

@end
