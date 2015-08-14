//
//  NHSearchViewController.h
//  Pods
//
//  Created by Sergey Minakov on 12.08.15.
//
//

@import UIKit;
#import "NHSearchTextField.h"
#import "NHSearchBar.h"
#import "NHSearchResultView.h"

@class NHSearchController;

@protocol NHSearchControllerDelegate <NSObject>

@optional
- (void)nhSearchController:(NHSearchController*)controller didChangeText:(NSString*)text;
- (void)nhSearchControllerDidBegin:(NHSearchController*)controller;
- (void)nhSearchControllerDidEnd:(NHSearchController*)controller;

@end

@interface NHSearchController : NSObject

@property (nonatomic, weak) id<NHSearchControllerDelegate> nhDelegate;

@property (nonatomic, readonly, strong) NHSearchBar *searchBar;

@property (nonatomic, readonly, strong) NHSearchResultView *searchResultView;

@property (nonatomic, readonly, assign) BOOL searchEnabled;

@property (nonatomic, assign) BOOL shouldOffsetStatusBar;

- (instancetype)initWithContainerViewController:(UIViewController*)container;

@end
