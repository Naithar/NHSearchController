//
//  NHViewController.m
//  NHSearchViewController
//
//  Created by Naithar on 08/11/2015.
//  Copyright (c) 2015 Naithar. All rights reserved.
//

#import "NHViewController.h"
@import NHSearchController;

@interface NHViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NHSearchController *nhSearchController;
@end

@implementation NHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.nhSearchController = [[NHSearchController alloc] initWithContainerViewController:self.navigationController];
    
    self.tableView.tableHeaderView = self.nhSearchController.searchBar;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
