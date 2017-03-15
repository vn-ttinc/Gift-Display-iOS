//
//  MainViewController.m
//  Gift-Display-iOS
//
//  Created by Ngo Than Phong on 3/10/17.
//  Copyright © 2017 kthangtd. All rights reserved.
//

#import "MainViewController.h"
#import "GiftDisplayArea.h"
#import "GiftEvent.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet GiftDisplayArea * giftDisplayArea;

@end

@implementation MainViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark ---- < Button Action >

- (IBAction)buttonClicked:(UIButton *)sender {
    NSString * text = sender.titleLabel.text;
    NSArray * arr = [text componentsSeparatedByString:@"-"];
    GiftEvent * event = [[GiftEvent alloc] init];
    event.senderName = [arr objectAtIndex:0];
    event.senderId = [event.senderName isEqualToString:@"A"] ? 1 : 2;
    event.giftId = [[arr objectAtIndex:1] integerValue];
    event.giftCount = [[arr objectAtIndex:2] integerValue];
    
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self.giftDisplayArea pushGiftEvent:event];
    //});
}

@end
