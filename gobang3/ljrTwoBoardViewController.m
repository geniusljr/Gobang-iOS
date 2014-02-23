//
//  ljrBoardViewController.m
//  gobang3
//
//  Created by Bell on 20/6/13.
//  Copyright (c) 2013 Bell. All rights reserved.
//

#import "ljrTwoBoardViewController.h"

@implementation ljrTwoBoardViewController

@synthesize boardManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    boardManager = [[ljrBoardManager alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:[self.boardManager getPieceImagePath] ofType:nil inDirectory:@""];
    UIImage *pieceImage = [[UIImage alloc]initWithContentsOfFile:imagePath];
    UIImageView *pieceImageView = [[UIImageView alloc] initWithImage:pieceImage];
    
    CGPoint curPoint = [[touches anyObject] locationInView:self.view];
    CGPoint piecePoint = [ljrBoardManager getPiecePoint:curPoint];
    if ((piecePoint.x == 0 && piecePoint.y == 0) || ![self.boardManager isPointAvailable:piecePoint])
        return;
    else {
        int pieceSize = [ljrBoardManager pieceSize];
        pieceImageView.frame = CGRectMake(piecePoint.x, piecePoint.y, pieceSize, pieceSize);
        [self.view addSubview:pieceImageView];
        NSInteger winner = [boardManager insertPoint:pieceImageView];
        if (winner != 0) {
            NSString *winMessage = [[NSString alloc] initWithFormat:@"Player%d rules!", winner];
            UIAlertView *winnerAlert = [[UIAlertView alloc] initWithTitle:winMessage message:@"" delegate:self cancelButtonTitle:@"Replay" otherButtonTitles:@"Main Menu", nil];
            [winnerAlert show];
        }
    }
}

- (IBAction)undo:(id)sender
{
    UIImageView *pieceImageView = [boardManager removeLastPiece];
    if (pieceImageView == nil)
        return;
    [pieceImageView removeFromSuperview];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        while (true) {
            UIImageView *pieceImageView = [boardManager removeLastPiece];
            if (pieceImageView == nil)
                break;
            [pieceImageView removeFromSuperview];
        }
        [boardManager initialize];
    }
    else if (buttonIndex == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end
