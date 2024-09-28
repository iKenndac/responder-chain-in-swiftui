// This source code is licensed under the MIT license. See LICENSE.md for details.

@import Foundation;
@import UIKit;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(MenuActionForwarderTarget)
@protocol CBLMenuActionForwarderTarget <NSObject>
-(BOOL)canPerformActionWithSelector:(SEL)selector NS_SWIFT_UI_ACTOR NS_SWIFT_NAME(canPerformAction(with:));
-(void)performValidationForCommand:(UICommand *)command NS_SWIFT_UI_ACTOR NS_SWIFT_NAME(performValidation(for:));
-(void)performActionForCommand:(UICommand *)command NS_SWIFT_UI_ACTOR NS_SWIFT_NAME(performAction(for:));
@end

/// This class performs dynamic method forwarding from responder chain actions to the given target.
/// It's written in Objective-C because Swift doesn't allow us to use NSInvocation.
NS_SWIFT_NAME(MenuActionForwarder)
@interface CBLMenuActionForwarder : UIResponder

-(instancetype)initFowardingActionsTo:(id <CBLMenuActionForwarderTarget>)target;

@end

NS_ASSUME_NONNULL_END
