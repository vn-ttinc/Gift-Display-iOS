//
//  GiftEvent.m
//  Gift-Display-iOS
//
//  Created by Ngo Than Phong on 3/10/17.
//  Copyright © 2017 kthangtd. All rights reserved.
//

#import "GiftEvent.h"

@implementation GiftEvent

- (BOOL)isEqual:(id)object {
    if (object == nil) {
        return NO;
    }
    return self.senderId == ((GiftEvent *)object).senderId && self.giftId == ((GiftEvent *)object).giftId;
}

@end
