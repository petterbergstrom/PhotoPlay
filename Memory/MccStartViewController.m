//
//  MccStartViewController.m
//  Memory
//
//  Created by Petter Bergström on 2014-03-25.
//  Copyright (c) 2014 McCoy. All rights reserved.
//

#import "MccStartViewController.h"
#import "MccMemoryCardDAO.h"
#import "NSMutableArray+MccShuffling.h"
#import "MccNonRotatingImageView.h"
#import "MccGrapicsUtil.h"

@interface MccStartViewController ()

@end

@implementation MccStartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) hideStatusBar{
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
}


- (void) setBackground{
    
    CGFloat side = MAX(self.view.frame.size.width, self.view.frame.size.height);
    CGRect rect = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.x, side, side);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    
    CGSize size = imageView.frame.size;
    MccMemoryCardDAO *dao = [MccMemoryCardDAO sharedSingleton];
    NSMutableArray *allCards = [[dao getAllCards] mutableCopy];
    [allCards shuffle];
    
    CGSize cardSize = CGSizeMake(200, 200);
    
    NSString *thePath = [[NSBundle mainBundle] pathForResource:@"green-and-white-polka-dots" ofType:@"png"];
    UIImage *patternImage = [[UIImage alloc] initWithContentsOfFile:thePath];
    UIImage *patterncard = [MccGrapicsUtil createCardImage:patternImage size:cardSize];

    UIGraphicsBeginImageContext(size);
    for(int i = 0; i< 10;i++){
        [self drawCard:patterncard canvasSize:size cardSize:cardSize];
    }
    for(int i = 0; i< MAX(allCards.count,10);i++){
        if(i< allCards.count){
            MccMemoryCard *memCard = [MccMemoryCardDAO convertToMccMemoryCard:allCards[i]];
            [self drawCard:[memCard getCardImage:cardSize] canvasSize:size cardSize:cardSize];
        }else{
            [self drawCard:patterncard canvasSize:size cardSize:cardSize];
        }
    }
    
    
    
    //Create Image
    UIImage *background = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    imageView.image = background;
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
    
}

- (void) drawCard: (UIImage*) memCardImage canvasSize:(CGSize) canvasSize cardSize:(CGSize) cardSize{
    CGContextRef    context =   UIGraphicsGetCurrentContext();
    CGAffineTransform   t   =   CGAffineTransformMakeTranslation(arc4random_uniform(canvasSize.width),                arc4random_uniform(canvasSize.height));
    CGAffineTransform   r   =   CGAffineTransformMakeRotation((arc4random_uniform(360))/180.0*M_PI);
    
    CGContextConcatCTM(context, t);
    CGContextConcatCTM(context, r);

    [memCardImage drawInRect:CGRectMake(0, 0, cardSize.width, cardSize.width)];
    
    
    CGContextConcatCTM(context, CGAffineTransformInvert(r));
    CGContextConcatCTM(context, CGAffineTransformInvert(t));
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBackground];
    [self hideStatusBar];
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindPictireList:(UIStoryboardSegue *)segue
{
    
}

@end
