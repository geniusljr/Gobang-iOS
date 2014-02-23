//
//  ljrCreditCalc.h
//  gobang3
//
//  Created by Bell on 23/6/13.
//  Copyright (c) 2013 Bell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ljrCreditCalc : NSObject
{
    NSMutableArray* tempBoard;
    NSMutableArray* scoreBoard;
}

- (CGPoint)getBestPoint:(NSMutableArray *)board;
- (NSInteger)getTopNum:(CGPoint)point withColor:(int)color;
- (NSInteger)getLeftTopNum:(CGPoint)point withColor:(int)color;
- (NSInteger)getLeftNum:(CGPoint)point withColor:(int)color;
- (NSInteger)getLeftBottomNum:(CGPoint)point withColor:(int)color;
- (NSInteger)getBottomNum:(CGPoint)point withColor:(int)color;
- (NSInteger)getRightBottomNum:(CGPoint)point withColor:(int)color;
- (NSInteger)getRightNum:(CGPoint)point withColor:(int)color;
- (NSInteger)getRightTopNum:(CGPoint)point withColor:(int)color;
- (void)calcCreditsforColor:(int)color;

@end
