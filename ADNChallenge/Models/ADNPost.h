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

@interface ADNPost : NSObject {
    // User post data
    NSString *profileName;              // ex. Bill Gates
    NSString *profileUsername;          // ex. billgates
    NSString *profileImageURL;
    NSString *postText;
    
    UIImage* profileImage;
    
    // Dictionary representation JSON data
    NSDictionary *postJSONDict;
}

@property (nonatomic, retain) NSString *profileName;
@property (nonatomic, retain) NSString *profileUsername;
@property (nonatomic, retain) NSString *profileImageURL;
@property (nonatomic, retain) NSString *postText;

@property (nonatomic, retain) UIImage *profileImage;

@property (nonatomic, retain) NSDictionary *postJSONDict;

// Methods - none (class only stores data)
- (void) processJSON;

// Unit tests - none (class only stores data)

@end
