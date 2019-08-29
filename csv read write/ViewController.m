//
//  ViewController.m
//  csv read write
//
//  Created by Xiongfeng Zhu on 8/27/19.
//  Copyright © 2019 Xiongfeng Zhu. All rights reserved.
//

#import "ViewController.h"
@interface ViewController()<NSTableViewDelegate,NSTableViewDataSource>
- (IBAction)loadcsv:(id)sender;
- (IBAction)writecsv:(id)sender;
@end

@implementation ViewController

{
    NSArray* rows;
    NSArray* col_labels;
    NSMutableArray* dataArray;
    NSURL* url;
    int n_rows;
    int n_cols;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self initData];
    
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


- (IBAction)loadcsv:(id)sender {
    // Create the File Open Dialog class.
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    // Enable the selection of files in the dialog.
    [openDlg setCanChooseFiles:YES];
    
    // Multiple files not allowed
    [openDlg setAllowsMultipleSelection:NO];
    
    // Can't select a directory
    [openDlg setCanChooseDirectories:NO];
    
    // Display the dialog. If the OK button was pressed,
    // process the files.
    if ( [openDlg runModal] == NSModalResponseOK )
    {while([[_displaytable tableColumns] count] > 0) {
        [_displaytable removeTableColumn:[[_displaytable tableColumns] lastObject]];
    }
        // Get an array containing the full filenames of all
        // files and directories selected.
        NSArray* urls = [openDlg URLs];
        url = [urls objectAtIndex:0];
        NSString* fileContents = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        rows = [fileContents componentsSeparatedByString:@"\n"];
        col_labels = [rows[0] componentsSeparatedByString:@","];
        
        //fill dataArray in here
        n_rows = (int)rows.count;
        n_cols = (int)col_labels.count;
        dataArray = [NSMutableArray array];
        for(int i=0; i < n_rows; i++){
            NSMutableArray* rowArray = [NSMutableArray array];
                rowArray = [rows[i] componentsSeparatedByString:@","];
            [dataArray addObject:rowArray];
        }

        for(NSString* col in col_labels){
        NSTableColumn * column = [[NSTableColumn alloc] initWithIdentifier:col];
        NSUInteger i = [col_labels indexOfObject: col];
            [column.headerCell setStringValue: [NSString stringWithFormat:@"Column_%lu", (unsigned long)i]];
        [_displaytable addTableColumn:column];
        }
        }
    [_displaytable reloadData];
    NSLog(@"%@", dataArray[2][3]);
    
}

- (IBAction)writecsv:(id)sender {
    NSString* dir =[url.absoluteString stringByDeletingLastPathComponent];
    NSString *name = [_filename stringValue];
    NSString *newfile = [NSString stringWithFormat:@"%@/%@.csv", dir, name];
    NSLog(@"%@", newfile);
    
    //need create dir first!!
    [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    BOOL create=[[NSFileManager defaultManager] createFileAtPath: newfile contents:nil attributes:nil];
    NSLog(@"%hhd", create);
    //}
    
    NSMutableString *writeString = [NSMutableString stringWithCapacity:0]; //capacity will expand as necessary
    for (int i=0; i<n_rows; i++) {
        for (int j=0; j<n_cols; j++){
            [writeString appendString:[NSString stringWithFormat:@"%@,", dataArray[i][j]]];
        }
        [writeString deleteCharactersInRange:NSMakeRange([writeString length]-1, 1)];//remove one ","
        [writeString appendString:[NSString stringWithFormat:@"\n"]]; //the \n will put a newline in
    }
NSLog(@"%@", writeString);
NSString *immutableString = [NSString stringWithString:writeString];
     NSError *error = nil;
[immutableString writeToFile:newfile atomically:TRUE encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"Fail: %@", [error localizedDescription]);
    }
}



- (void)initData {
    _displaytable.delegate = self;
    _displaytable.dataSource = self;
    [_displaytable reloadData];
    // Do any additional setup after loading the view.
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)displaytable{
    return rows.count;
}

-(id)tableView:(NSTableView *)displaytable objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    NSString *identifier = [tableColumn identifier];
    NSUInteger i = [col_labels indexOfObject: identifier];
    return dataArray[row][i];
}


- (void)tableView:(NSTableView *)displaytable setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
    NSUInteger col_index = [[displaytable tableColumns] indexOfObject:aTableColumn];
    dataArray[rowIndex][col_index] = anObject;
    NSLog(@"%@", anObject);
    [_displaytable reloadData];
    
}


@end

