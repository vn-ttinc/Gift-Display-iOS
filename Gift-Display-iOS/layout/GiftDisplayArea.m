//
//  GiftDisplayArea.m
//  Gift-Display-iOS
//
//  Created by Ngo Than Phong on 3/10/17.
//  Copyright © 2017 kthangtd. All rights reserved.
//

#import "GiftDisplayArea.h"
#import "GiftDisplayView.h"

#define ITEM_HEIGHT 70.0f
#define ANIMATION_DURATION 0.5f
#define SPRING_DAMPING 0.8f
#define MIN_TX -200.0f
#define MIN_TY -20.0f

@interface GiftDisplayArea ()

@property (nonatomic, strong) NSMutableArray * eventQueue;

@property (nonatomic, strong) NSMutableArray * availablePositions;

@property (nonatomic, strong) NSMutableArray * reusableViews;

@property (nonatomic, strong) NSMutableArray * currentViews;

@end

@implementation GiftDisplayArea

#pragma mark ---- < Init >

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

#pragma mark ---- < Setup >

- (void)setup {
    self.eventQueue = [NSMutableArray array];
    self.currentViews = [NSMutableArray array];
    self.reusableViews = [NSMutableArray array];
    self.availablePositions = [NSMutableArray arrayWithObjects: [NSNumber numberWithInteger:3],
                                                                [NSNumber numberWithInteger:2],
                                                                [NSNumber numberWithInteger:1],
                                                                nil];
}

#pragma mark ---- < Public Method >

- (void)pushGiftEvent:(GiftEvent *)event {
    NSInteger idx = [self.eventQueue indexOfObject:event];
    if (idx == NSNotFound) {
        [self.eventQueue insertObject:event atIndex:0];
    } else {
        GiftEvent *giftEvent = [self.eventQueue objectAtIndex:idx];
        giftEvent.giftCount += event.giftCount;
    }
    
    [self handleNextEvent];
}

#pragma mark ---- < Private Method >

- (void)dismissView:(GiftDisplayView *)view {
    [UIView animateWithDuration:ANIMATION_DURATION
                          delay:0
         usingSpringWithDamping:SPRING_DAMPING
          initialSpringVelocity:0
                        options:0
                     animations:^{
        view.ty = MIN_TY;
        view.alpha = 0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        view.ty = 0;
        view.alpha = 1;
        [self.currentViews removeObject:view];
        [self.availablePositions addObject:[NSNumber numberWithInteger:view.tag]];
        
        NSArray * sorted_Array = [self.availablePositions sortedArrayUsingDescriptors:
                                @[[NSSortDescriptor sortDescriptorWithKey:@"intValue"
                                                                ascending:NO]]];
        self.availablePositions = [NSMutableArray arrayWithArray:sorted_Array];
        
        [view prepareForReuse];
        [self enqueueResuableView:view];
        [self handleNextEvent];
    }];
}

- (GiftDisplayView *)dequeueResuableView {
    GiftDisplayView * view;
    if (self.reusableViews.count == 0) {
        view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GiftDisplayView class])
                                             owner:self
                                           options:nil].firstObject;
    } else {
        view = [self.reusableViews lastObject];
        [self.reusableViews removeLastObject];
        [view prepareForReuse];
    }
    
    [view setNeedsDismiss:[[Runnable alloc] initRun:^{
        [self dismissView:view];
    }]];
    return view;
}

- (void)enqueueResuableView:(GiftDisplayView *)view {
    [self.reusableViews insertObject:view atIndex:0];
}

- (void)handleNextEvent {
    if (self.eventQueue.count == 0) {
        return;
    }
    
    GiftEvent * event = [self.eventQueue objectAtIndex:0];
    NSInteger idx = [self.currentViews indexOfObject:[GiftDisplayView from:event]];
    if (idx != NSNotFound) {
        [self.eventQueue removeObjectAtIndex:0];
        GiftDisplayView *GDView = [self.currentViews objectAtIndex:idx];
        GDView.finalCombo += event.giftCount;
        return;
    }
    
    if (self.availablePositions.count == 0) {
        return;
    }
    
    [self.eventQueue removeObjectAtIndex:0];
    
    NSNumber * position = self.availablePositions.lastObject;
    [self.availablePositions removeLastObject];
    
    GiftDisplayView * view = [self dequeueResuableView];
    [self.currentViews insertObject:view atIndex:0];
    view.initialGiftEvent = event;
    view.currentCombo = 1;
    view.finalCombo = event.giftCount;
    [view setY:self.frame.size.height - position.floatValue*ITEM_HEIGHT];
    view.tag = position.integerValue;
    view.tx = MIN_TX;
    [view prepare];
    [self addSubview:view];
    
    [UIView animateWithDuration:ANIMATION_DURATION
                          delay:0
         usingSpringWithDamping:SPRING_DAMPING
          initialSpringVelocity:0
                        options:0
                     animations:^{
        view.tx = 0;
    } completion:^(BOOL finished) {
        [view startAnimateCombo];
        [self handleNextEvent];
    }];
}

@end
