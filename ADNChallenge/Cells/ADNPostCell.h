//
//  ADNPostCell.h
//  ADNChallenge
//
//  Created by Joefrey Kibuule on 8/8/13.
//  Copyright (c) 2013 Joefrey Kibuule. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADNPostCell : UITableViewCell
{
    IBOutlet UIImageView *profileImage;
    IBOutlet UILabel *profileName;
    IBOutlet UILabel *profileUsername;
    IBOutlet UILabel *postText;
}

@property (nonatomic, retain) UIImageView *profileImage;
@property (nonatomic, retain) UILabel *profileName;
@property (nonatomic, retain) UILabel *profileUsername;
@property (nonatomic, retain) UILabel *postText;

@end
