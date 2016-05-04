//
//  ViewController.m
//  Address Book Obj-C
//
//  Created by Igor Vilar on 5/2/16.
//  Copyright © 2016 Igor. All rights reserved.
//

#import "ViewController.h"
#import "ContactBook.h"
#import "MySQLiteHelper.h"
#import "ConfigurationSet.h"
#import "ContactTableViewCell.h"
#import "DetailsContactViewController.h"

@interface ViewController ()


@end

static BOOL debugEnable;


@implementation ViewController
@synthesize listViewContacts;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    debugEnable = [ConfigurationSet debugEnable];
    contactsArray = [[NSArray alloc] init];
    [self loadContacts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)AddContact:(id)sender {
    
}

- (void)loadContacts{
    contactsArray = [[MySQLiteHelper sharedInstance] retrieveAllContacts];
    [listViewContacts reloadData];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [contactsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    static NSString *CellIdentifier = @"ContactTableViewCell";;
    
    ContactTableViewCell *cell = (ContactTableViewCell*)[self.listViewContacts dequeueReusableCellWithIdentifier: CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[ContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSInteger linha = indexPath.row;
    cell.nameTitle.text = [[contactsArray objectAtIndex:linha] Name];
    cell.tag = linha;

    return cell;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  //  NSInteger linha = indexPath.row;
    
}

- (void)viewWillAppear:(BOOL)animated {
    // Do any additional setup after loading the view, typically from a nib.
    [self loadContacts];
}


#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSInteger IdTag = [sender tag];
    DetailsContactViewController *transferViewController = segue.destinationViewController;
        if([segue.identifier isEqualToString:@"OpenDetailsContactSegue"])
    {
        transferViewController.idContactSelect = [[contactsArray objectAtIndex:IdTag] IdContact];
    }
    
}

- (NSInteger)numberOfSectionsInTableView: (UITableView *) tableView{
    
    //assuming some_table_data respresent the table data
    if ([contactsArray count] == 0) {
        //create a lable size to fit the Table View
        UILabel *messageLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                        self.listViewContacts.bounds.size.width,
                                                                        self.listViewContacts.bounds.size.height)];
        //set the message
        messageLbl.text = @"Não existe nenhum contato cadastrado";
        
        //center the text
        messageLbl.textAlignment = NSTextAlignmentCenter;
        //auto size the text
        [messageLbl sizeToFit];
        
        //set back to label view
        self.listViewContacts.backgroundView = messageLbl;
        //no separator
        self.listViewContacts.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        return 0;
    }
    self.listViewContacts.backgroundView = nil;

    //number of sections in this table
    return 1;
}
@end
