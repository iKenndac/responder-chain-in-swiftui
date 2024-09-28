// This source code is licensed under the MIT license. See LICENSE.md for details.

#import "CBLMenuActionForwarder.h"

@interface CBLMenuActionForwarder ()
@property (nonatomic, readwrite, weak) id <CBLMenuActionForwarderTarget> actionTarget;
@end

@implementation CBLMenuActionForwarder

-(instancetype)initFowardingActionsTo:(id <CBLMenuActionForwarderTarget>)target {
    self = [super init];
    self.actionTarget = target;
    return self;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return [self.actionTarget canPerformActionWithSelector:action];
}

// Since the SwiftUI host view controller forwards menu actions here, we also need to handle command validation.
-(void)validateCommand:(UICommand *)command {
    if ([self canPerformAction:command.action withSender:command]) {
        [self.actionTarget performValidationForCommand:command];
    }
}

-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [[self class] instanceMethodSignatureForSelector:@selector(handleAction:)];
}

-(void)forwardInvocation:(NSInvocation *)anInvocation {
    anInvocation.selector = @selector(handleAction:);
    [anInvocation invokeWithTarget:self];
}

-(void)handleAction:(UICommand *)command {
    [self.actionTarget performActionForCommand:command];
}

@end
