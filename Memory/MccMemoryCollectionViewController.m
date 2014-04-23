//
//  MccMemoryCollectionViewController.m
//  Memory
//
//  Created by Petter Bergström on 2014-03-22.
//  Copyright (c) 2014 McCoy. All rights reserved.
//

#import "MccMemoryCollectionViewController.h"
#import "MccMemoryCard.h"
#import "NSMutableArray+MccShuffling.h"
#import "MccViewImageViewController.h"
#import "MccMemoryCardDAO.h"
#import "MccGrapicsUtil.h"

@interface MccMemoryCollectionViewController ()

@property MccMemoryCard *tappedCard;

@property NSArray *originalCards;
@end

@implementation MccMemoryCollectionViewController



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
    [self loadCardsToPlayWith];
    self.cards = [[NSMutableArray alloc] init];
    [self loadInitialCardData];
    [self addSwipeRecognizer];
}
- (void) loadCardsToPlayWith{
    MccMemoryCardDAO *dao = [MccMemoryCardDAO sharedSingleton];
    
    NSMutableArray *allCards = [[dao getAllCards] mutableCopy];
    [allCards shuffle];
    self.originalCards = [allCards subarrayWithRange: NSMakeRange(0, MIN([self getNrOfCards],[allCards count]))];
}



- (void) loadInitialCardData
{

    for(MemoryCard *card in self.originalCards){
        MccMemoryCard *memoryCard = [MccMemoryCardDAO convertToMccMemoryCard:card];
        memoryCard.state = STATE_FACE_DOWN;
        [self.cards addObject:memoryCard];
        [self.cards addObject:memoryCard];
        //Add two cards per image.
    }
    [self.cards shuffle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addSwipeRecognizer{
    UISwipeGestureRecognizer *mSwipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe)];
    
    [mSwipeUpRecognizer setDirection:( UISwipeGestureRecognizerDirectionDown)];
    
    [[self view] addGestureRecognizer:mSwipeUpRecognizer];

}
- (void) handleSwipe{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -
#pragma mark UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.cards count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MccMemoryCollectionViewCell *myCell = [collectionView
                                    dequeueReusableCellWithReuseIdentifier:@"MyCell"
                                    forIndexPath:indexPath];
    
    UIImage *image;
    long row = [indexPath row];
    MccMemoryCard *card = self.cards[row];
    CGRect scaledFrame =CGRectMake(myCell.frame.size.width * 0.02,
                                   myCell.frame.size.height * 0.02,
                                   myCell.frame.size.width*0.96,
                                   myCell.frame.size.height*0.96);
    myCell.imageView.frame = scaledFrame;
    CGSize size = scaledFrame.size;
    switch (card.state) {
        case STATE_FACE_DOWN:
            image = [MccGrapicsUtil createCardImage:[self facedownImage:200 :200] size:size];
            break;
        case STATE_FACE_UP:
            image = [MccGrapicsUtil createCardImage:[self faceupImage:card.image] size:size];
            break;
        case STATE_FLIPPED:
            image = [MccGrapicsUtil createCardImage:card.image size:size];
            break;
    }
    

    

    myCell.imageView.image = image;
    
    return myCell;
}
- (UIImage *) facedownImage:(CGFloat) width :(CGFloat) height
{
    CGSize newSize = CGSizeMake(width,height);
    UIGraphicsBeginImageContext(newSize);
    
        NSString *thePath = [[NSBundle mainBundle] pathForResource:@"green-and-white-polka-dots" ofType:@"png"];
        UIImage *patternImage = [[UIImage alloc] initWithContentsOfFile:thePath];
        CGRect rect = CGRectMake(0.0, 0.0, width, height);
        [patternImage drawAsPatternInRect:rect];
        UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return  finalImage;
}
- (UIImage *) faceupImage:(UIImage *)originalImage
{
    CGSize newSize = CGSizeMake(originalImage.size.width,originalImage.size.height);
    UIGraphicsBeginImageContext(newSize);
        CGRect rect = CGRectMake(0.0, 0.0, newSize.width, newSize.height);
        [originalImage drawInRect:rect blendMode:kCGBlendModeNormal alpha:0.6];
        //CGContextSetRGBFillColor(UIGraphicsGetCurrentContext(), 0.5, 0.5, 0.5, 0.5);
        //CGContextFillRect(UIGraphicsGetCurrentContext(), rect);
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return  finalImage;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    self.tappedCard = self.cards[indexPath.row];
    MccMemoryCard *flippedCard = nil;
    if(self.flippedIndexPath != nil && self.flippedIndexPath.row != indexPath.row){
        flippedCard = self.cards[self.flippedIndexPath.row];
    }
    switch (self.tappedCard.state) {
        case STATE_FLIPPED:
        case STATE_FACE_DOWN:
            if (flippedCard == nil) {
                //no other card flipped
                self.self.flippedIndexPath = indexPath.copy;
                self.tappedCard.state = STATE_FLIPPED;
            }else{
                //another card is flipped
                if (flippedCard.card== self.tappedCard.card) {
                    flippedCard.state = STATE_FACE_UP;
                    self.tappedCard.state = STATE_FACE_UP;
                    [collectionView reloadItemsAtIndexPaths:@[self.flippedIndexPath]];
                    self.flippedIndexPath = nil;
                    [self performSegueWithIdentifier:@"successSegue" sender:nil];
                }else{
                    flippedCard.state = STATE_FACE_DOWN;
                    self.tappedCard.state = STATE_FLIPPED;
                    [collectionView reloadItemsAtIndexPaths:@[self.flippedIndexPath]];
                    self.flippedIndexPath = indexPath.copy;
                }

            }
            break;
        case STATE_FACE_UP:
            [self performSegueWithIdentifier:@"successSegue" sender:nil];
            break;
            
        default:
            break;
    }
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat containerSide = MIN(self.view.frame.size.height,self.view.frame.size.width);
    CGFloat padding = 0;//containerSide*0.03;
    CGFloat cardSide = containerSide/[self getMinNrOfRows] - padding;
    //containerSide = 4*(padding+cardSide);,
    
    
    // Adjust cell size for orientation
    //if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
    //    return CGSizeMake(170.f-10, 170.f-20);
    //}
    return CGSizeMake(cardSide, cardSide);
}

- (int) getMinNrOfRows{
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return 3;
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return 4;
    }
    return 2;
}

- (int) getNrOfCards{
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if(iOSDeviceScreenSize.height == 480){
            return 6;
        }
        
        if(iOSDeviceScreenSize.height == 568){
            return 7;
        }
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return 10;
    }
    return 4;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqual:@"successSegue"]){
        MccViewImageViewController *otherView = [segue destinationViewController];
        UIImage *image =self.tappedCard.image;
        otherView.image = image;
        otherView.labelText = self.tappedCard.label;
    }
}

@end
