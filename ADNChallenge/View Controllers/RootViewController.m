//
//  RootViewController.m
//  ADNChallenge
//
//  Created by Joefrey Kibuule on 8/8/13.
//  Copyright (c) 2013 Joefrey Kibuule. All rights reserved.
//

#import "RootViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "Reachability.h"

#import "ADNStream.h"
#import "ADNPost.h"
#import "ADNPostCell.h"

@implementation RootViewController

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
    
    // Setup the refresh control
    self.streamRefreshControl = [[UIRefreshControl alloc] init];
    [self.streamRefreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = self.streamRefreshControl;
    
    // Setup the data object
    self.globalStream = [[ADNStream alloc] init];
    self.globalStream.streamName = @"App.net Global Stream";
    self.globalStream.streamDelegate = self;
    [self.globalStream setAPIPoint:@"https://alpha-api.app.net/stream/0/posts/stream/global"];
    
    // Cache the system fonts used when evlanuating the appropriate width and height of UILabel objects
    self.profileNameFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0];            // Bill Gates
    self.profileUsernameFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0];       // @billgates
    self.postTextFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];              // I am Bill Gates
    
    // Set the title
    self.title = self.globalStream.streamName;
    
    // Set up the date format
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"h:mm:ss a"];
    [self.dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    // Load the ADN profile placeholder image
    self.adnPlaceholderImage = [UIImage imageNamed:@"ADNPlaceholderImage.png"];
    
    // Create the image session configuration to use a custom cache
    NSURLSessionConfiguration *imageSessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    imageSessionConfig.URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:@"Images"];
    self.imageSession = [NSURLSession sessionWithConfiguration:imageSessionConfig];
    
    // Google should ALWAYS be reachable otherwise something has gone awry
    self.reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Set up 2 GCD blocks for responding to network reachability, this way should be iOS 7 proof when the user can change connectivity via Control Center
    __weak RootViewController* weakSelf = self;
    self.reach.reachableBlock = ^(Reachability * reachability)
    {
        RootViewController *strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.networkReachable = true;
            
            // Network reachable, reload more data
            [strongSelf.streamRefreshControl beginRefreshing];
            [strongSelf refreshView:strongSelf.streamRefreshControl];
        });
    };
    
    self.reach.unreachableBlock = ^(Reachability * reachability)
    {
        RootViewController *strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.networkReachable = false;
        });
    };
    
    // Start up notifications
    [self.reach startNotifier];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.reach stopNotifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self.globalStream didReceiveMemoryWarning];
    
    // Reload the tableview to grab images again
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Custom Methods
- (void)streamRefreshed
{
    // Update the title and reload tablet data on main thread
    __weak RootViewController* weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        // Update the title and reload tablet data on main thread
        RootViewController *strongSelf = weakSelf;
        
        // No longer refreshing
        [strongSelf.streamRefreshControl endRefreshing];
        
        // Change the title so we know how many posts we have in the stream
        strongSelf.title = [NSString stringWithFormat:@"%@ (%lu)", strongSelf.globalStream.streamName, (unsigned long)[strongSelf.globalStream numPosts]];
        
        [strongSelf.tableView reloadData];
    });
}

#pragma mark -
#pragma mark Refresh Control Methods
-(void)refreshView:(UIRefreshControl *)refresh {
    
    // See if the network is reachable
    if (self.networkReachable)
    {
        self.streamRefreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
        
        // custom refresh logic would be placed here...
        [self.globalStream refreshStream];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm:ss a"];
        NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
        self.streamRefreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    }
    else
    {
        // No data connection present
        self.streamRefreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"No data connection"];
        
        [self.streamRefreshControl endRefreshing];
    }
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
	return [self.globalStream numPosts]; // return current number of posts
}


#pragma mark -
#pragma mark Table View Delegate Methods
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ADNPostCellIdentifier = @"ADNPostCellIdentifier";
	
	// Get the section and row
	NSUInteger row = [indexPath row];
    
    ADNPost *adnPost = [self.globalStream getPostAtIndex: row];
    
    // Get the cell XIB
    ADNPostCell *cell = (ADNPostCell *)[tableView dequeueReusableCellWithIdentifier:ADNPostCellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ADNPostCell"  owner:self options:nil];
        cell = (ADNPostCell *)[nib objectAtIndex:0];
    }
    
    // If this cell was previously redownloading an image (because download speed was slow), cancel that task
    if (cell.task)
    {
        [cell.task cancel];
        cell.task = nil;
    }
    
    // Load the profile image asychrononously to prevent blocking of the UI thread
    if (adnPost.profileImage == nil)
    {
        // Haven't downloaded this image, set a placeholder image then grab the real one off the web
        cell.profileImage.image = self.adnPlaceholderImage;
        
        
        // Create a rounded border mask on the imageview
        cell.profileImage.layer.masksToBounds = YES;
        cell.profileImage.layer.cornerRadius = kProfileImageCornerRadius;
        cell.profileImage.layer.borderWidth = 1.0;
        
        // Check and make sure there's a valid profile image url before trying to download anything
        if (adnPost.profileImageURL)
        {
            NSURL *imageURL = [NSURL URLWithString:adnPost.profileImageURL];
            
            NSURLSessionTask *task = [self.imageSession dataTaskWithURL:imageURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (data)
                {
                    // Save this image in our data store
                    adnPost.profileImage = [UIImage imageWithData:data];
                    
                    // Assign image on the main thread
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.profileImage.image = [UIImage imageWithData:data];
                    });
                }
            }];
            
            // Save the task for later in case we need to cancel it
            cell.task = task;
            
            [task resume];
        }
    }
    else
    {
        // We've already cached this image, set it again
        cell.profileImage.image = adnPost.profileImage;
    }
    
    // Fill in profile name and username
    cell.profileName.text = adnPost.profileName;
    cell.profileUsername.text = adnPost.profileUsername;
    cell.postText.text = adnPost.postText;
    cell.postTimestamp.text = [self.dateFormatter stringFromDate:adnPost.postTimestampDate];
    
    
    // Adjust the label the the new height.
    CGSize maximumLabelSize = CGSizeMake(kPostTextViewWidth,9999);
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:adnPost.postText attributes:@{NSFontAttributeName:self.postTextFont}];
    CGRect rect = [attributedString boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGSize expectedLabelSize = rect.size;
    expectedLabelSize.height = ceilf(expectedLabelSize.height);
    expectedLabelSize.width = ceilf(expectedLabelSize.width);
    
    CGRect newFrame = CGRectMake(64, 20, kPostTextViewWidth, 32);
    
    // Set the height of the label
    newFrame.size.height = expectedLabelSize.height+20;
    cell.postText.frame = newFrame;
    
    
    
    // Adjust the size of the username
    maximumLabelSize = CGSizeMake(kMaxUsernameWidth,9999);  // Prevent overrun of the profile name pushing the username off the screen
    attributedString = [[NSAttributedString alloc] initWithString:adnPost.profileName attributes:@{NSFontAttributeName:self.profileNameFont}];
    rect = [attributedString boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    expectedLabelSize = rect.size;
    expectedLabelSize.height = ceilf(expectedLabelSize.height);
    expectedLabelSize.width = ceilf(expectedLabelSize.width);
    
    cell.profileName.frame = CGRectMake (cell.profileName.frame.origin.x, cell.profileName.frame.origin.y, expectedLabelSize.width, cell.profileName.frame.size.height);
    
    
    // Adjust the size and position of the profile username based on the position of profileName
    attributedString = [[NSAttributedString alloc] initWithString:adnPost.profileUsername attributes:@{NSFontAttributeName:self.profileUsernameFont}];
    rect = [attributedString boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    expectedLabelSize = rect.size;
    expectedLabelSize.height = ceilf(expectedLabelSize.height);
    expectedLabelSize.width = ceilf(expectedLabelSize.width);
    
    cell.profileUsername.frame = CGRectMake (cell.profileName.frame.origin.x + cell.profileName.frame.size.width + 5, cell.profileUsername.frame.origin.y, expectedLabelSize.width, 15);
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// Customize the height of the table view cell based on the text size
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get the section and row
	NSUInteger row = [indexPath row];
    
    NSUInteger height;
    ADNPost *adnPost = [self.globalStream getPostAtIndex:row];
    CGSize maximumLabelSize = CGSizeMake(kPostTextViewWidth,9999);
	
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:adnPost.postText attributes:@{NSFontAttributeName:self.postTextFont}];
    CGRect rect = [attributedString boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGSize expectedLabelSize = rect.size;
    expectedLabelSize.height = ceilf(expectedLabelSize.height);
    expectedLabelSize.width = ceilf(expectedLabelSize.width);
	
    // Set the height of the label and enforce a minimum height of 72
	height = (expectedLabelSize.height+40 > 72 ? expectedLabelSize.height+40 : 72);
    
    return height;
}

@end
