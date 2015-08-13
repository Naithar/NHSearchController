//
//  NHSearchViewController.h
//  Pods
//
//  Created by Sergey Minakov on 12.08.15.
//
//

@import UIKit;

@class NHSearchController;

@interface NHSearchTextField : UITextField

@property (nonatomic, assign) UIEdgeInsets textInset;

@end

@protocol NHSearchControllerDelegate <NSObject>

@optional
- (void)nhSearchController:(NHSearchController*)controller didChangeText:(NSString*)text;
- (void)nhSearchControllerDidBegin:(NHSearchController*)controller;
- (void)nhSearchControllerDidEnd:(NHSearchController*)controller;

@end

@interface NHSearchController : NSObject

@property (nonatomic, weak) id<NHSearchControllerDelegate> nhDelegate;

@property (nonatomic, readonly, strong) UIView *searchBar;
@property (nonatomic, readonly, strong) NHSearchTextField *searchTextField;
@property (nonatomic, readonly, strong) UIImageView *searchLeftImageView;
@property (nonatomic, readonly, strong) UIButton *closeButton;

@property (nonatomic, readonly, strong) UIView *searchResultContainer;
@property (nonatomic, readonly, strong) UITableView *searchTableView;

@property (nonatomic, assign) BOOL shouldOffsetStatusBar;

- (instancetype)initWithContainerViewController:(UIViewController*)container;

@end
