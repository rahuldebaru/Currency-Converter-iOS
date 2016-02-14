//
//  SecondViewController.m
//  Sample
//
//  Created by Aru, Rahul on 2/10/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "SecondViewController.h"
#import "MBProgressHUD.h"
#import "NSString+Additions.h"

#define APP_API_KEY     @"f19a35718b874219a252b8c390b15a35"

@interface SecondViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
{


}
@property (strong, nonatomic) NSDictionary* exRate;
@property (strong, nonatomic) NSString* base;
@property (strong, nonatomic) NSString* from;
@property (strong, nonatomic) NSString* to;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerFrom;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerTo;
@property (weak, nonatomic) IBOutlet UITextField *txtFrom;
@property (weak, nonatomic) IBOutlet UITextField *txtTo;
@property (weak, nonatomic) IBOutlet UIButton *btnGo;
@end

@implementation SecondViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self enableUserInput:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.label.text = @"Fetching Exchange Rate...";
    hud.minShowTime = 1;
    
    // TODO: Implement cache storage through Core Data or even plist to store the exchange rate for a day and refresh on a new day
    [self getExchangeRates];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getExchangeRates
{
    NSString *exchangeRateUrl = [NSString stringWithFormat:@"https://openexchangerates.org/api/latest.json?app_id=%@", APP_API_KEY];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:exchangeRateUrl]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
                
                NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                if (httpResp.statusCode == 200) {
                    
                    NSError *jsonError;
                    NSDictionary *notesJSON =
                    [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingAllowFragments
                                                      error:&jsonError];
                    if (jsonError) {
                        NSLog(@"Parsing error = %@", jsonError);
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Could not get exchange rate! Unexpected response from server." preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        [self presentViewController:alertController animated:YES completion:nil];
                        return;
                    }
                    
                    // Process json
                    if([notesJSON objectForKey:@"base"] && [notesJSON objectForKey:@"rates"])
                    {
                        self.base = (NSString*)[notesJSON objectForKey:@"base"];
                        self.exRate = [NSDictionary dictionaryWithDictionary:[notesJSON objectForKey:@"rates"]];
                    }
                    NSLog(@"~~~~ Parsing complete ~~~~\n base = %@ \n %@", self.base, self.exRate);
                    
                    if(self.exRate.count && self.base)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            [self enableUserInput:YES];
                            [self.pickerFrom reloadAllComponents];
                            [self.pickerTo reloadAllComponents];

                            //initialize picker selections
                            self.from =  [[self getCurrencies] objectAtIndex:[self getRowForCurrency:@"INR"]]; //TODO: Map with device locale data to pick default currency];
                            self.to = [[self getCurrencies] objectAtIndex:[self getRowForCurrency:self.base]];
                            [self.pickerFrom selectRow:[self getRowForCurrency:@"INR"] inComponent:0 animated:NO];
                            [self.pickerTo selectRow:[self getRowForCurrency:self.base] inComponent:0 animated:NO];
                        });
                    }
                }
                else
                {
                    NSLog(@"Connection error = %ld", (long)httpResp.statusCode);
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Could not connect to server." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    [self presentViewController:alertController animated:YES completion:nil];
                    return;
                }
                
            }] resume];
}


- (IBAction)didTapGo:(id)sender {
    
    [self.view endEditing:YES];
    
    if(![self.txtFrom.text isDecimal] || ![self.txtTo.text isDecimal])
    {
        NSLog(@"Invalid characters found");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Only decimal values allowed!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }

    if([self.from isEqualToString:self.to])
    {
        NSLog(@"Same Currency, but I don't have any problem with that :)");
    }
    
    
    if(self.txtFrom.text.length)
    {
        double input = [self.txtFrom.text doubleValue];
        double rate = [((NSString*)[self.exRate objectForKey:_to]) doubleValue]/[((NSString*)[self.exRate objectForKey:_from]) doubleValue];
        double output = input*rate;
        self.txtTo.text = [NSString stringWithFormat:@"%.02lf", output];
    }
    else if(self.txtTo.text.length)
    {
        double input = [self.txtTo.text doubleValue];
        double rate = [((NSString*)[self.exRate objectForKey:_from]) doubleValue]/[((NSString*)[self.exRate objectForKey:_to]) doubleValue];
        double output = input*rate;
        self.txtFrom.text = [NSString stringWithFormat:@"%.02lf", output];
    }
}


-(void)enableUserInput:(BOOL)enable
{
    self.txtFrom.enabled = enable;
    self.txtTo.enabled = enable;
    self.pickerFrom.userInteractionEnabled = enable;
    self.pickerTo.userInteractionEnabled = enable;
    self.btnGo.enabled = enable;
}

-(int)getRowForCurrency:(NSString*)cur
{
    int row = 0;
    for(NSString* title in [self getCurrencies])
    {
        if([title.uppercaseString isEqualToString:cur])
            return row;
        else
            row++;
    }
    return 0; //if base currency not found, reset to first currency alphabetically
}

-(NSArray*)getCurrencies
{
    return [[self.exRate allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

#pragma mark - UIPickerViewDataSource & UIPickerViewDelegate

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.exRate.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[self getCurrencies] objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    [self.view endEditing:YES];
    
    if ([pickerView isEqual:self.pickerFrom]) {
        self.from = [[self getCurrencies] objectAtIndex:row];
    } else {
        self.to = [[self getCurrencies] objectAtIndex:row];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.txtFrom.text = @"";
    self.txtTo.text = @"";
    return YES;
}

@end
