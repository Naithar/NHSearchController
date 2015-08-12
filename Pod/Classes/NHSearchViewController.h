//
//  NHSearchViewController.h
//  Pods
//
//  Created by Sergey Minakov on 12.08.15.
//
//

@import UIKit;

@interface NHSearchTextField : UITextField

@property (nonatomic, assign) UIEdgeInsets textInset;

@end

@interface NHSearchViewController : NSObject

@property (nonatomic, readonly, strong) UIView *searchBar;
@property (nonatomic, readonly, strong) NHSearchTextField *searchTextField;
@property (nonatomic, readonly, strong) UIButton *closeButton;

@property (nonatomic, readonly, strong) UIView *searchResultContainer;
@property (nonatomic, readonly, strong) UITableView *searchTableView;

@property (nonatomic, assign) BOOL shouldOffsetStatusBar;

- (instancetype)initWithContainerViewController:(UIViewController*)container;

@end
