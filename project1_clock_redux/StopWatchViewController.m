//
//  StopWatchViewController.m
//  Chrono
//
//  Created by Wes Jonas on 9/23/14.
//  Copyright (c) 2014 Wes Jonas. All rights reserved.
//

#import "StopWatchViewController.h"

@implementation StopWatchViewController
{
    bool firstLap;
    bool start;
    NSTimeInterval timeStart;
    NSTimeInterval timeStart2;
    
    NSTimeInterval elapsedTime;
    NSTimeInterval elapsedTime2;
    
    NSTimeInterval timePause;
    NSTimeInterval currentTime;
    NSString       *currentStopWatchTime;
    NSString       *currentLapTime;
    int            lapCount;

}

- (void)viewDidLoad {

    [super viewDidLoad];
    currentStopWatchTime = @"00:00:00";
    currentLapTime = @"00:00:00";
    firstLap = true;
    lapCount = 1;
    lapData = [[NSMutableArray alloc] init];

    start = false;
    
    // Round off our buttons
    self.startButton.layer.cornerRadius = 37;
    self.startButton.clipsToBounds = YES;
    self.resetButton.layer.cornerRadius = 37;
    self.resetButton.clipsToBounds = YES;
    self.stopButton.layer.cornerRadius = 37;
    self.stopButton.clipsToBounds = YES;
    self.lapButton.layer.cornerRadius = 37;
    self.lapButton.clipsToBounds = YES;
    
    // Add bottom border to white label background
    CALayer* layer = [self.backgroundLabel layer];
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.borderColor = [UIColor darkGrayColor].CGColor;
    bottomBorder.borderWidth = 1;
    bottomBorder.frame = CGRectMake(-1, layer.frame.size.height-0, layer.frame.size.width, 1);
    [bottomBorder setBorderColor:[UIColor colorWithRed: 0.755 green: 0.755 blue: 0.755 alpha: .6].CGColor];
    [layer addSublayer:bottomBorder];
}

-(void) update {

    // Check if running or not
    if (start == false) {
        return;
    }
    
    else {

        currentTime = [NSDate timeIntervalSinceReferenceDate];
        if (timePause > 0) {
            
            int timeDiff = (int) (currentTime - timePause);
            
            // Offset time between pause and resume
            timeStart += timeDiff;
            timeStart2 += timeDiff;
            
            timePause = 0;
        }

        elapsedTime = currentTime - timeStart;
        
        // Calc min, sec, de-sec
        int deciseconds = (int)(elapsedTime * 100) % 100;
        int minutes = (int)elapsedTime / 60.0;
        int seconds = (int)elapsedTime - (minutes * 60);

        currentStopWatchTime = [NSString stringWithFormat:@"%02u:%02u:%02u", minutes, seconds, deciseconds];

        if (!firstLap) {
            
            elapsedTime2 = currentTime - timeStart2;
            
            // Calc min, sec, de-sec
            int deciseconds2 = (int)(elapsedTime2 * 100) % 100;
            int minutes2 = (int)elapsedTime2 / 60.0;
            int seconds2 = (int)elapsedTime2 - (minutes2 * 60);
            
            currentLapTime = [NSString stringWithFormat:@"%02u:%02u:%02u", minutes2, seconds2, deciseconds2];
        }
        
        
        // Set timer labels
        self.masterTimer.text   = currentStopWatchTime;
        self.lapTimer.text      = currentLapTime;
        
        // Do again
        [self performSelector:@selector(update) withObject:self afterDelay:0.01]; // Should be 0.01 but that's quite CPU intensive
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)start:(id)sender {
    if (start == false )
    {
        if (!timeStart > 0) {
            timeStart =  [NSDate timeIntervalSinceReferenceDate];
        }
        start = true;
        self.startButton.hidden = YES;
        self.resetButton.hidden = YES;
        [self update];
    }
}

- (IBAction)lap:(id)sender {
    NSArray *lapDataItem;
    if (firstLap == true) {
        lapDataItem = [ NSArray arrayWithObjects:[NSString stringWithFormat:@"Lap %d", lapCount], currentStopWatchTime, nil];
        firstLap = false;
        timeStart2 = [NSDate timeIntervalSinceReferenceDate];
    }
    
    else {
        // For subsequent laps
        timeStart2 = [NSDate timeIntervalSinceReferenceDate];
        lapDataItem = [ NSArray arrayWithObjects:[NSString stringWithFormat:@"Lap %d", lapCount], currentLapTime, nil];
    }
    
    [lapData insertObject:lapDataItem atIndex:0];
    [lapTableView reloadData];
    lapCount++;
}

- (IBAction)reset:(id)sender {
    currentStopWatchTime = @"00:00:00";
    currentLapTime = @"00:00:00";
    firstLap = true;
    timePause = 0;
    timeStart = 0;
    timeStart2 = 0;
    lapCount = 1;
    self.masterTimer.text = currentStopWatchTime;
    self.lapTimer.text = currentLapTime;
    [lapData removeAllObjects];
    [lapTableView reloadData];
    

}

- (IBAction)stop:(id)sender {
    start = false;
    timePause = [NSDate timeIntervalSinceReferenceDate];
    self.startButton.hidden = NO;
    self.resetButton.hidden = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [lapData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LapCell";
    LapCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    
    NSArray *lapDataArray = [lapData objectAtIndex:indexPath.row];
    cell.lapNumberLabel.text = lapDataArray[0];
    cell.timeOutputLabel.text = lapDataArray[1];
    return cell;
}

@end

