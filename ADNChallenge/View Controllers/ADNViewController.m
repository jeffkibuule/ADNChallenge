//
//  ADNViewController.m
//  ADNChallenge
//
//  Created by Joefrey Kibuule on 8/8/13.
//  Copyright (c) 2013 Joefrey Kibuule. All rights reserved.
//

#import "ADNViewController.h"

#import "ADNStream.h"
#import "ADNPost.h"
#import "ADNPostCell.h"

@interface ADNViewController ()

@end 

@implementation ADNViewController

@synthesize streamTableView;
@synthesize refreshControl;

@synthesize globalStream;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Setup the refresh control
    refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl = refreshControl;
    
    // Setup the data object
    globalStream = [[ADNStream alloc] init];
    globalStream.streamName = @"App.net Global";
    globalStream.streamDelegate = self;
    [globalStream setAPIPoint:@"https://alpha-api.app.net/stream/0/posts/stream/global"];
    [globalStream refreshStream];
    
    // Set the title
    self.title = globalStream.streamName;
    
    // Load table data for the first time
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Custom Methods
- (void)streamRefreshedWithError:(NSError *)error
{
    if (error == nil)
        [self.streamTableView reloadData];
    else
        NSLog(@"Error loading data: %@", [error description]);
}

#pragma mark -
#pragma mark Table Data Source Methods
// This function gets called to find out how many sections are in the table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1; // Only 1 section
}

// This function gets called to find out the number of rows for a particular section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"num posts: %d", [globalStream numPosts]);
	return [globalStream numPosts]; // return current number of posts
}


#pragma mark -
#pragma mark Table View Delegate Methods
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ADNPostCellIdentifier = @"ADNPostCellIdentifier";
	
	// Get the section and row
	NSUInteger section = [indexPath section];
	NSUInteger row = [indexPath row];
    
    ADNPost *adnPost = [globalStream getPostAtIndex: row];
    // Get the cell XIB
    ADNPostCell *cell = (ADNPostCell *)[tableView dequeueReusableCellWithIdentifier:ADNPostCellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ADNPostCell"  owner:self options:nil];
        cell = (ADNPostCell *)[nib objectAtIndex:0];
        [adnPost loadProfileImageFromWeb];
        [cell.profileImage setImage:adnPost.profileImage];
        cell.profileName.text = adnPost.profileName;
        cell.postText.text = adnPost.postText;
    }
    return cell;
}


@end
