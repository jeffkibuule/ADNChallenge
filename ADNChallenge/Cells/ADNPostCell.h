//
//  ADNPostCell.h
//  ADNChallenge
//
//  Created by Joefrey Kibuule on 8/8/13.
//  Copyright (c) 2013 Joefrey Kibuule. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADNPostCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *profileImage;
@property (nonatomic, weak) IBOutlet UILabel *profileName;
@property (nonatomic, weak) IBOutlet UILabel *profileUsername;
@property (nonatomic, weak) IBOutlet UILabel *postText;
@property (nonatomic, weak) IBOutlet UILabel *postTimestamp;

@property (nonatomic, strong) NSURLSessionTask *task;

@end
