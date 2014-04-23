//
//  MccViewImageViewController.m
//  Memory
//
//  Created by Petter Bergström on 2014-03-23.
//  Copyright (c) 2014 McCoy. All rights reserved.
//

#import "MccViewImageViewController.h"
#import "MccMemoryCollectionViewController.h"
#import "MccGrapicsUtil.h"


@interface MccViewImageViewController ()

@end

@implementation MccViewImageViewController

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
    [self createLabel:self.labelText];
    
    CGSize imageSize = [self getImageSize];
    [self.detailImageView setImage:[MccGrapicsUtil createCardImage:self.image size:imageSize]];
    self.detailImageView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
    self.detailImageView.center = self.detailImageView.superview.center;
    
    //[self.label setText:self.labelText];

    
    [self attachGestureRecognizer];
    
}

- (void) createLabel:(NSString*) text{
    
    
    UIFont * customFont = [UIFont systemFontOfSize:33]; //custom font
    int width = self.view.frame.size.width;
    CGSize labelSize = [text sizeWithFont:customFont constrainedToSize:CGSizeMake(width, 50) lineBreakMode:NSLineBreakByTruncatingTail];
    CGPoint labelPoint = [self getLabelCenter];
    CGRect labelBounds = CGRectMake(0, labelPoint.y, labelSize.width, labelSize.height);
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:labelBounds];

    nameLabel.text = [text capitalizedString];
    nameLabel.font = customFont;
    nameLabel.numberOfLines = 1;
    nameLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters ;
    nameLabel.adjustsFontSizeToFitWidth = YES;
    nameLabel.adjustsLetterSpacingToFitWidth = YES;
    nameLabel.minimumScaleFactor = 10.0f/12.0f;
    nameLabel.clipsToBounds = YES;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.center = labelPoint;
    
    
    [self.view addSubview:nameLabel];
}

- (void)attachGestureRecognizer
{
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                          initWithTarget:self
                                                          action:@selector(handleDoubleTap:)];
    [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:doubleTapGestureRecognizer];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                          initWithTarget:self
                                                          action:@selector(handleSingleTap:)];
    [singleTapGestureRecognizer setNumberOfTapsRequired:1];
    // Wait for failed doubleTapGestureRecognizer
    [singleTapGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
}



- (CGPoint) getLabelCenter{
    CGFloat bottomOfPicture = self.detailImageView.frame.origin.y+ self.detailImageView.frame.size.height;
    CGFloat spaceUnderPicture = self.view.frame.size.height -bottomOfPicture;
    CGFloat newY = bottomOfPicture+ spaceUnderPicture/2;
    CGFloat oldHeight = self.view.frame.size.height;
    CGFloat newX = self.view.center.x;
    CGRect bounds = self.label.frame;
    return  CGPointMake(newX,newY);
}

- (CGSize) getImageSize{
    CGFloat frameSide = MIN(self.view.frame.size.width,self.view.frame.size.height);
    return CGSizeMake(frameSide*0.8, frameSide*0.8);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer {
    // Insert your own code to handle doubletap
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
