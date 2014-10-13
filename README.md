#NFJTableViewSectionController

NFJTableViewSectionController manages sections of tableView easily.
You can open or close sections programmatically or tapping section header views.

![demo](https://raw.githubusercontent.com/naokif/NFJTableViewSectionController/develop/demo.gif)

##Usage
(see sample Xcode project in ```/Demo```)

####1.Implement NFJTableViewSectionControllerDataSource methods

```objc
- (NSInteger)numberOfSectionsInSectionController:(NFJTableViewSectionController *)controller;
- (NSInteger)sectionController:(NFJTableViewSectionController *)controller numberOfObjectsInSection:(NSInteger)section;
- (id)sectionController:(NFJTableViewSectionController *)controller objectAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)sectionController:(NFJTableViewSectionController *)controller isOpenedSection:(NSInteger)section;
```


####2.Implement UITableViewDataSource methods

```objc
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NFJTableViewSectionInfo *info = _sectionController.sections[section];
    return info.numberOfObjects;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    Group *g = _groups[section];
    NFJTableViewSectionHeaderView *view = [_sectionController headerViewForSection:section];
    view.titleLabel.text = g.name;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.f;
}
```


####3.Initialize a controller and set dataSource and delegate.

```objc
// viewDidLoad:
NFJTableViewSectionController *controller = [[NFJTableViewSectionController alloc] initWithTableView:self.tableView];
controller.dataSource = self;
controller.delegate   = self;
self.sectionController = controller;
[controller reloadData];
```

After calling ```[_sectionController reloadData]```, you should call ```[self.tableView reloadData]```.
But you don't need to call it peculiarly when you call ```[_sectionController reloadData]``` in ```viewDidLoad:```.
```[self.tableView reloadData]``` will be called by UITableViewController or you after ```viewDidLoad:```.


##Delegate Methods
All delegate methods are optional

```objc
- (BOOL)sectionController:(NFJTableViewSectionController *)controller shouldCloseSection:(NSInteger)section;
- (BOOL)sectionController:(NFJTableViewSectionController *)controller shouldOpenSection:(NSInteger)section;
- (void)sectionController:(NFJTableViewSectionController *)controller willCloseSection:(NSInteger)section;
- (void)sectionController:(NFJTableViewSectionController *)controller didCloseSection:(NSInteger)section;
- (void)sectionController:(NFJTableViewSectionController *)controller willOpenSection:(NSInteger)section;
- (void)sectionController:(NFJTableViewSectionController *)controller didOpenSection:(NSInteger)section;
```

##Open and Close Sections

```objc
- (void)openSection:(NSInteger)section;
- (void)closeSection:(NSInteger)section;
```