//
//  ADNStream.h
//  ADNChallenge
//
//  Created by Joefrey Kibuule on 8/8/13.
//  Copyright (c) 2013 Joefrey Kibuule. All rights reserved.
//

#import <Foundation/Foundation.h>

/* Class: ADNStream
 Purpose: Stores all data about a specific ADNStream through an array of posts
 Methods: 
    1) refreshStream
 Unit tests:   */

@interface ADNStream : NSObject {
    //
    NSString *streamName;
    NSMutableArray *streamPostsArray;
    
    NSString *streamAPIPointURL;
}

@property (nonatomic, retain) NSString *streamName;
@property (nonatomic, retain) NSMutableArray *streamPostsArray;

@property (nonatomic, retain) NSString *streamAPIPointURL;


// Methods
- (void) setAPIPoint: (NSString *) APIPoint;
- (void) refreshStream;
- (void)fetchedData: (NSData *)responseData;

// Unit tests

@end
