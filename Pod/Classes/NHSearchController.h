//
//  NHSearchViewController.h
//  Pods
//
//  Created by Sergey Minakov on 12.08.15.
//
//

@import UIKit;

extern const CGFloat kNHSearchTextFieldMinLeftInset;
extern const UIEdgeInsets kNHSearchTextFieldInsets;
extern const CGFloat kNHSearchButtonWidth;

@class NHSearchController;

@interface NHSearchTextField : UITextField
@property (nonatomic, assign) UIEdgeInsets textInset;
@end

@interface NHSearchBar : UIView

@property (nonatomic, readonly, strong) NHSearchTextField *textField;
@property (nonatomic, readonly, strong) UIImageView *imageView;
@property (nonatomic, readonly, strong) UIButton *button;
@property (nonatomic, readonly, strong) UIView *separator;

@end

@interface NHSearchResultView : UIView

@property (nonatomic, readonly, strong) UITableView *tableView;

@end

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

@property (nonatomic, assign) BOOL shouldOffsetStatusBar;

- (instancetype)initWithContainerViewController:(UIViewController*)container;

@end
