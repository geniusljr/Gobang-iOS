//
//  ljrSingleBoardViewController.h
//  gobang3
//
//  Created by Bell on 21/6/13.
//  Copyright (c) 2013 Bell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ljrBoardManager.h"
#import "ljrValueCalculator.h"

@interface ljrSingleBoardViewController : UIViewController
{
    ljrBoardManager *boardManager;
    ljrValueCalculator *valueCalculator;
}
@property ljrBoardManager *boardManager;
@property (weak, nonatomic) IBOutlet UILabel *timer;
- (IBAction)undo:(id)sender;

@end
