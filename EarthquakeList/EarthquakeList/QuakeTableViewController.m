//
//  QuakeTableViewController.m
//  EarthquakeList
//
//  Created by Pomme on 10/6/16.
//  Copyright © 2016 Yuanjie Xie. All rights reserved.
//

#import "QuakeTableViewController.h"


@interface QuakeTableViewController ()

@property (strong, nonatomic) NSMutableArray *quakeArray;
@property (strong, nonatomic) NSDictionary *propertiesDic;
@end

@implementation QuakeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    //NSLog(@"%@", filePath);
    //NSData *quakedata = [NSData dataWithContentsOfFile: filePath];
    
    NSURL *url = [NSURL URLWithString:@"http://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=2016-01-01&minmag=5&limit=15"];
    NSData *quakedata = [NSData dataWithContentsOfURL:url options:kNilOptions error:nil];
    
    NSDictionary *main = [NSJSONSerialization JSONObjectWithData:quakedata options:NSJSONReadingAllowFragments error:nil];
    self.quakeArray = [main objectForKey:@"features"];
    
    
    
    NSLog(@"All data: %lu", (unsigned long)[self.quakeArray count]);
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.quakeArray count];
}


- (NSString *)dateFormatter:(NSNumber *)dateNumber {
    // Get time interval unit from ms to s
    NSTimeInterval interval = [dateNumber doubleValue] / 1000;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterMediumStyle;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSString *dateString = [dateFormatter stringFromDate:date];
  return dateString;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];

    NSDictionary *quakeDic = [self.quakeArray objectAtIndex:indexPath.row];
    self.propertiesDic = [quakeDic objectForKey:@"properties"];
    //NSString *place = [self.propertiesDic objectForKey:@"place"];
    NSString *title = [self.propertiesDic objectForKey:@"title"];
    cell.textLabel.text = title;
    cell.textLabel.numberOfLines = 0;
    
    NSNumber *dateNumber = [self.propertiesDic objectForKey:@"time"];
    NSString *dateString;
    dateString = [self dateFormatter:dateNumber];
    NSLog(@"\n\n\n%@", dateString);
    cell.detailTextLabel.text = dateString;
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *urlString = [self.propertiesDic objectForKey:@"url"];
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    SVModalWebViewController *webVC = [[SVModalWebViewController alloc]initWithAddress:urlString];
    
    [self presentViewController:webVC animated:YES completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
    
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"EarthQuake List";
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
