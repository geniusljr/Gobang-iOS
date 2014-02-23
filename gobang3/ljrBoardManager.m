//
//  ljrBoardManager.m
//  gobang3
//
//  Created by Bell on 20/6/13.
//  Copyright (c) 2013 Bell. All rights reserved.
//

#import "ljrBoardManager.h"

NSString * const blackPiece = @"black 2.png";
NSString * const whitePiece = @"white.png";
int const whiteNum = 1;
int const blackNum = 2;
int const pieceSize = 18;
int const pointInterval = 20;
int const LeftTopX = 40;
int const LeftTopY = 80;
int const RightBottomX = 280;
int const RightBottomY = 320;
int const legalDeviation = 9;
int const boardSize = 13;

@implementation ljrBoardManager

@synthesize curColorNum;

- (id)init
{
    self = [super init];
    if (self) {
        boardArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < boardSize; i++) {
            NSMutableArray *boardRow = [[NSMutableArray alloc] init];
            for (int j = 0; j < boardSize; j++)
                [boardRow addObject:[NSNumber numberWithInt:0]];
            [boardArray addObject:boardRow];
        }
        undoStack = [[NSMutableArray alloc] init];
        [self setCurColorNum:blackNum];
    }
    return self;
}

- (void)initialize
{
    for (int i = 0; i < boardSize; i++) {
        for (int j = 0; j < boardSize; j++) {
            [[boardArray objectAtIndex:i] replaceObjectAtIndex:j withObject:[NSNumber numberWithInt:0]];
        }
    }
    curColorNum = blackNum;
}

+ (NSString *)blackPiecePath
{
    return blackPiece;
}

+ (NSString *)whitePiecePath
{
    return whitePiece;
}

+ (int)pieceSize
{
    return pieceSize;
}

+ (int)boardSize
{
    return boardSize;
}

+ (int)blackNum
{
    return blackNum;
}

+ (int)whiteNum
{
    return whiteNum;
}

+ (CGPoint)getPiecePoint:(CGPoint)point
{
    CGPoint nilPoint = CGPointMake(0, 0);
    if (point.x <= LeftTopX-legalDeviation || point.y <= LeftTopY-legalDeviation
        || point.x >= RightBottomX+legalDeviation || point.y >= RightBottomY+legalDeviation)
        return nilPoint;
    
    int intPointX = (int)point.x;
    int boardx = intPointX - intPointX % pointInterval;
    if (intPointX % pointInterval >= legalDeviation) {
        if (intPointX % pointInterval <= pointInterval-legalDeviation)
            return nilPoint;
        else boardx += pointInterval;
    }
    
    int intPointY = (int)point.y;
    int boardy = intPointY - intPointY % pointInterval;
    if (intPointY % pointInterval >= legalDeviation) {
        if (intPointY % pointInterval <= pointInterval-legalDeviation)
            return nilPoint;
        else boardy += pointInterval;
    }
    
    CGPoint piecePoint = CGPointMake(boardx-pieceSize/2, boardy-pieceSize/2);
    return piecePoint;
}

- (BOOL)isPointAvailable:(CGPoint)point
{
    CGPoint arrayPoint = [ljrBoardManager imageViewPointToArrayPoint:point];
    NSNumber *pointPiece = [[boardArray objectAtIndex:(NSUInteger)arrayPoint.x] objectAtIndex:(NSUInteger)arrayPoint.y];
    return ([pointPiece intValue] == 0);
}

+ (CGPoint)imageViewPointToArrayPoint:(CGPoint)point
{
    int x = ((int)point.x + pieceSize/2)/pointInterval-2;
    int y = ((int)point.y + pieceSize/2)/pointInterval-4;
    return CGPointMake(x, y);
}

- (NSInteger)insertPoint:(UIImageView *)imageView
{
    CGPoint point = CGPointMake(imageView.frame.origin.x, imageView.frame.origin.y);
    int x = ((int)point.x + pieceSize/2)/pointInterval-2;
    int y = ((int)point.y + pieceSize/2)/pointInterval-4;
    [[boardArray objectAtIndex:(NSUInteger)x]
     replaceObjectAtIndex:(NSUInteger)y withObject:[NSNumber numberWithInt:curColorNum]];
    [undoStack addObject:imageView];
    if ([self isWinner:point]) {
        return curColorNum;
    }
    [self changeColor];
    return 0;
}

- (void)removePoint:(CGPoint)point
{
    int x = ((int)point.x + pieceSize/2)/pointInterval-2;
    int y = ((int)point.y + pieceSize/2)/pointInterval-4;
    [[boardArray objectAtIndex:(NSUInteger)x]
     replaceObjectAtIndex:(NSUInteger)y withObject:[NSNumber numberWithInt:0]];
}

- (UIImageView *)removeLastPiece
{
    if ([undoStack count] == 0)
        return nil;
    [self changeColor];
    UIImageView * imageView = [undoStack lastObject];
    [undoStack removeLastObject];
    [self removePoint:CGPointMake(imageView.frame.origin.x, imageView.frame.origin.y)];
    return imageView;
}

- (void)changeColor
{
    if ([self curColorNum] == blackNum)
        [self setCurColorNum:whiteNum];
    else
        [self setCurColorNum:blackNum];
}

- (NSString *)getPieceImagePath
{
    if (curColorNum == blackNum)
        return blackPiece;
    else return whitePiece;
}

- (BOOL)isWinner:(CGPoint)point
{
    int x = ((int)point.x + pieceSize/2)/pointInterval-2;
    int y = ((int)point.y + pieceSize/2)/pointInterval-4;
    
    //horizon
    int count = 1;
    for (int i = y-1; i >= 0; i--) {
        if ([[[boardArray objectAtIndex:x] objectAtIndex:i] intValue] == curColorNum)
            count++;
        else break;
    }
    for (int i = y+1; i < boardSize; i++) {
        if ([[[boardArray objectAtIndex:x] objectAtIndex:i] intValue] == curColorNum)
            count++;
        else break;
    }
    if (count >= 5)
        return true;
    
    
    //vertical
    count = 1;
    for (int i = x-1; i >= 0; i--) {
        if ([[[boardArray objectAtIndex:i] objectAtIndex:y] intValue] == curColorNum)
            count++;
        else break;
    }
    for (int i = x+1; i < boardSize; i++) {
        if ([[[boardArray objectAtIndex:i] objectAtIndex:y] intValue] == curColorNum)
            count++;
        else break;
    }
    if (count >= 5)
        return true;
    
    
    //left cross
    count = 1;
    for (int i = x-1, j = y-1; i >= 0 && j >= 0; i--, j--) {
        if ([[[boardArray objectAtIndex:i] objectAtIndex:j] intValue] == curColorNum)
            count++;
        else break;
    }
    for (int i = x+1, j = y+1; i < boardSize && j < boardSize; i++, j++) {
        if ([[[boardArray objectAtIndex:i] objectAtIndex:j] intValue] == curColorNum)
            count++;
        else break;
    }
    if (count >= 5)
        return true;
    
    
    //right cross
    count = 1;
    for (int i = x-1, j = y+1; i >= 0 && j < boardSize; i--, j++) {
        if ([[[boardArray objectAtIndex:i] objectAtIndex:j] intValue] == curColorNum)
            count++;
        else break;
    }
    for (int i = x+1, j = y-1; i < boardSize && j >= 0; i++, j--) {
        if ([[[boardArray objectAtIndex:i] objectAtIndex:j] intValue] == curColorNum)
            count++;
        else break;
    }
    if (count >= 5)
        return true;
    
    return false;
}




@end
