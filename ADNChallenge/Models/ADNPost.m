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

@synthesize postID;
@synthesize postTimestampString;
@synthesize postTimestampDate;
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
        postID = @"";
        postTimestampString = @"";
        postText = @"";
        
        postJSONDict = [[NSDictionary alloc] init];
    }
    return self;
}

// Processes JSON into our data class
- (void) processJSON
{
    // Grab data about the user
    NSDictionary *userDict = [postJSONDict objectForKey:@"user"];
    
    self.profileName = [userDict objectForKey:@"name"];
    self.profileUsername = [NSString stringWithFormat:@"@%@",[userDict objectForKey:@"username"]]; // Almost always the username will be used with the @ symbol in front
    self.profileImageURL = [[userDict objectForKey:@"avatar_image"] objectForKey:@"url"];
    
    // Grab data about the post
    self.postID = [postJSONDict objectForKey:@"id"];
    self.postText = [postJSONDict objectForKey:@"text"];
    
    // Get the timestamp into a date object
    self.postTimestampString = [postJSONDict objectForKey:@"created_at"];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    self.postTimestampDate = [formatter dateFromString:self.postTimestampString];
}

// Dealloc function - not needed, yay ARC!

@end
