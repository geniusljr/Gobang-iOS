//
//  ljrMainBoardViewController.m
//  gobang3
//
//  Created by Bell on 21/6/13.
//  Copyright (c) 2013 Bell. All rights reserved.
//

#import "ljrMainBoardViewController.h"

@interface ljrMainBoardViewController ()

@end

@implementation ljrMainBoardViewController

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
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(leaveAnimation) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)leaveAnimation
{
    int startX= random()%320;
    int endX= random()%320;
    int width= random()%25;
    CGFloat time= (random()%100)/10+5;
    CGFloat alp= (random()%9)/10.0+0.1;
    
    UIImage* image= [UIImage imageNamed:@"snow.png"];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame= CGRectMake(startX,-1*width,width,width);
    imageView.alpha=alp;
    
    [self.view addSubview:imageView];
    
    
    [UIView beginAnimations:nil context:(__bridge void*)imageView];
    [UIView setAnimationDuration:time];
    
    if (endX > 50 && endX < 270){
        imageView.frame= CGRectMake(endX, 270-width/2, width, width);
    }
    else if ((endX > 10 && endX < 50) || ( endX > 270 && endX < 310))
        imageView.frame= CGRectMake(endX, 400-width/2, width, width);
    else
        imageView.frame= CGRectMake(endX, 480, width, width);
    [UIView setAnimationDidStopSelector:@selector(onAnimationComplete:finished:context:)];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

-(void)onAnimationComplete:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context
{
    UIImageView* leaveView=(__bridge UIImageView*)context;
    [leaveView removeFromSuperview];
    
}

@end
