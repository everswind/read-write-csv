//
//  ViewController.h
//  csv read write
//
//  Created by Xiongfeng Zhu on 8/27/19.
//  Copyright © 2019 Xiongfeng Zhu. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController
@property (strong) IBOutlet NSScrollView *scroll;
- (IBAction)loadcsv:(id)sender;
- (IBAction)writecsv:(id)sender;
@property (strong) IBOutlet NSTableView *displaytable;
@property (strong) IBOutlet NSTextField *filename;



@end

