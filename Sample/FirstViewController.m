//
//  FirstViewController.m
//  Sample
//
//  Created by Aru, Rahul on 2/10/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "FirstViewController.h"
#import "NSString+Additions.h"

@interface FirstViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtInput;
@property (weak, nonatomic) IBOutlet UILabel *lblPalindrome;
@property (weak, nonatomic) IBOutlet UIButton *btnGo;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapGo:(id)sender {
    
    self.txtInput.text = [self.txtInput.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(!self.txtInput.text.length)
    {
        NSLog(@"Empty input");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please type a number!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    if(![self.txtInput.text isNumeric])
    {
        NSLog(@"Invalid characters found");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Only numeric digis allowed!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    [self.view endEditing:YES];
    self.lblPalindrome.text = [self.txtInput.text findNextPalindrome];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.lblPalindrome.text = @"";
    return YES;
}

@end
