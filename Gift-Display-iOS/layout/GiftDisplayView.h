//
//  GiftDisplayView.h
//  Gift-Display-iOS
//
//  Created by Ngo Than Phong on 3/10/17.
//  Copyright © 2017 kthangtd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftEvent.h"

#pragma mark ---- < Runnable >

typedef void (^functionRun)(void);

@interface Runnable : NSObject {
    functionRun _run;
}

- (instancetype) initRun:(functionRun)run;

- (void) run;

@end

#pragma mark ---- < UIView Extension >

@interface UIView (Extension)

@property (nonatomic, assign) CGFloat scale;

@property (nonatomic, assign) CGFloat ty;

@property (nonatomic, assign) CGFloat tx;

@property (nonatomic, assign) CGFloat y;

@end

#pragma mark ---- < Gift Display View >

@interface GiftDisplayView : UIView

@property (nonatomic, assign) NSInteger finalCombo;

@property (nonatomic, assign) NSInteger currentCombo;

@property (nonatomic, strong) GiftEvent * initialGiftEvent;

@property (nonatomic, strong) Runnable * needsDismiss;

+(instancetype)from:(GiftEvent *)event;

- (void)prepareForReuse;

- (void)prepare;

- (void)startAnimateCombo;

@end
