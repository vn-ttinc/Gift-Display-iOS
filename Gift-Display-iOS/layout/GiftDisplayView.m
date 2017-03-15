//
//  GiftDisplayView.m
//  Gift-Display-iOS
//
//  Created by Ngo Than Phong on 3/10/17.
//  Copyright © 2017 kthangtd. All rights reserved.
//

#import "GiftDisplayView.h"

@interface GiftDisplayView ()

@property (weak, nonatomic) IBOutlet UILabel * titleTextView;

@property (weak, nonatomic) IBOutlet UILabel * comboTextView;

@property (nonatomic, strong) NSTimer * timer;

@end

@implementation GiftDisplayView

#pragma mark ---- < Public Method >

+(instancetype)from:(GiftEvent *)event
{
    GiftDisplayView *v = [[GiftDisplayView alloc] init];
    v.initialGiftEvent = event;
    return v;
}

- (void)setCurrentCombo:(NSInteger)currentCombo {
    _currentCombo = currentCombo;
    if (self.comboTextView != nil) {
        self.comboTextView.text = [NSString stringWithFormat:@"x%d", (int)currentCombo];
    }
}

- (void)prepareForReuse {
    self.currentCombo = 0;
    self.finalCombo = 0;
}

- (void)prepare {
    if (self.titleTextView != nil && self.initialGiftEvent != nil) {
        self.titleTextView.text = [NSString stringWithFormat:@"  %@: send a gift (%d)  ",
                                   self.initialGiftEvent.senderName,
                                   (int)self.initialGiftEvent.giftId];
    }
    if (self.comboTextView != nil) {
        self.comboTextView.text = [NSString stringWithFormat:@"x%d", (int)self.currentCombo];
    }
}

-(BOOL)isEqual:(id)object
{
    if (self.initialGiftEvent == nil || object == nil || ![object isKindOfClass:[GiftDisplayView class]]) {
        return NO;
    }
    return [self.initialGiftEvent isEqual:((GiftDisplayView *)object).initialGiftEvent];
}

- (void)startAnimateCombo {
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.3
                                                      target:self
                                                    selector:@selector(tick)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}

- (void)tick{
    if (self.currentCombo >= self.finalCombo) {
        [self stopAnimationCombo];
        if (self.needsDismiss != nil) {
            [self.needsDismiss run];
        }
        return;
    }
    
    self.currentCombo += 1;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.comboTextView.scale = 1.5;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.comboTextView.scale = 1;
        }];
    }];
    
}

- (void)stopAnimationCombo {
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end

#pragma mark ---- < UIView Extension >

@implementation UIView (Extension)

- (void)setScale:(CGFloat)scale {
    if (scale) {
        self.transform = CGAffineTransformMakeScale(scale, scale);
    }
}

- (CGFloat)scale {
    return 1;
}

- (void)setTx:(CGFloat)tx {
    CGAffineTransform CGAF = self.transform;
    CGAF.tx = tx;
    self.transform = CGAF;
}

- (CGFloat)tx {
    return self.transform.tx;
}

- (void)setTy:(CGFloat)ty {
    CGAffineTransform CGAF = self.transform;
    CGAF.ty = ty;
    self.transform = CGAF;
}

- (CGFloat)ty {
    return self.transform.ty;
}

- (void)setY:(CGFloat)y {
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

@end

#pragma mark ---- < Runnable >

@implementation Runnable

- (instancetype) initRun:(functionRun)run {
    self = [super init];
    _run = run;
    return self;
}

- (void) run {
    if (_run != NULL) {
        _run();
    }
}

@end

