//
//  NHViewController.m
//  NHSearchViewController
//
//  Created by Naithar on 08/11/2015.
//  Copyright (c) 2015 Naithar. All rights reserved.
//

#import "NHViewController.h"
@import NHSearchViewController;

@interface NHViewController ()

@property (nonatomic, strong) NHSearchController *nhSearchController;
@end

@implementation NHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.nhSearchController = [[NHSearchController alloc] initWithContainerViewController:self.navigationController];
    
    CGRect frame = self.nhSearchController.searchBar.frame;
    frame.origin = CGPointMake(0, 100);
    self.nhSearchController.searchBar.frame = frame;
    [self.view addSubview:self.nhSearchController.searchBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
