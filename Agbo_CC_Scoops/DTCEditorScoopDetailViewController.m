//
//  DTCEditorScoopDetailViewController.m
//  Agbo_CC_Scoops
//
//  Created by David de Tena on 30/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import "DTCEditorScoopDetailViewController.h"
#import "DTCScoop.h"

@interface DTCEditorScoopDetailViewController ()

@end

@implementation DTCEditorScoopDetailViewController


#pragma mark - Init
-(id) initWithModel:(DTCScoop *) model{
    if (self = [super init]) {
        _model = model;
        self.title = model.title;
    }
    return self;
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self configureUI];
}



#pragma mark - Memory
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UI

-(void) configureUI{
    self.titleLabel.text = self.model.title;
    self.textView.text = self.model.text;
    
    // Image
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width/2;
    self.imageView.clipsToBounds = YES;
    
    //[self performSelector:@selector(displayImage) withObject:self afterDelay:0.7];
    
    // Rating
}


-(void) displayImage{
    self.imageView.image = [UIImage imageWithData:self.model.image];
}



@end
