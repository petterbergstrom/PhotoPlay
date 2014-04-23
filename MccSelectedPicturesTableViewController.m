//
//  MccSelectedPicturesTableViewController.m
//  Memory
//
//  Created by Petter Bergström on 2014-03-24.
//  Copyright (c) 2014 McCoy. All rights reserved.
//

#import "MccSelectedPicturesTableViewController.h"
#import "MccMemoryCardDAO.h"
#import "MccCardListTableViewCell.h"

@interface MccSelectedPicturesTableViewController ()
@property NSArray *allCards;
@property MccMemoryCard *cardToBeAdded;

@end

@implementation MccSelectedPicturesTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadCards];

}

- (void) loadCards
{
    MccMemoryCardDAO * dao = [MccMemoryCardDAO sharedSingleton];
    self.allCards  = [dao getAllCards];
}


# pragma mark  - Alert Implementation (for image nameing)
- (void) showTextInput{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Edit card name" message:@"Please name the card" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok",nil ];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeAlphabet;
    alertTextField.placeholder = @"Name of card";
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    MccMemoryCardDAO *dao = [MccMemoryCardDAO sharedSingleton];
    NSLog(@"Entered: %@",[[alertView textFieldAtIndex:0] text]);

    
    NSString *name =[[alertView textFieldAtIndex:0] text];
    
    [dao insertCard:name image:self.cardToBeAdded.image];
    
    [self loadCards]; //refresh local model.
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.allCards.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

#pragma mark Image Picker implementation

- (IBAction)addPhoto:(id)sender {
    
    UIImagePickerController *imagePicker =
    [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }

    
    imagePicker.allowsEditing = NO;
    
    [self presentViewController:imagePicker
                       animated:YES completion:nil];
}



-(void)imagePickerController:
(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self showTextInput];

    self.cardToBeAdded = [MccMemoryCard alloc];
    self.cardToBeAdded.image = [self makeSquare:image];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)imagePickerControllerDidCancel:
(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.allCards count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ImageCell";
    MccCardListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    long row = [indexPath row];
    MemoryCard *card = self.allCards[row];
    MccMemoryCard *memoryCard  = [MccMemoryCardDAO convertToMccMemoryCard:card];
    cell.thumbnail.image = memoryCard.image;
    cell.label.text = memoryCard.label;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
 */


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        long row = [indexPath row];
        MemoryCard *cardToDelete = self.allCards[row];
        MccMemoryCardDAO *dao = [MccMemoryCardDAO sharedSingleton];
        [dao deleteCard:cardToDelete];
        [self loadCards];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    /*
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    } */  
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - Helpers
-(UIImage *) makeSquare: (UIImage*)original{
    CGFloat withHeight = MAX(original.size.width, original.size.height);
    
    CGSize newSize = CGSizeMake(withHeight,withHeight);
    UIGraphicsBeginImageContext(newSize);
    
    //Draw Background
    CGContextSetRGBFillColor(UIGraphicsGetCurrentContext(), 0, 0, 0, 0);
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,0,withHeight,withHeight));
    //Draw image
    CGFloat offsetWidth = (withHeight - original.size.width)/2;
    CGFloat offsetHeight = (withHeight - original.size.height)/2;
    CGRect rect = CGRectMake(offsetWidth, offsetHeight, original.size.width, original.size.height);
    [original drawInRect:rect];
    
    //Create Image
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  finalImage;
    
}


@end
