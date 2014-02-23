//
//  ljrCreditCalc.m
//  gobang3
//
//  Created by Bell on 23/6/13.
//  Copyright (c) 2013 Bell. All rights reserved.
//

#import "ljrCreditCalc.h"
#import "ljrBoardManager.h"

@implementation ljrCreditCalc

- (CGPoint)getBestPoint:(NSMutableArray *)board
{
    tempBoard = board;
    for (int i = 0; i < [ljrBoardManager boardSize]; i++)
        for (int j = 0; j < [ljrBoardManager boardSize]; j++)
             [[scoreBoard objectAtIndex:i] addObject:[NSNumber numberWithInt:0]];
    
    int maxX = 7, maxY = 7, maxCredit = 0;
    for (int i = 0; i < [ljrBoardManager boardSize]; i++)
        for (int j = 0; j < [ljrBoardManager boardSize]; j++) {
            if ([[[tempBoard objectAtIndex:i] objectAtIndex:j] intValue] == 0 &&
                [[[scoreBoard objectAtIndex:i] objectAtIndex:j] intValue] > maxCredit) {
                maxCredit = [[[scoreBoard objectAtIndex:i] objectAtIndex:j] intValue];
                maxX = i;
                maxY = j;
            }
        }
    CGPoint bestPoint = CGPointMake(maxX, maxY);
    return bestPoint;
}

- (NSInteger)getTopNum:(CGPoint)point withColor:(int)color;
{
    NSInteger result = 0;
    for (int i = (int)point.x-1, j=(int)point.y; i >= 0; i--) {
        if ([[[tempBoard objectAtIndex:i] objectAtIndex:j] intValue] != color)
            break;
        result++;
    }
    return result;
}

- (NSInteger)getLeftTopNum:(CGPoint)point withColor:(int)color
{
    NSInteger result = 0;
    for (int i = (int)point.x-1, j=(int)point.y-1; i >= 0 && j >= 0; i--, j--) {
        if ([[[tempBoard objectAtIndex:i] objectAtIndex:j] intValue] != color)
            break;
        result++;
    }
    return result;
}

- (NSInteger)getLeftNum:(CGPoint)point withColor:(int)color
{
    NSInteger result = 0;
    for (int i = (int)point.x, j=(int)point.y-1; j >= 0; j--) {
        if ([[[tempBoard objectAtIndex:i] objectAtIndex:j] intValue] != color)
            break;
        result++;
    }
    return result;
}

- (NSInteger)getLeftBottomNum:(CGPoint)point withColor:(int)color
{
    NSInteger result = 0;
    for (int i = (int)point.x+1, j=(int)point.y-1; i <= [ljrBoardManager boardSize] && j >= 0; i++, j--) {
        if ([[[tempBoard objectAtIndex:i] objectAtIndex:j] intValue] != color)
            break;
        result++;
    }
    return result;
}

- (NSInteger)getBottomNum:(CGPoint)point withColor:(int)color
{
    NSInteger result = 0;
    for (int i = (int)point.x+1, j=(int)point.y; i <= [ljrBoardManager boardSize]; i++) {
        if ([[[tempBoard objectAtIndex:i] objectAtIndex:j] intValue] != color)
            break;
        result++;
    }
    return result;
}

- (NSInteger)getRightBottomNum:(CGPoint)point withColor:(int)color
{
    NSInteger result = 0;
    for (int i = (int)point.x+1, j=(int)point.y+1; i <= [ljrBoardManager boardSize] && j <= [ljrBoardManager boardSize]; i++, j++) {
        if ([[[tempBoard objectAtIndex:i] objectAtIndex:j] intValue] != color)
            break;
        result++;
    }
    return result;
}

- (NSInteger)getRightNum:(CGPoint)point withColor:(int)color
{
    NSInteger result = 0;
    for (int i = (int)point.x, j=(int)point.y+1; j <= [ljrBoardManager boardSize]; j++) {
        if ([[[tempBoard objectAtIndex:i] objectAtIndex:j] intValue] != color)
            break;
        result++;
    }
    return result;
}

- (NSInteger)getRightTopNum:(CGPoint)point withColor:(int)color
{
    NSInteger result = 0;
    for (int i = (int)point.x-1, j=(int)point.y+1; i >= 0 && j <= [ljrBoardManager boardSize]; i--, j++) {
        if ([[[tempBoard objectAtIndex:i] objectAtIndex:j] intValue] != color)
            break;
        result++;
    }
    return result;
}

- (void)calcCreditsforColor:(int)color
{
    for (int i = 0; i < [ljrBoardManager boardSize]; i++) {
        for (int j = 0; j < [ljrBoardManager boardSize]; j++) {
            CGPoint point = CGPointMake(i, j);
            int topNum = [self getTopNum:point withColor:color];
            int leftTopNum = [self getLeftTopNum:point withColor:color];
            int leftNum = [self getLeftTopNum:point withColor:color];
            int leftBottomNum = [self getLeftBottomNum:point withColor:color];
            int bottomNum = [self getBottomNum:point withColor:color];
            int rightBottomNum = [self getRightBottomNum:point withColor:color];
            int rightNum = [self getRightNum:point withColor:color];
            int rightTopNum = [self getRightTopNum:point withColor:color];
            
            BOOL verticalH = false, horizonH = false, leftCrossH = false, rightCrossH = false;
            if (i - topNum > 0 && i + bottomNum < [ljrBoardManager boardSize])
                verticalH = ([[[tempBoard objectAtIndex:(i-topNum-1)] objectAtIndex:j] intValue] == 0 &&
                             [[[tempBoard objectAtIndex:(i+bottomNum+1)] objectAtIndex:j] intValue] == 0);
            if (j - leftNum > 0 && j + rightNum < [ljrBoardManager boardSize])
                horizonH = ([[[tempBoard objectAtIndex:i] objectAtIndex:(j-leftNum-1)] intValue] == 0 &&
                            [[[tempBoard objectAtIndex:i] objectAtIndex:(j+rightNum+1)] intValue] == 0);
            if (i - leftTopNum > 0 && j - leftTopNum > 0 && i + rightBottomNum < [ljrBoardManager boardSize] && j + rightBottomNum < [ljrBoardManager boardSize])
                leftCrossH = ([[[tempBoard objectAtIndex:(i-leftTopNum-1)] objectAtIndex:(j-leftTopNum-1)] intValue] == 0 && [[[tempBoard objectAtIndex:(i+rightBottomNum+1)] objectAtIndex:(j+rightBottomNum+1)] intValue] == 0);
            if (i + leftBottomNum < [ljrBoardManager boardSize] && j - leftBottomNum > 0 && i - rightTopNum > 0 && j + rightTopNum < [ljrBoardManager boardSize])
                rightCrossH = ([[[tempBoard objectAtIndex:(i+leftBottomNum+1)] objectAtIndex:(j-leftBottomNum-1)] intValue] == 0 && [[[tempBoard objectAtIndex:(i-rightTopNum-1)] objectAtIndex:(j+rightTopNum+1)] intValue] == 0);
            
            int verticalNum = topNum + bottomNum + 1;
            int horizonNum = leftNum + rightNum + 1;
            int leftCrossNum = leftTopNum + rightBottomNum + 1;
            int rightCrossNum = leftBottomNum + rightTopNum + 1;
        }
    }
}


@end
