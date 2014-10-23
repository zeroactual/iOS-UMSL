//
//  ViewController.m
//  project1_clock
//
//  Created by Wes Jonas on 9/10/14.
//  Copyright (c) 2014 Wes Jonas. All rights reserved.
//

#import "ClockViewController.h"


@interface ClockViewController ()

@end

@implementation ClockViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone]; // Get phone's timezone
    self.timeZone.text = [timeZone name]; // Show it
    [self update]; // Run clock loop forevarrr...
}


-(void) update {
    NSDateFormatter *DateFormatter = [[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"hh:mm:ss"];
    self.digitalClock.text = [DateFormatter stringFromDate:[NSDate date]];
    [self performSelector:@selector(update) withObject:self afterDelay:0.1]; // 1 sec per update
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
