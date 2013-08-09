//
//  ADNViewController.m
//  ADNChallenge
//
//  Created by Joefrey Kibuule on 8/8/13.
//  Copyright (c) 2013 Joefrey Kibuule. All rights reserved.
//

#import "ADNViewController.h"
#import "ADNStream.h"

@interface ADNViewController ()

@end 

@implementation ADNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    ADNStream *adnStream = [[ADNStream alloc] init];
    [adnStream setAPIPoint:@"https://alpha-api.app.net/stream/0/posts/stream/global"];
    [adnStream refreshStream];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
