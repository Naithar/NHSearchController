//
//  NHSearchResultView.h
//  Pods
//
//  Created by Sergey Minakov on 13.08.15.
//
//

@import UIKit;

@interface NHSearchResultView : UIView

@property (nonatomic, strong) UIColor *overlayColor;
@property (nonatomic, readonly, strong) UITableView *tableView;

- (void)getSnapshotForView:(UIView*)view withRect:(CGRect)rect;

@end