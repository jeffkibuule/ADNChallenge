//
//  ADNPost.m
//  ADNChallenge
//
//  Created by Joefrey Kibuule on 8/8/13.
//  Copyright (c) 2013 Joefrey Kibuule. All rights reserved.
//

#import "ADNPost.h"

@implementation ADNPost

// Initialize the class
- (id) init
{
    if (self = [super init])
    {
        // Initialize objects
        self->_profileName = @"";
        self->_profileUsername = @"";
        self->_profileImageURL = @"";
        self->_postID = @"";
        self->_postTimestampString = @"";
        self->_postText = @"";
        
        self->_postJSONDict = nil;
    }
    return self;
}

// Processes JSON into our data class
- (void) processJSON
{
    // Grab data about the user
    NSDictionary *userDict = self.postJSONDict[@"user"];
    
    self.profileName = [NSString stringWithFormat:@"%@",userDict[@"name"]];
    self.profileUsername = [NSString stringWithFormat:@"@%@",userDict[@"username"]]; // Almost always the username will be used with the @ symbol in front
    self.profileImageURL = userDict[@"avatar_image"][@"url"];
    
    // Grab data about the post
    self.postID = self.postJSONDict[@"id"];
    self.postText = [NSString stringWithFormat:@"%@",self.postJSONDict[@"text"]];
    
    // Get the timestamp into a date object
    self.postTimestampString = self.postJSONDict[@"created_at"];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    self.postTimestampDate = [formatter dateFromString:self.postTimestampString];
}

// Dealloc function - not needed, yay ARC!

@end
