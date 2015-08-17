//
//  NHSearchTextField.h
//  Pods
//
//  Created by Sergey Minakov on 13.08.15.
//
//


@import UIKit;

extern const CGFloat kNHSearchTextFieldMinLeftInset;
extern const UIEdgeInsets kNHSearchTextFieldInsets;
extern const CGFloat kNHSearchButtonWidth;

@interface NHSearchTextField : UITextField

@property (nonatomic, assign) UIEdgeInsets textInset;

- (void)resetTextInsets:(BOOL)force;

@end