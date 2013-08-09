//
//  ADNPost.m
//  ADNChallenge
//
//  Created by Joefrey Kibuule on 8/8/13.
//  Copyright (c) 2013 Joefrey Kibuule. All rights reserved.
//

#import "ADNPost.h"

@implementation ADNPost

@synthesize profileName;
@synthesize profileUsername;
@synthesize profileImageURL;
@synthesize postText;

@synthesize profileImage;

@synthesize postJSONDict;

// Initialize the class
- (id) init
{
    if (self = [super init])
    {
        // Initialize objects
        profileName = @"";
        profileUsername = @"";
        profileImageURL = @"";
        postText = @"";
        
        profileImage = [[UIImage alloc] init];
        
        postJSONDict = [[NSDictionary alloc] init];
    }
    return self;
}

- (void) processJSON
{
    NSDictionary *userDict = [postJSONDict objectForKey:@"user"];
    
    profileName = [userDict objectForKey:@"name"];
}

// Dealloc function - not needed, yay ARC!

@end
