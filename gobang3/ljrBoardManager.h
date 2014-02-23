//
//  ljrBoardManager.h
//  gobang3
//
//  Created by Bell on 20/6/13.
//  Copyright (c) 2013 Bell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ljrBoardManager : NSObject
{
    int curColorNum;
    NSMutableArray* boardArray;
    NSMutableArray* undoStack;
}
@property int curColorNum;

+ (NSString *)blackPiecePath;
+ (NSString *)whitePiecePath;
+ (int)pieceSize;
+ (int)boardSize;
+ (int)blackNum;
+ (int)whiteNum;
+ (CGPoint)getPiecePoint:(CGPoint)point;
+ (CGPoint)imageViewPointToArrayPoint:(CGPoint)point;

- (NSString *)getPieceImagePath;
- (BOOL)isPointAvailable:(CGPoint)point;
- (NSInteger)insertPoint:(UIImageView *)imageView;
- (BOOL)isWinner:(CGPoint)point;
- (UIImageView *)removeLastPiece;
- (void)changeColor;
- (void)initialize;


@end
