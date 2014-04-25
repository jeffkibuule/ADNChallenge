//
//  ADNPost.h
//  ADNChallenge
//
//  Created by Joefrey Kibuule on 8/8/13.
//  Copyright (c) 2013 Joefrey Kibuule. All rights reserved.
//

#import <Foundation/Foundation.h>

/* Class: ADNPost
 Purpose: Stores all data about invdividual ADNPost
 Methods: None (only stores data)
 Unit tests: None needed  */

@interface ADNPost : NSObject

@property (nonatomic, copy) NSString *postID;
@property (nonatomic, copy) NSString *profileName;            // ex. Bill Gates
@property (nonatomic, copy) NSString *profileUsername;        // ex. billgates
@property (nonatomic, copy) NSString *profileImageURL;
@property (nonatomic, copy) NSString *postText;
@property (nonatomic, copy) NSString *postTimestampString;
@property (nonatomic, strong) NSDate *postTimestampDate;

@property (nonatomic, strong) UIImage *profileImage;

// Dictionary representation JSON data
@property (nonatomic, copy) NSDictionary *postJSONDict;

// Methods
- (void) processJSON;

// Unit tests - none (class only stores data)

@end
