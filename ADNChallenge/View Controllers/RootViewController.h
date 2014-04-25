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
#define kMaxUsernameWidth            150.0      // Maximum width of the profile name so it doesn't overflow
#define kProfileImageCornerRadius    9.0       // Profile image corner radius

@class ADNStream;
@class Reachability;

@interface RootViewController : UITableViewController <ADNStreamDelegate>

@property (nonatomic, strong) UIRefreshControl *streamRefreshControl;
@property (nonatomic, strong) UIImage *adnPlaceholderImage;
@property (nonatomic, strong) UIFont *profileNameFont;
@property (nonatomic, strong) UIFont *profileUsernameFont;
@property (nonatomic, strong) UIFont *postTextFont;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSURLSession *imageSession;

@property (nonatomic, strong) ADNStream *globalStream;
@property (nonatomic, strong) Reachability *reach;
@property (nonatomic) BOOL networkReachable;


- (void)refreshView:(UIRefreshControl *)refresh;

@end
