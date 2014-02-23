//
//  ljrValueCalculator.m
//  gobang3
//
//  Created by Bell on 24/6/13.
//  Copyright (c) 2013 Bell. All rights reserved.
//

#import "ljrValueCalculator.h"
#import "ljrBoardManager.h"

int const h5=9999999, f4=500000, h4=20000, h3=5000, doub3=2500, c4=900, c3=200, f2=50, h1=2, c1=1;
//h5表示自己可以连成五个——必胜
//f4表示防守对方已有的连四，必防
//h4表示自己可以连出活四——必胜
//h3表示防守对方已有的活三
//c4表示自己可以连出冲四——对方必防

@implementation ljrValueCalculator

- (id)init
{
    self = [super init];
    if (self) {
        for (int i = 0; i < [ljrBoardManager boardSize]; i++)
            for (int j = 0; j < [ljrBoardManager boardSize]; j++) {
                value[i][j] = 0;
                piece[i][j] = 0;
            }
    }
    return self;
}

- (void)removePoint:(CGPoint)point
{
    int x = (int)point.x;
    int y = (int)point.y;
    piece[x][y] = 0;
}

- (CGPoint)getBestPointWithNewPoint:(CGPoint)point withColor:(int)color
{
    int x = (int)point.x;
    int y = (int)point.y;
    if (color == [ljrBoardManager blackNum])
        piece[x][y] = -1;
    else if (color == [ljrBoardManager whiteNum])
        piece[x][y] = 1;
    [self check51];
    [self check3];
    [self check4];
    [self check_double3];
    [self check1];
    [self check21];
    [self check31];
    [self check41];
    
    int max=-1;
    for (int i = 0;i < 13; i++)
        for (int j = 0;j < 13; j++)
            max = value[i][j] > max ? value[i][j] : max;
    
    /*
    for (int i = 0; i < 13; i++) {
        for (int j = 0; j < 13; j++)
            printf("%d, \t", piece[i][j]);
        printf("\n");
    }
    printf("value\n");
    for (int i = 0; i < 13; i++) {
        for (int j = 0; j < 13; j++)
            printf("%d, ", value[i][j]);
        printf("\n");
    }
    */
    NSMutableArray* bestSets = [[NSMutableArray alloc] init];
    for (int i = 0; i < 13; i++)
        for (int j = 0; j < 13; j++) {
            if (value[i][j] == max)
                [bestSets addObject:[NSValue valueWithCGPoint: CGPointMake(i, j)]];
        }
    CGPoint bestPoint = [[bestSets objectAtIndex:(arc4random() % [bestSets count])] CGPointValue];
    
    piece[(int)bestPoint.x][(int)bestPoint.y] = 1;
    for (int i = 0; i < [ljrBoardManager boardSize]; i++)
        for (int j = 0; j < [ljrBoardManager boardSize]; j++) {
            value[i][j] = 0;
        }
    return bestPoint;
}

- (void)check21
{
    for (int i = 2; i < 11; i++)
		for (int j = 2; j < 11; j++) {
			if (piece[i][j] != 0) continue;
			else {
				if (piece[i][j+1] == -1 && piece[i][j+2] == 0) value[i][j] += c1;
                if (piece[i][j-1] == -1 && piece[i][j-2] == 0) value[i][j] += c1;
				if (piece[i-1][j] == -1 && piece[i-2][j] == 0) value[i][j] += c1;
                if (piece[i+1][j] == -1 && piece[i+2][j] == 0) value[i][j] += c1;
				if (piece[i-1][j-1] == -1 && piece[i-2][j-2] == 0) value[i][j] += h1;
                if (piece[i+1][j+1] == -1 && piece[i+2][j+2] == 0) value[i][j] += h1;
				if (piece[i-1][j+1] == -1 && piece[i-2][j+2] == 0) value[i][j] += h1;
                if (piece[i+1][j-1] == -1 && piece[i+2][j-2] == 0) value[i][j] += h1;
			}
		}	
}

- (void)check31
{
	//(*)**
	//横着的
    for (int i = 0; i < 13; i++)
		for (int j = 2; j < 9; j++)
		{
            if (piece[i][j]!=0) continue;
			else
			{
				if (piece[i][j+1]==-1&&piece[i][j+2]==-1&&piece[i][j+3]==0&&piece[i][j-1]==0&&(piece[i][j-2]==0||piece[i][j+4]==0)) value[i][j]+=h3/3;
				if (piece[i][j+1]==-1&&piece[i][j+2]==-1&&piece[i][j+3]==1&&piece[i][j-1]==0&&piece[i][j-2]==0) value[i][j]+=c3/3;
				if (piece[i][j+1]==-1&&piece[i][j+2]==-1&&piece[i][j+3]==0&&piece[i][j-1]==1&&piece[i][j+4]==0) value[i][j]+=c3/3;
			    if (piece[i][j+1]==0&&piece[i][j+2]==-1&&piece[i][j+3]==-1&&piece[i][j+4]==0&&piece[i][j-1]==0) value[i][j]+=h3/3-20;
			}
		}
    
	for (int i = 0; i < 13; i++)
		for (int j = 4; j < 11; j++)
		{
			if (piece[i][j]!=0) continue;
			else
			{
				if (piece[i][j-1]==-1&&piece[i][j-2]==-1&&piece[i][j-3]==0&&piece[i][j+1]==0&&(piece[i][j+2]==0||piece[i][j-4]==0)) value[i][j]+=h3/3;
				if (piece[i][j-1]==-1&&piece[i][j-2]==-1&&piece[i][j-3]==1&&piece[i][j+1]==0&&piece[i][j+2]==0) value[i][j]+=c3/3;
				if (piece[i][j-1]==-1&&piece[i][j-2]==-1&&piece[i][j-3]==0&&piece[i][j+1]==1&&piece[i][j-4]==0) value[i][j]+=c3/3;
			    if (piece[i][j-1]==0&&piece[i][j-2]==-1&&piece[i][j-3]==-1&&piece[i][j+1]==0&&piece[i][j-4]==0) value[i][j]+=h3/3-20;
			}
		}
	//竖着的
	for (int i = 2; i < 9; i++)
		for (int j = 0; j < 13; j++)
		{
            if (piece[i][j]!=0) continue;
			else
			{
				if (piece[i+1][j]==-1&&piece[i+2][j]==-1&&piece[i+3][j]==0&&piece[i-1][j]==0&&(piece[i-2][j]==0||piece[i+4][j]==0)) value[i][j]+=h3/3;
				if (piece[i+1][j]==-1&&piece[i+2][j]==-1&&piece[i+3][j]==1&&piece[i-1][j]==0&&piece[i-2][j]==0) value[i][j]+=c3/3;
				if (piece[i+1][j]==-1&&piece[i+2][j]==-1&&piece[i+3][j]==0&&piece[i-1][j]==1&&piece[i+4][j]==0) value[i][j]+=c3/3;
			    if (piece[i+1][j]==0&&piece[i+2][j]==-1&&piece[i+3][j]==-1&&piece[i+4][j]==0&&piece[i-1][j]==0) value[i][j]+=h3/3-20;
			}
		}
	for (int i = 4; i < 11; i++)
		for (int j = 0; j < 13; j++)
		{
			if (piece[i][j]!=0) continue;
			else
			{
				if (piece[i-1][j]==-1&&piece[i-2][j]==-1&&piece[i-3][j]==0&&piece[i+1][j]==0&&(piece[i+2][j]==0||piece[i-4][j]==0)) value[i][j]+=h3/3;
				if (piece[i-1][j]==-1&&piece[i-2][j]==-1&&piece[i-3][j]==1&&piece[i+1][j]==0&&piece[i+2][j]==0) value[i][j]+=c3/3;
				if (piece[i-1][j]==-1&&piece[i-2][j]==-1&&piece[i-3][j]==0&&piece[i+1][j]==1&&piece[i-4][j]==0) value[i][j]+=c3/3;
			    if (piece[i-1][j]==0&&piece[i-2][j]==-1&&piece[i-3][j]==-1&&piece[i+1][j]==0&&piece[i-4][j]==0) value[i][j]+=h3/3-20;
			}
		}
	//左斜
	for (int i = 2; i < 9; i++)
		for (int j = 2; j < 9; j++)
		{
			if (piece[i][j]!=0) continue;
			else
			{
				if (piece[i+1][j+1]==-1&&piece[i+2][j+2]==-1&&piece[i+3][j+3]==0&&piece[i-1][j-1]==0&&(piece[i-2][j-2]==0||piece[i+4][j+4]==0)) value[i][j]+=h3/3;
				if (piece[i+1][j+1]==-1&&piece[i+2][j+2]==-1&&piece[i+3][j+3]==1&&piece[i-1][j-1]==0&&piece[i-2][j-2]==0) value[i][j]+=c3/3;
				if (piece[i+1][j+1]==-1&&piece[i+2][j+2]==-1&&piece[i+3][j+3]==0&&piece[i-1][j-1]==1&&piece[i+4][j+4]==0) value[i][j]+=c3/3;
			    if (piece[i+1][j+1]==0&&piece[i+2][j+2]==-1&&piece[i+3][j+3]==-1&&piece[i+4][j+4]==0&&piece[i-1][j-1]==0) value[i][j]+=h3/3-20;
			}
		}
	for (int i = 4; i < 11; i++)
		for (int j = 4; j < 11; j++)
		{
			if (piece[i][j]!=0) continue;
			else
			{
				if (piece[i-1][j-1]==-1&&piece[i-2][j-2]==-1&&piece[i-3][j-3]==0&&piece[i+1][j+1]==0&&(piece[i+2][j+2]==0||piece[i-4][j-4]==0)) value[i][j]+=h3/3;
				if (piece[i-1][j-1]==-1&&piece[i-2][j-2]==-1&&piece[i-3][j-3]==1&&piece[i+1][j+1]==0&&piece[i+2][j+2]==0) value[i][j]+=c3/3;
				if (piece[i-1][j-1]==-1&&piece[i-2][j-2]==-1&&piece[i-3][j-3]==0&&piece[i+1][j+1]==1&&piece[i-4][j-4]==0) value[i][j]+=c3/3;
			    if (piece[i-1][j-1]==0&&piece[i-2][j-2]==-1&&piece[i-3][j-3]==-1&&piece[i+1][j+1]==0&&piece[i-4][j-4]==0) value[i][j]+=h3/3-20;
			}
		}
	//右斜
	for (int i = 2; i < 9; i++)
		for (int j = 4; j < 11; j++)
		{
			if (piece[i][j]!=0) continue;
			else
			{
				if (piece[i+1][j-1]==-1&&piece[i+2][j-2]==-1&&piece[i+3][j-3]==0&&piece[i-1][j+1]==0&&(piece[i-2][j+2]==0||piece[i+4][j-4]==0)) value[i][j]+=h3/3;
				if (piece[i+1][j-1]==-1&&piece[i+2][j-2]==-1&&piece[i+3][j-3]==1&&piece[i-1][j+1]==0&&piece[i-2][j+2]==0) value[i][j]+=c3/3;
				if (piece[i+1][j-1]==-1&&piece[i+2][j-2]==-1&&piece[i+3][j-3]==0&&piece[i-1][j+1]==1&&piece[i+4][j-4]==0) value[i][j]+=c3/3;
			    if (piece[i+1][j-1]==0&&piece[i+2][j-2]==-1&&piece[i+3][j-3]==-1&&piece[i+4][j-4]==0&&piece[i-1][j+1]==0) value[i][j]+=h3/3-20;
			}
		}
	for (int i = 4; i < 11; i++)
		for (int j = 1; j < 9; j++)
		{
			if (piece[i][j]!=0) continue;
			else
			{
				if (piece[i-1][j+1]==-1&&piece[i-2][j+2]==-1&&piece[i-3][j+3]==0&&piece[i+1][j-1]==0&&(piece[i+2][j-2]==0||piece[i-4][j+4]==0)) value[i][j]+=h3/3;
				if (piece[i-1][j+1]==-1&&piece[i-2][j+2]==-1&&piece[i-3][j+3]==1&&piece[i+1][j-1]==0&&piece[i+2][j-2]==0) value[i][j]+=c3/3;
				if (piece[i-1][j+1]==-1&&piece[i-2][j+2]==-1&&piece[i-3][j+3]==0&&piece[i+1][j-1]==1&&piece[i-4][j+4]==0) value[i][j]+=c3/3;
			    if (piece[i-1][j+1]==0&&piece[i-2][j+2]==-1&&piece[i-3][j+3]==-1&&piece[i+1][j-1]==0&&piece[i-4][j+4]==0) value[i][j]+=h3/3-20;
			}
		}
	//*(*)*
	//横着的
    for (int i = 0; i < 13; i++)
		for (int j = 2; j < 10; j++)
		{
            if (piece[i][j]!=0) continue;
			else
			{
				if (piece[i][j+1]==-1&&piece[i][j-1]==-1&&piece[i][j+2]==0&&piece[i][j-2]==0) value[i][j]+=h3/3;
				if (piece[i][j+1]==-1&&piece[i][j-1]==-1&&piece[i][j+2]==1&&piece[i][j-2]==0) value[i][j]+=c3/3;
				if (piece[i][j+1]==-1&&piece[i][j-1]==-1&&piece[i][j+2]==0&&piece[i][j-2]==1) value[i][j]+=c3/3;
				if (piece[i][j-1]==-1&&piece[i][j+1]==0&&piece[i][j+2]==-1&&piece[i][j-2]==0&&piece[i][j+3]==0) value[i][j]+=h3/3;
				if (piece[i][j-1]==0&&piece[i][j+1]==-1&&piece[i][j+2]==0&&piece[i][j-2]==-1&&piece[i][j+3]==0) value[i][j]+=h3/3;
			}
		}
	//竖着的
	for (int i = 2; i < 10; i++)
		for (int j = 0; j < 13; j++)
		{
            if (piece[i][j]!=0) continue;
			else
			{
				if (piece[i+1][j]==-1&&piece[i-1][j]==-1&&piece[i+2][j]==0&&piece[i-2][j]==0) value[i][j]+=h3/3;
				if (piece[i+1][j]==-1&&piece[i-1][j]==-1&&piece[i+2][j]==1&&piece[i-2][j]==0) value[i][j]+=c3/3;
				if (piece[i+1][j]==-1&&piece[i-1][j]==-1&&piece[i+2][j]==0&&piece[i-2][j]==1) value[i][j]+=c3/3;
				if (piece[i-1][j]==-1&&piece[i+1][j]==0&&piece[i+2][j]==-1&&piece[i-2][j]==0&&piece[i+3][j]==0) value[i][j]+=h3/3;
				if (piece[i-1][j]==0&&piece[i+1][j]==-1&&piece[i+2][j]==0&&piece[i-2][j]==-1&&piece[i+3][j]==0) value[i][j]+=h3/3;
			}
		}
	//左斜
	for (int i = 2; i < 10; i++)
		for (int j = 2; j < 10; j++)
		{
			if (piece[i][j]!=0) continue;
			else
			{
				if (piece[i+1][j+1]==-1&&piece[i-1][j-1]&&piece[i+2][j+2]==0&&piece[i-2][j-2]==0) value[i][j]+=h3/3;
				if (piece[i+1][j+1]==-1&&piece[i-1][j-1]&&piece[i+2][j+2]==0&&piece[i-2][j-2]==1) value[i][j]+=c3/3;
				if (piece[i+1][j+1]==-1&&piece[i-1][j-1]&&piece[i+2][j+2]==1&&piece[i-2][j-2]==0) value[i][j]+=c3/3;
				if (piece[i-1][j-1]==-1&&piece[i+1][j+1]==0&&piece[i+2][j+2]==-1&&piece[i-2][j-2]==0&&piece[i+3][j+3]==0) value[i][j]+=h3/3;
				if (piece[i-1][j-1]==0&&piece[i+1][j+1]==-1&&piece[i+2][j+2]==0&&piece[i-2][j-2]==-1&&piece[i+3][j+3]==0) value[i][j]+=h3/3;
			}
		}
	//右斜
	for (int i = 3; i < 11; i++)
		for (int j = 2; j < 10; j++)
		{
			if (piece[i][j]!=0) continue;
			else
			{
				if (piece[i+1][j-1]==-1&&piece[i-1][j+1]&&piece[i+2][j-2]==0&&piece[i-2][j+2]==0) value[i][j]+=h3/3;
				if (piece[i+1][j-1]==-1&&piece[i-1][j+1]&&piece[i+2][j-2]==0&&piece[i-2][j+2]==1) value[i][j]+=c3/3;
				if (piece[i+1][j-1]==-1&&piece[i-1][j+1]&&piece[i+2][j-2]==1&&piece[i-2][j+2]==0) value[i][j]+=c3/3;
				if (piece[i+1][j-1]==-1&&piece[i-1][j+1]==0&&piece[i-2][j+2]==-1&&piece[i+2][j-2]==0&&piece[i-3][j+3]==0) value[i][j]+=h3/3;
				if (piece[i+1][j-1]==0&&piece[i-1][j+1]==-1&&piece[i-2][j+2]==0&&piece[i+2][j-2]==-1&&piece[i-3][j+3]==0) value[i][j]+=h3/3;
			}
		}
}

- (void)check41
{
	//(*)***/***(*)
	//横着的
    for (int i = 0; i < 13; i++)
		for (int j = 0; j < 9; j++)
		{
            if (piece[i][j]!=0) continue;
			else
			{
				if (piece[i][j+1]==-1&&piece[i][j+2]==-1&&piece[i][j+3]==-1&&piece[i][j+4]==0&&piece[i][j-1]==0) value[i][j]+=h4;
				if (piece[i][j+1]==-1&&piece[i][j+2]==-1&&piece[i][j+3]==-1&&piece[i][j+4]==1&&piece[i][j-1]==0) value[i][j]+=c4;
				if (piece[i][j+1]==-1&&piece[i][j+2]==-1&&piece[i][j+3]==-1&&piece[i][j+4]==0&&piece[i][j-1]==1) value[i][j]+=c4;
				if (piece[i][j+1]==0&&piece[i][j+2]==-1&&piece[i][j+3]==-1&&piece[i][j+4]==-1) value[i][j]+=c4-20;
			}
		}
	for (int i = 0; i < 13; i++)
		for (int j = 4; j < 12; j++)
		{
			if (piece[i][j]!=0) continue;
			else
			{
				if (piece[i][j-1]==-1&&piece[i][j-2]==-1&&piece[i][j-3]==-1&&piece[i][j-4]==0&&piece[i][j+1]==0) value[i][j]+=h4;
				if (piece[i][j-1]==-1&&piece[i][j-2]==-1&&piece[i][j-3]==-1&&piece[i][j-4]==1&&piece[i][j+1]==0) value[i][j]+=c4;
				if (piece[i][j-1]==-1&&piece[i][j-2]==-1&&piece[i][j-3]==-1&&piece[i][j-4]==0&&piece[i][j+1]==1) value[i][j]+=c4;
				if (piece[i][j-1]==0&&piece[i][j-2]==-1&&piece[i][j-3]==-1&&piece[i][j-4]==-1) value[i][j]+=c4-20;
			}
		}
	//竖着的
	for (int i = 1; i < 9; i++)
		for (int j = 0; j < 13; j++)
		{
            if (piece[i][j]!=0) continue;
			else
			{
				if (piece[i+1][j]==-1&&piece[i+2][j]==-1&&piece[i+3][j]==-1&&piece[i+4][j]==0&&piece[i-1][j]==0) value[i][j]+=h4;
				if (piece[i+1][j]==-1&&piece[i+2][j]==-1&&piece[i+3][j]==-1&&piece[i+4][j]==1&&piece[i-1][j]==0) value[i][j]+=c4;
				if (piece[i+1][j]==-1&&piece[i+2][j]==-1&&piece[i+3][j]==-1&&piece[i+4][j]==0&&piece[i-1][j]==1) value[i][j]+=c4;
				if (piece[i+1][j]==0&&piece[i+2][j]==-1&&piece[i+3][j]==-1&&piece[i+4][j]==-1) value[i][j]+=c4-20;
			}
		}
	for (int i = 4; i < 12; i++)
		for (int j = 0; j < 13; j++)
		{
			if (piece[i][j]!=0) continue;
			else
			{
				if (piece[i-1][j]==-1&&piece[i-2][j]==-1&&piece[i-3][j]==-1&&piece[i-4][j]==0&&piece[i+1][j]==0) value[i][j]+=h4;
				if (piece[i-1][j]==-1&&piece[i-2][j]==-1&&piece[i-3][j]==-1&&piece[i-4][j]==1&&piece[i+1][j]==0) value[i][j]+=c4;
				if (piece[i-1][j]==-1&&piece[i-2][j]==-1&&piece[i-3][j]==-1&&piece[i-4][j]==0&&piece[i+1][j]==1) value[i][j]+=c4;
				if (piece[i-1][j]==0&&piece[i-2][j]==-1&&piece[i-3][j]==-1&&piece[i-4][j]==-1) value[i][j]+=c4-20;
			}
		}
	//左斜
	for (int i = 1; i < 9; i++)
		for (int j = 1; j < 9; j++)
		{
			if (piece[i][j]!=0) continue;
			else
			{
				if (piece[i+1][j+1]==-1&&piece[i+2][j+2]==-1&&piece[i+3][j+3]==-1&&piece[i+4][j+4]==0&&piece[i-1][j-1]==0) value[i][j]+=h4;
				if (piece[i+1][j+1]==-1&&piece[i+2][j+2]==-1&&piece[i+3][j+3]==-1&&piece[i+4][j+4]==1&&piece[i-1][j-1]==0) value[i][j]+=c4;
				if (piece[i+1][j+1]==-1&&piece[i+2][j+2]==-1&&piece[i+3][j+3]==-1&&piece[i+4][j+4]==0&&piece[i-1][j-1]==1) value[i][j]+=c4;
				if (piece[i+1][j+1]==0&&piece[i+2][j+2]==-1&&piece[i+3][j+3]==-1&&piece[i+4][j+4]==-1) value[i][j]+=c4-20;
			}
		}
	for (int i = 4; i < 12; i++)
		for (int j = 4; j < 12; j++)
		{
			if (piece[i][j]!=0) continue;
			else
			{
				if (piece[i-1][j-1]==-1&&piece[i-2][j-2]==-1&&piece[i-3][j-3]==-1&&piece[i-4][j-4]==0&&piece[i+1][j+1]==0) value[i][j]+=h4;
				if (piece[i-1][j-1]==-1&&piece[i-2][j-2]==-1&&piece[i-3][j-3]==-1&&piece[i-4][j-4]==1&&piece[i+1][j+1]==0) value[i][j]+=c4;
				if (piece[i-1][j-1]==-1&&piece[i-2][j-2]==-1&&piece[i-3][j-3]==-1&&piece[i-4][j-4]==0&&piece[i+1][j+1]==1) value[i][j]+=c4;
				if (piece[i-1][j-1]==0&&piece[i-2][j-2]==-1&&piece[i-3][j-3]==-1&&piece[i-4][j-4]==-1) value[i][j]+=c4-20;
			}
		}
	//右斜
	for (int i = 4; i < 12; i++)
		for (int j = 1; j < 9; j++)
		{
			if (piece[i][j]!=0) continue;
			else
			{
				if (piece[i-1][j+1]==-1&&piece[i-2][j+2]==-1&&piece[i-3][j+3]==-1&&piece[i-4][j+4]==0&&piece[i+1][j-1]==0) value[i][j]+=h4;
				if (piece[i-1][j+1]==-1&&piece[i-2][j+2]==-1&&piece[i-3][j+3]==-1&&piece[i-4][j+4]==1&&piece[i+1][j-1]==0) value[i][j]+=c4;
				if (piece[i-1][j+1]==-1&&piece[i-2][j+2]==-1&&piece[i-3][j+3]==-1&&piece[i-4][j+4]==0&&piece[i+1][j-1]==1) value[i][j]+=c4;
				if (piece[i-1][j+1]==0&&piece[i-2][j+2]==-1&&piece[i-3][j+3]==-1&&piece[i-4][j+4]==-1) value[i][j]+=c4-20;
			}
		}
	for (int i = 1; i < 9; i++)
		for (int j = 4; j < 12; j++)
		{
			if (piece[i][j]!=0) continue;
			else
			{
				if (piece[i+1][j-1]==-1&&piece[i+2][j-2]==-1&&piece[i+3][j-3]==-1&&piece[i+4][j-4]==0&&piece[i-1][j+1]==0) value[i][j]+=h4;
				if (piece[i+1][j-1]==-1&&piece[i+2][j-2]==-1&&piece[i+3][j-3]==-1&&piece[i+4][j-4]==1&&piece[i-1][j+1]==0) value[i][j]+=c4;
				if (piece[i+1][j-1]==-1&&piece[i+2][j-2]==-1&&piece[i+3][j-3]==-1&&piece[i+4][j-4]==0&&piece[i-1][j+1]==1) value[i][j]+=c4;
				if (piece[i+1][j-1]==0&&piece[i+2][j-2]==-1&&piece[i+3][j-3]==-1&&piece[i+4][j-4]==-1) value[i][j]+=c4-20;
			}
		}
	//*(*)**/**(*)*
	//横着的
    for (int i = 0; i < 13; i++)
		for (int j = 3; j < 10; j++)
		{
            if (piece[i][j]!=0) continue;
			else
			{
				if (piece[i][j+1]==-1&&piece[i][j-1]==-1&&piece[i][j+2]==-1&&piece[i][j+3]==0&&piece[i][j-2]==0) value[i][j]+=h4;
				if (piece[i][j+1]==-1&&piece[i][j-1]==-1&&piece[i][j-2]==-1&&piece[i][j-3]==0&&piece[i][j+2]==0) value[i][j]+=h4;
				if (piece[i][j+1]==-1&&piece[i][j-1]==-1&&piece[i][j+2]==-1&&piece[i][j+3]==1&&piece[i][j-2]==0) value[i][j]+=c4;
				if (piece[i][j+1]==-1&&piece[i][j-1]==-1&&piece[i][j+2]==-1&&piece[i][j+3]==0&&piece[i][j-2]==1) value[i][j]+=c4;
				if (piece[i][j+1]==-1&&piece[i][j-1]==-1&&piece[i][j-2]==-1&&piece[i][j-3]==1&&piece[i][j+2]==0) value[i][j]+=c4;
				if (piece[i][j+1]==-1&&piece[i][j-1]==-1&&piece[i][j-2]==-1&&piece[i][j-3]==0&&piece[i][j+2]==1) value[i][j]+=c4;
                
			}
		}
	//竖着的
	for (int i = 3; i < 10; i++)
		for (int j = 0; j < 13; j++)
		{
            if (piece[i][j]!=0) continue;
			else
			{
				if (piece[i+1][j]==-1&&piece[i-1][j]==-1&&piece[i+2][j]==-1&&piece[i+3][j]==0&&piece[i-2][j]==0) value[i][j]+=h4;
				if (piece[i+1][j]==-1&&piece[i-1][j]==-1&&piece[i-2][j]==-1&&piece[i-3][j]==0&&piece[i+2][j]==0) value[i][j]+=h4;
				if (piece[i+1][j]==-1&&piece[i-1][j]==-1&&piece[i+2][j]==-1&&piece[i+3][j]==1&&piece[i-2][j]==0) value[i][j]+=c4;
				if (piece[i+1][j]==-1&&piece[i-1][j]==-1&&piece[i+2][j]==-1&&piece[i+3][j]==0&&piece[i-2][j]==1) value[i][j]+=c4;
				if (piece[i+1][j]==-1&&piece[i-1][j]==-1&&piece[i-2][j]==-1&&piece[i-3][j]==1&&piece[i+2][j]==0) value[i][j]+=c4;
				if (piece[i+1][j]==-1&&piece[i-1][j]==-1&&piece[i-2][j]==-1&&piece[i-3][j]==0&&piece[i+2][j]==1) value[i][j]+=c4;
			}
		}
	//左斜
	for (int i = 3; i < 10; i++)
		for (int j = 3; j < 10; j++)
		{
			if (piece[i][j]!=0) continue;
			else
			{
				if (piece[i+1][j+1]==-1&&piece[i-1][j-1]==-1&&piece[i+2][j+2]==-1&&piece[i+3][j+3]==0&&piece[i-2][j-2]==0) value[i][j]+=h4;
				if (piece[i+1][j+1]==-1&&piece[i-1][j-1]==-1&&piece[i-2][j-2]==-1&&piece[i-3][j-3]==0&&piece[i+2][j+2]==0) value[i][j]+=h4;
				if (piece[i+1][j+1]==-1&&piece[i-1][j-1]==-1&&piece[i+2][j+2]==-1&&piece[i+3][j+3]==1&&piece[i-2][j-2]==0) value[i][j]+=c4;
				if (piece[i+1][j+1]==-1&&piece[i-1][j-1]==-1&&piece[i+2][j+2]==-1&&piece[i+3][j+3]==0&&piece[i-2][j-2]==1) value[i][j]+=c4;
				if (piece[i+1][j+1]==-1&&piece[i-1][j-1]==-1&&piece[i-2][j-2]==-1&&piece[i-3][j-3]==1&&piece[i+2][j+2]==0) value[i][j]+=c4;
				if (piece[i+1][j+1]==-1&&piece[i-1][j-1]==-1&&piece[i-2][j-2]==-1&&piece[i-3][j-3]==0&&piece[i+2][j+2]==1) value[i][j]+=c4;
			}
		}
	//右斜
	for (int i = 3; i < 10; i++)
		for (int j = 3; j < 10; j++)
		{
			if (piece[i][j]!=0) continue;
			else
			{
				if (piece[i+1][j-1]==-1&&piece[i-1][j+1]==-1&&piece[i+2][j-2]==-1&&piece[i+3][j-3]==0&&piece[i-2][j+2]==0) value[i][j]+=h4;
				if (piece[i+1][j-1]==-1&&piece[i-1][j+1]==-1&&piece[i-2][j+2]==-1&&piece[i-3][j+3]==0&&piece[i+2][j-2]==0) value[i][j]+=h4;
				if (piece[i+1][j-1]==-1&&piece[i-1][j+1]==-1&&piece[i+2][j-2]==-1&&piece[i+3][j-3]==1&&piece[i-2][j+2]==0) value[i][j]+=c4;
				if (piece[i+1][j-1]==-1&&piece[i-1][j+1]==-1&&piece[i+2][j-2]==-1&&piece[i+3][j-3]==0&&piece[i-2][j+2]==1) value[i][j]+=c4;
				if (piece[i+1][j-1]==-1&&piece[i-1][j+1]==-1&&piece[i-2][j+2]==-1&&piece[i-3][j+3]==1&&piece[i+2][j-2]==0) value[i][j]+=c4;
				if (piece[i+1][j-1]==-1&&piece[i-1][j+1]==-1&&piece[i-2][j+2]==-1&&piece[i-3][j+3]==0&&piece[i+2][j-2]==1) value[i][j]+=c4;
			}
		} 
}

- (void)check51
{
	//横着的
	int sum=0;
	for (int i = 0; i < 13; i++)
		for (int j = 0; j < 9; j++)
		{
			for (int t=0;t<=4;t++)
				sum+=piece[i][j+t];
			if (sum==-4)
			{
				for (int t=0;t<=4;t++)
					if (piece[i][j+t]==0) value[i][j+t]+=h5;
			}
			sum=0;
		}
	//竖着的
	for (int i = 0; i < 9; i++)
		for (int j = 0; j < 13; j++)
		{
			for (int t=0;t<=4;t++)
				sum+=piece[i+t][j];
			if (sum==-4)
			{
				for (int t=0;t<=4;t++)
					if (piece[i+t][j]==0) value[i+t][j]+=h5;
			}
			sum=0;
		}
	//左斜
	for (int i = 0; i < 9; i++)
		for (int j = 0; j < 9; j++)
		{
			for (int t=0;t<=4;t++)
				sum+=piece[i+t][j+t];
			if (sum==-4)
			{
				for (int t=0;t<=4;t++)
					if (piece[i+t][j+t]==0) value[i+t][j+t]+=h5;
			}
			sum=0;
		}
	//右斜
	for (int i = 4; i < 13; i++)
		for (int j = 0; j < 9; j++)
		{
			for (int t=0;t<=4;t++)
				sum+=piece[i-t][j+t];
			if (sum==-4)
			{
				for (int t=0;t<=4;t++)
					if (piece[i-t][j+t]==0) value[i-t][j+t]+=h5;
			}
			sum=0;
		}
}

- (void)check1
{
	for (int i = 2; i < 11; i++)
		for (int j = 2; j < 11; j++)
		{
			if (piece[i][j]==0) continue;
			else
			{
				if ((piece[i-1][j-1]==0)&&(piece[i+1][j+1]==0)&&piece[i-2][j-2]==0&&piece[i+2][j+2]==0)
				{
					value[i-1][j-1]+=h1;value[i+1][j+1]+=h1;
				}
				if ((piece[i-1][j+1]==0)&&(piece[i+1][j-1]==0)&&piece[i-2][j+2]==0&&piece[i+2][j-2]==0)
				{
					value[i-1][j+1]+=h1;value[i+1][j-1]+=h1;
				}
			}
		}
    for (int j = 0; j < 11; j++){
        if (piece[0][j] == 0) continue;
        else {
            if (piece[1][j+1] == 0 && piece[2][j+2] == 0)
                value[1][j+1] += c1;
        }
    }
    for (int j = 2; j < 13; j++) {
        if (piece[0][j] == 0) continue;
        else {
            if (piece[1][j-1] == 0 && piece[2][j-2] == 0)
                value[1][j-1] += c1;
        }
    }
    for (int j = 0; j < 11; j++){
        if (piece[12][j] == 0) continue;
        else {
            if (piece[11][j+1] == 0 && piece[10][j+2] == 0)
                value[11][j+1] += c1;
        }
    }
    for (int j = 2; j < 13; j++) {
        if (piece[12][j] == 0) continue;
        else {
            if (piece[11][j-1] == 0 && piece[10][j-2] == 0)
                value[11][j-1] += c1;
        }
    }
    for (int i = 0; i < 11; i++){
        if (piece[i][0] == 0) continue;
        else {
            if (piece[i+1][1] == 0 && piece[i+2][2] == 0)
                value[i+1][1] += c1;
        }
    }
    for (int i = 2; i < 13; i++){
        if (piece[i][0] == 0) continue;
        else {
            if (piece[i-1][1] == 0 && piece[i-2][2] == 0)
                value[i-1][1] += c1;
        }
    }
    for (int i = 0; i < 11; i++){
        if (piece[i][12] == 0) continue;
        else {
            if (piece[i+1][11] == 0 && piece[i+2][10] == 0)
                value[i+1][11] += c1;
        }
    }
    for (int i = 2; i < 13; i++){
        if (piece[i][12] == 0) continue;
        else {
            if (piece[i-1][11] == 0 && piece[i-2][10] == 0)
                value[i-1][11] += c1;
        }
    }


    
}

- (void)check3//活三
{
	int sum=0;
	//判断***
    //横着的
	for (int i = 0; i < 13; i++)
		for (int j = 0; j < 9; j++)
		{
			if (piece[i][j]!=0) continue;
			else
			{
                for (int t=1;t<=3;t++)
                    sum+=piece[i][j+t];
                if ((sum==3)&&(piece[i][j+4]==0)) value[i][j]+=h3;
                sum=0;
			}
		}
	for (int i = 0; i < 13; i++)
		for (int j = 4; j < 13; j++)
		{
			if (piece[i][j]!=0) continue;
			else
			{
                for (int t=1;t<=3;t++)
                    sum+=piece[i][j-t];
                if ((sum==3)&&(piece[i][j-4]==0)) value[i][j]+=h3;
                sum=0;
			}
		}
	//竖着的活三
	for (int i = 4; i < 13; i++)
		for (int j = 0; j < 13; j++)
		{
			if (piece[i][j]!=0) continue;
			else
			{
                for (int t=1;t<=3;t++)
                    sum+=piece[i-t][j];
                if ((sum==3)&&(piece[i-4][j]==0)) value[i][j]+=h3;
                sum=0;
			}
		}
	for (int i = 0; i < 9; i++)
		for (int j = 0; j < 13; j++)
		{
			if (piece[i][j]!=0) continue;
			else
			{
                for (int t=1;t<=3;t++)
                    sum+=piece[i+t][j];
                if ((sum==3)&&(piece[i+4][j]==0)) value[i][j]+=h3;
                sum=0;
			}
		}
	//左斜活三
    for (int i = 4; i < 13; i++)
        for (int j = 4; j < 13; j++)
        {
            if (piece[i][j]!=0) continue;
            else
            {
				for (int t=1;t<=3;t++)
					sum+=piece[i-t][j-t];
			    if ((sum==3)&&(piece[i-4][j-4]==0)) value[i][j]+=h3;
		        sum=0;
            }
        }
    for (int i = 0; i < 9; i++)
        for (int j = 0; j < 9; j++)
        {
            if (piece[i][j]!=0) continue;
            else
            {
				for (int t=1;t<=3;t++)
					sum+=piece[i+t][j+t];
			    if ((sum==3)&&(piece[i+4][j+4]==0)) value[i][j]+=h3;
		        sum=0;
            }
        }
	//右斜活三
    for (int i = 0; i < 9; i++)
        for (int j = 4; j < 13; j++)
        {
            if (piece[i][j]!=0) continue;
            else
            {
				for (int t=1;t<=3;t++)
					sum+=piece[i+t][j-t];
			    if ((sum==3)&&(piece[i+4][j-4]==0)) value[i][j]+=h3;
		        sum=0;
            }
        }
    for (int i = 4; i < 13; i++)
        for (int j = 0; j < 9; j++)
        {
            if (piece[i][j]!=0) continue;
            else
            {
				for (int t=1;t<=3;t++)
					sum+=piece[i-t][j+t];
			    if ((sum==3)&&(piece[i-4][j+4]==0)) value[i][j]+=h3;
		        sum=0;
            }
        }
	//判断**_*/*_**
    //横着的
    for (int i = 0; i < 13; i++)
        for (int j = 3; j < 10; j++)
        {
            if (piece[i][j]!=0) continue;
            else
            {
                if ((piece[i][j-1]+piece[i][j+1]+piece[i][j-2]==3)&&(piece[i][j-3]==0)&&(piece[i][j+2]==0))
                    value[i][j]+=h3;
                if ((piece[i][j-1]+piece[i][j+1]+piece[i][j+2]==3)&&(piece[i][j+3]==0)&&(piece[i][j-2]==0))
                    value[i][j]+=h3;
            }
        }
    //竖着的
    for (int i = 3; i < 10; i++)
        for (int j = 0; j < 13; j++)
        {
            if (piece[i][j]!=0) continue;
            else
            {
                if ((piece[i-1][j]+piece[i+1][j]+piece[i-2][j]==3)&&(piece[i-3][j]==0)&&(piece[i+2][j]==0))
                    value[i][j]+=h3;
                if ((piece[i-1][j]+piece[i+1][j]+piece[i+2][j]==3)&&(piece[i+3][j]==0)&&(piece[i-2][j]==0))
                    value[i][j]+=h3;
            }
        }
    //左斜
    for (int i = 3; i < 10; i++)
        for (int j = 3; j < 10; j++)
        {
            if (piece[i][j]!=0) continue;
            else
            {
                if ((piece[i-1][j-1]+piece[i+1][j+1]+piece[i-2][j-2]==3)&&(piece[i-3][j-3]==0)&&(piece[i+2][j+2]==0))
                    value[i][j]+=h3;
                if ((piece[i-1][j-1]+piece[i+1][j+1]+piece[i+2][j+2]==3)&&(piece[i+3][j+3]==0)&&(piece[i-2][j-2]==0))
                    value[i][j]+=h3;					 
            }
        }
    //右斜
    for (int i = 3; i < 10; i++)
        for (int j = 3; j < 10; j++)
        {
            if (piece[i][j]!=0) continue;
            else
            {
                if ((piece[i-1][j+1]+piece[i+1][j-1]+piece[i-2][j+2]==3)&&(piece[i-3][j+3]==0)&&(piece[i+2][j-2]==0))
                    value[i][j]+=h3;
                if ((piece[i+1][j-1]+piece[i-1][j+1]+piece[i+2][j-2]==3)&&(piece[i+3][j-3]==0)&&(piece[i-2][j+2]==0))
                    value[i][j]+=h3;					 
            }
        }
}

- (void)check4
{
    //横着的
	int sum=0;
	for (int i = 0; i < 13; i++)
		for (int j = 0; j < 9; j++)
		{
			if (piece[i][j]!=0) continue;
			else
			{
				for (int t=0;t<=4;t++)
					sum+=piece[i][j+t];
				if (sum==4)
				{
					for (int t=0;t<=4;t++)
						if (piece[i][j+t]==0) value[i][j+t]+=f4;
				}
				sum=0;
			}
		}
	for (int i = 0; i < 13; i++)
		for (int j = 4; j < 13; j++)
		{
			if (piece[i][j]!=0) continue;
			else
			{
				for (int t=0;t<=4;t++)
					sum+=piece[i][j-t];
				if (sum==4)
				{
					for (int t=0;t<=4;t++)
						if (piece[i][j-t]==0) value[i][j-t]+=f4;
				}
				sum=0;
			}
		}
	//竖着的
	for (int i = 0; i < 9; i++)
		for (int j = 0; j < 13; j++)
		{
			if (piece[i][j]!=0) continue;
			else
			{
				for (int t=0;t<=4;t++)
					sum+=piece[i+t][j];
				if (sum==4)
				{
					for (int t=0;t<=4;t++)
						if (piece[i+t][j]==0) value[i+t][j]+=f4;
				}
				sum=0;
			}
		}
	for (int i = 4; i < 13; i++)
		for (int j = 0; j < 13; j++)
		{
			if (piece[i][j]!=0) continue;
			else
			{
				for (int t=0;t<=4;t++)
					sum+=piece[i-t][j];
				if (sum==4)
				{
					for (int t=0;t<=4;t++)
						if (piece[i-t][j]==0) value[i-t][j]+=f4;
				}
				sum=0;
			}
		}
	//左斜
    for (int i = 0; i < 9; i++)
        for (int j = 0; j < 9; j++)
        {
            if (piece[i][j]!=0) continue;
            else
            {
                for (int t=0;t<=4;t++)
				 	sum+=piece[i+t][j+t];
                if (sum==4)
                {
					for (int t=0;t<=4;t++)
						if (piece[i+t][j+t]==0) value[i+t][j+t]+=f4;
                }
                sum=0;
            }
        }
    for (int i = 4; i < 13; i++)
        for (int j = 4; j < 13; j++)
        {
            if (piece[i][j]!=0) continue;
            else
            {
				for (int t=0;t<=4;t++)
					sum+=piece[i-t][j-t];
                if (sum==4)
                {
					for (int t=0;t<=4;t++)
						if (piece[i-t][j-t]==0) value[i-t][j-t]+=f4;
                }
				sum=0;
            }
        }
	//右斜
    for (int i = 0; i < 9; i++)
        for (int j = 4; j < 13; j++)
        {
            if (piece[i][j]!=0) continue;
            else
            {
                for (int t=0;t<=4;t++)
                    sum+=piece[i+t][j-t];
                if (sum==4)
                {
					for (int t=0;t<=4;t++)
						if (piece[i+t][j-t]==0) value[i+t][j-t]+=f4;
                }
                sum=0;
            }
        }
    for (int i = 4; i < 13; i++)
        for (int j = 0; j < 9; j++)
        {
            if (piece[i][j]!=0) continue;
            else
            {
                for (int t=0;t<=4;t++)
                    sum+=piece[i-t][j+t];
                if (sum==4)
                {
					for (int t=0;t<=4;t++)
						if (piece[i-t][j+t]==0) value[i-t][j+t]+=f4;
                }
                sum=0;
            }
        }
	//横着的
    for (int i = 0; i < 13; i++)
        for (int j = 1; j < 10; j++)
        {
            if (piece[i][j]!=0) continue;
            else
            {
                for (int t=-1;t<=3;t++)
                    sum+=piece[i][j+t];
                if (sum==4)
                {
                    for (int t=-1;t<=3;t++)
                        if (piece[i][j+t]==0) value[i][j+t]+=f4;
                }
                sum=0;
            }
        }
    for (int i = 0; i < 13; i++)
        for (int j = 3; j < 12; j++)
        {
            if (piece[i][j]!=0) continue;
            else
            {
                for (int t=-1;t<=3;t++)
                    sum+=piece[i][j-t];
                if (sum==4)
                {
                    for (int t=-1;t<=3;t++)
                        if (piece[i][j-t]==0) value[i][j-t]+=f4;
                }
                sum=0;
            }
        }
    for (int i = 0; i < 13; i++)
        for (int j = 2; j < 11; j++)
        {
            if (piece[i][j]!=0) continue;
            else
            {
                for (int t=-2;t<=2;t++)
                    sum+=piece[i][j+t];
                if (sum==4)
                {
                    for (int t=-2;t<=2;t++)
                        if (piece[i][j+t]==0) value[i][j+t]+=f4;
                }
                sum=0;
            }
        }
    //竖着的
    for (int i = 1; i < 10; i++)
        for (int j = 0; j < 13; j++)
        {
            if (piece[i][j]!=0) continue;
            else
            {
                for (int t=-1;t<=3;t++)
                    sum+=piece[i+t][j];
                if (sum==4)
                {
                    for (int t=-1;t<=3;t++)
                        if (piece[i+t][j]==0) value[i+t][j]+=f4;
                }
                sum=0;
            }
        }
    for (int i = 3; i < 12; i++)
        for (int j = 0; j < 13; j++)
        {
            if (piece[i][j]!=0) continue;
            else
            {
                for (int t=-1;t<=3;t++)
                    sum+=piece[i-t][j];
                if (sum==4)
                {
                    for (int t=-1;t<=3;t++)
                        if (piece[i-t][j]==0) value[i-t][j]+=f4;
                }
                sum=0;
            }
        }
    for (int i = 2; i < 11; i++)
        for (int j = 0; j < 13; j++)
        {
            if (piece[i][j]!=0) continue;
            else
            {
                for (int t=-2;t<=2;t++)
                    sum+=piece[i+t][j];
                if (sum==4)
                {
                    for (int t=-2;t<=2;t++)
                        if (piece[i+t][j]==0) value[i+t][j]+=f4;
                }
                sum=0;
            }
        }
    //左斜
    for (int i = 1; i < 10; i++)
        for (int j = 1; j < 10; j++)
        {
            if (piece[i][j]!=0) continue;
            else
            {
                for (int t=-1;t<=3;t++)
                    sum+=piece[i+t][j+t];
                if (sum==4)
                {
                    for (int t=-1;t<=3;t++)
                        if (piece[i+t][j+t]==0) value[i+t][j+t]+=f4;
                }
                sum=0;
            }
        }
    for (int i = 3; i < 12; i++)
        for (int j = 3; j < 12; j++)
        {
            if (piece[i][j]!=0) continue;
            else
            {
                for (int t=-1;t<=3;t++)
                    sum+=piece[i-t][j-t];
                if (sum==4)
                {
                    for (int t=-1;t<=3;t++)
                        if (piece[i-t][j-t]==0) value[i-t][j-t]+=f4;
                }
                sum=0;
            }
        }
    for (int i = 2; i < 11; i++)
        for (int j = 2; j < 11; j++)
        {
            if (piece[i][j]!=0) continue;
            else
            {
                for (int t=-2;t<=2;t++)
                    sum+=piece[i+t][j+t];
                if (sum==4)
                {
                    for (int t=-2;t<=2;t++)
                        if (piece[i+t][j+t]==0) value[i+t][j+t]+=f4;
                }
                sum=0;
            }
        }
    //右斜
    for (int i = 1; i < 10; i++)
        for (int j = 3; j < 12; j++)
        {
            if (piece[i][j]!=0) continue;
            else
            {
                for (int t=-1;t<=3;t++)
                    sum+=piece[i+t][j-t];
                if (sum==4)
                {
                    for (int t=-1;t<=3;t++)
                        if (piece[i+t][j-t]==0) value[i+t][j-t]+=f4;
                }
                sum=0;
            }
        }
    for (int i = 3; i < 12; i++)
        for (int j = 1; j < 10; j++)
        {
            if (piece[i][j]!=0) continue;
            else
            {
                for (int t=-1;t<=3;t++)
                    sum+=piece[i-t][j+t];
                if (sum==4)
                {
                    for (int t=-1;t<=3;t++)
                        if (piece[i-t][j+t]==0) value[i-t][j+t]+=f4;
                }
                sum=0;
            }
        }
    for (int i = 2; i < 11; i++)
        for (int j = 2; j < 11; j++)
        {
            if (piece[i][j]!=0) continue;
            else
            {
                for (int t=-2;t<=2;t++)
                    sum+=piece[i+t][j-t];
                if (sum==4)
                {
                    for (int t=-2;t<=2;t++)
                        if (piece[i+t][j-t]==0) value[i+t][j-t]+=f4;
                }
                sum=0;
            }
        }
}

- (void)check_double3
{
    int doub[13][13]={0};
    //横着的**_()/_**()/*_*()及反向
    for (int i = 0; i < 13; i++)
        for (int j = 4; j < 12; j++)
        {
            if (piece[i][j]!=0) continue;
            else
                if ((piece[i][j-1]+piece[i][j-2]+piece[i][j-3]==2)&&(piece[i][j-4]!=-1)&&(piece[i][j+1]!=-1)) doub[i][j]++;
        }
    for (int i = 0; i < 13; i++)
        for (int j  = 1; j < 9; j++)
        {
            if (piece[i][j]!=0) continue;
            else
                if ((piece[i][j+1]+piece[i][j+2]+piece[i][j+3]==2)&&(piece[i][j+4]!=-1)&&(piece[i][j-1]!=-1)) doub[i][j]++;
        }
    //竖着的
    for (int i = 4; i < 12; i++)
        for (int j = 0; j < 13; j++)
        {
            if (piece[i][j]!=0) continue;
            else if ((piece[i-1][j]+piece[i-2][j]+piece[i-3][j]==2)&&(piece[i-4][j]!=-1)&&(piece[i+1][j]!=-1)) doub[i][j]++;
        }
    for (int i = 1; i < 9; i++)
        for (int j = 0; j < 13; j++)
        {
            if (piece[i][j]!=0) continue;
            else if (piece[i+1][j]+piece[i+2][j]+piece[i+3][j]==2&&(piece[i+4][j]!=-1)&&piece[i-1][j]!=-1) doub[i][j]++;
        }
    //左斜
    for (int i = 4; i < 12; i++)
        for (int j = 4; j < 12; j++)
        {
            if (piece[i][j]!=0) continue;
            else if (piece[i-1][j-1]+piece[i-2][j-2]+piece[i-3][j-3]==2&&(piece[i-4][j-4]!=-1)&&piece[i+1][j+1]!=-1) doub[i][j]++;
        }
    for (int i = 1; i < 9; i++)
        for (int j = 1; j < 9; j++)
        {
            if (piece[i][j]!=0) continue;
            else if (piece[i+1][j+1]+piece[i+2][j+2]+piece[i+3][j+3]==2&&piece[i+4][j+4]!=-1&&piece[i-1][j-1]!=-1) doub[i][j]++;
        }
    //右斜
    for (int i = 1; i < 9; i++)
        for (int j = 4; j < 12; j++)
        {
            if (piece[i][j]!=0) continue;
            else if (piece[i+1][j-1]+piece[i+2][j-2]+piece[i+3][j-3]==2&&piece[i+4][j-4]!=-1&&piece[i-1][j+1]!=-1) doub[i][j]++;
        }
    for (int i = 4; i < 12; i++)
        for (int j = 1; j < 9; j++)
        {
            if (piece[i][j]!=0) continue;
            else if (piece[i-1][j+1]+piece[i-2][j+2]+piece[i-3][j+3]==2&&piece[i-4][j+4]!=-1&&piece[i+1][j-1]!=-1) doub[i][j]++;
        }
    // _*()*_
    for (int i = 4; i < 12; i++)
        for (int j = 4; j < 12; j++)
        {
            if (piece[i][j]!=0) continue;
            else
            {
                if (piece[i][j-1]==1&&piece[i][j+1]==1&&piece[i][j-2]==0&&piece[i][j+2]==0&&piece[i][j-3]+piece[i][j+3]<=1) doub[i][j]++;
                if (piece[i][j-1]==1&&piece[i][j+1]==0&&piece[i][j-2]==0&&piece[i][j+2]==1&&piece[i][j-3]+piece[i][j+3]<=1) doub[i][j]++;
                if (piece[i][j-1]==0&&piece[i][j+1]==1&&piece[i][j-2]==1&&piece[i][j+2]==0&&piece[i][j-3]+piece[i][j+3]<=1) doub[i][j]++;
            }
        }
    for (int i = 4; i < 12; i++)
        for (int j = 4; j < 12; j++)
        {
            if (piece[i][j]!=0) continue;
            else
            {
                if (piece[i-1][j]==1&&piece[i+1][j]==1&&piece[i-2][j]==0&&piece[i+2][j]==0&&piece[i-3][j]+piece[i+3][j]<=1) doub[i][j]++;
                if (piece[i-1][j]==1&&piece[i+1][j]==0&&piece[i-2][j]==0&&piece[i+2][j]==1&&piece[i-3][j]+piece[i+3][j]<=1) doub[i][j]++;
                if (piece[i-1][j]==0&&piece[i+1][j]==1&&piece[i-2][j]==1&&piece[i+2][j]==0&&piece[i-3][j]+piece[i+3][j]<=1) doub[i][j]++;
            }
        }
    for (int i = 4; i < 12; i++)
        for (int j = 4; j < 12; j++)
        {
            if (piece[i][j]!=0) continue;
            else
            {
                if (piece[i-1][j-1]==1&&piece[i+1][j+1]==1&&piece[i-2][j-2]==0&&piece[i+2][j+2]==0&&piece[i-3][j-3]+piece[i+3][j+3]<=1) doub[i][j]++;
                if (piece[i-1][j-1]==1&&piece[i+1][j+1]==0&&piece[i-2][j-2]==0&&piece[i+2][j+2]==1&&piece[i-3][j-3]+piece[i+3][j+3]<=1) doub[i][j]++;
                if (piece[i-1][j-1]==0&&piece[i+1][j+1]==1&&piece[i-2][j-2]==1&&piece[i+2][j+2]==0&&piece[i-3][j-3]+piece[i+3][j+3]<=1) doub[i][j]++;
            }
        }
    for (int i = 4; i < 12; i++)
        for (int j = 4; j < 12; j++)
        {
            if (piece[i][j]!=0) continue;
            else
            {
                if (piece[i-1][j+1]==1&&piece[i+1][j-1]==1&&piece[i-2][j+2]==0&&piece[i+2][j-2]==0&&piece[i-3][j+3]+piece[i+3][j-3]<=1) doub[i][j]++;
                if (piece[i-1][j+1]==1&&piece[i+1][j-1]==0&&piece[i-2][j+2]==0&&piece[i+2][j-2]==1&&piece[i-3][j+3]+piece[i+3][j-3]<=1) doub[i][j]++;
                if (piece[i-1][j+1]==0&&piece[i+1][j-1]==1&&piece[i-2][j+2]==1&&piece[i+2][j-2]==0&&piece[i-3][j+3]+piece[i+3][j-3]<=1) doub[i][j]++;
            }
        }
    for (int i = 0; i < 13; i++)
        for (int j = 0; j < 13; j++)
        {
            if (doub[i][j]==1) value[i][j]+=f2;
            if (doub[i][j]>=2) value[i][j]+=doub3;
        }
}

@end
