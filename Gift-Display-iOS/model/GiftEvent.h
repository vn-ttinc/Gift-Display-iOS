//
//  GiftEvent.h
//  Gift-Display-iOS
//
//  Created by Ngo Than Phong on 3/10/17.
//  Copyright © 2017 kthangtd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GiftEvent : NSObject

@property (nonatomic, assign) NSInteger senderId;

@property (nonatomic, assign) NSInteger giftId;

@property (nonatomic, assign) NSInteger giftCount;

@property (nonatomic, strong) NSString * senderName;

@end
