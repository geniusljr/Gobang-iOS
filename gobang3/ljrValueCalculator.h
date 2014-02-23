//
//  ljrValueCalculator.h
//  gobang3
//
//  Created by Bell on 24/6/13.
//  Copyright (c) 2013 Bell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ljrValueCalculator : NSObject
{
    int piece[13][13];
    int value[13][13];
}

- (CGPoint)getBestPointWithNewPoint:(CGPoint)point withColor:(int)color;
- (void)removePoint:(CGPoint)point;
- (void)check1;//防守函数
- (void)check3;//防守函数
- (void)check4;//防守函数
- (void)check_double3;//防守函数
- (void)check21;//进攻函数
- (void)check31;//进攻函数
- (void)check41;//进攻函数
- (void)check51;//进攻函数

@end
