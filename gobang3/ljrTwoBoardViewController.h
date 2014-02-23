//
//  ljrBoardViewController.h
//  gobang3
//
//  Created by Bell on 20/6/13.
//  Copyright (c) 2013 Bell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ljrBoardManager.h"

@interface ljrTwoBoardViewController : UIViewController
{
    ljrBoardManager *boardManager;
}
@property ljrBoardManager *boardManager;

- (IBAction)undo:(id)sender;

@end
