//
//  RootViewController.h
//  ADNChallenge
//
//  Created by Joefrey Kibuule on 8/8/13.
//  Copyright (c) 2013 Joefrey Kibuule. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ADNStream.h"


#define kPostTextViewWidth           230.0      // Width of the post view text (also needs to be adjusted in ADNPostCell.xib)
#define kMaxUsernameWidth            130.0

@class ADNStream;

@interface RootViewController : UITableViewController <ADNStreamDelegate>
{
    // UI elements
    UIRefreshControl *streamRefreshControl;
    
    UIImage *adnPlaceholderImage;
    
    UIFont *profileNameFont;
    UIFont *profileUsernameFont;
    UIFont *postTextFont;
    
    // Data elements
    ADNStream *globalStream;
}

@property (nonatomic, retain) UIRefreshControl *streamRefreshControl;

@property (nonatomic, retain) UIImage *adnPlaceholderImage;

@property (nonatomic, retain) UIFont *profileNameFont;
@property (nonatomic, retain) UIFont *profileUsernameFont;
@property (nonatomic, retain) UIFont *postTextFont;

@property (nonatomic, retain) ADNStream *globalStream;

-(void)refreshView:(UIRefreshControl *)refresh;

- (void)streamRefreshedWithError:(NSError *)error;

@end
