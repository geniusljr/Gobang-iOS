//
//  ljrSingleBoardViewController.m
//  gobang3
//
//  Created by Bell on 21/6/13.
//  Copyright (c) 2013 Bell. All rights reserved.
//

#import "ljrSingleBoardViewController.h"

@implementation ljrSingleBoardViewController

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
    valueCalculator = [[ljrValueCalculator alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:[ljrBoardManager blackPiecePath] ofType:nil inDirectory:@""];
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
        if (winner == [ljrBoardManager blackNum]) {
            UIAlertView *winnerAlert = [[UIAlertView alloc] initWithTitle:@"You Win!" message:@"" delegate:self cancelButtonTitle:@"Replay" otherButtonTitles:@"MainMenu", nil];
            [winnerAlert show];
        }
        
        UIImageView *aiImageView = [self aIPlacePieceWithNewPoint:[ljrBoardManager imageViewPointToArrayPoint:piecePoint]];
        [self.view addSubview:aiImageView];
        winner = [boardManager insertPoint:aiImageView];
        if (winner == [ljrBoardManager whiteNum]) {
            UIAlertView *winnerAlert = [[UIAlertView alloc] initWithTitle:@"You Lose!" message:@"" delegate:self cancelButtonTitle:@"Replay" otherButtonTitles:@"MainMenu", nil];
            [winnerAlert show];        }
    }
}

- (UIImageView *)aIPlacePieceWithNewPoint:(CGPoint)point
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:[ljrBoardManager whitePiecePath] ofType:nil inDirectory:@""];
    UIImage *pieceImage = [[UIImage alloc]initWithContentsOfFile:imagePath];
    UIImageView *pieceImageView = [[UIImageView alloc] initWithImage:pieceImage];
    int pieceSize = [ljrBoardManager pieceSize];
    CGPoint bestPoint = [valueCalculator getBestPointWithNewPoint:point withColor:[ljrBoardManager blackNum]];
    pieceImageView.frame = CGRectMake((bestPoint.x+2)*20-9, (bestPoint.y+4)*20-9, pieceSize, pieceSize);
    return pieceImageView;
}

- (IBAction)undo:(id)sender
{
    UIImageView *pieceImageView = [boardManager removeLastPiece];
    if (pieceImageView == nil)
        return;
    [pieceImageView removeFromSuperview];
    int x = pieceImageView.frame.origin.x;
    int y = pieceImageView.frame.origin.y;
    [valueCalculator removePoint:[ljrBoardManager imageViewPointToArrayPoint:CGPointMake(x, y)]];
    
    pieceImageView = [boardManager removeLastPiece];
    [pieceImageView removeFromSuperview];
    x = pieceImageView.frame.origin.x;
    y = pieceImageView.frame.origin.y;
    [valueCalculator removePoint:[ljrBoardManager imageViewPointToArrayPoint:CGPointMake(x, y)]];
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        while (true) {
            UIImageView *pieceImageView = [boardManager removeLastPiece];
            if (pieceImageView == nil)
                break;
            [pieceImageView removeFromSuperview];
            int x = pieceImageView.frame.origin.x;
            int y = pieceImageView.frame.origin.y;
            [valueCalculator removePoint:[ljrBoardManager imageViewPointToArrayPoint:CGPointMake(x, y)]];
        }
        [boardManager initialize];
    }
    else if (buttonIndex == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
