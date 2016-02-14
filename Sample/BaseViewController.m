//
//  BaseViewController.m
//  Sample
//
//  Created by Aru, Rahul on 2/14/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Did not use scrollview, using simple swipe/tap gesture for iPhone keyboard control
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeGesture];
    UISwipeGestureRecognizer *swipeGesture2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeGesture2.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeGesture2];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleSwipeGesture:(UISwipeGestureRecognizer *) sender
{
    //Gesture detect - swipe up/down , can be recognized direction
    if(sender.direction == UISwipeGestureRecognizerDirectionUp || sender.direction == UISwipeGestureRecognizerDirectionDown)
        [self.view endEditing:YES];
}

-(void)handleTapGesture:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

@end
