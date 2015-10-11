//
//  temperaturedetailTableViewController.m
//  SensorApplication
//
//  Created by Meixiang Jin on 1/24/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import "temperaturedetailTableViewController.h"
@interface temperaturedetailTableViewController ()

@end

@implementation temperaturedetailTableViewController

@synthesize d;
@synthesize ambientTemp;
@synthesize sensorsEnabled;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}


-(id) initWithStyle:(UITableViewStyle)style andSensorTag:(BLEDevice *)andSensorTag {
    self = [super initWithStyle:style];
    if (self) {
        self.d = andSensorTag;
        if (!self.ambientTemp){
            self.ambientTemp = [[temperatureCellTemplate alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Ambient temperature"];
            self.ambientTemp.temperatureIcon.image = [UIImage imageNamed:@"temperature.png"];
            self.ambientTemp.temperatureLabel.text = @"Ambient Temperature";
            self.ambientTemp.temperature.text = @"-.-°C";
        }
//        if (!self.irTemp) {
//            self.irTemp = [[temperatureCellTemplate alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IR temperature"];
//            self.irTemp.temperatureIcon.image = [UIImage imageNamed:@"objecttemperature.png"];
//            self.irTemp.temperatureLabel.text = @"Object Temperature";
//            self.irTemp.temperature.text = @"-.-°C";
//        }
//        if (!self.acc) {
//            self.acc = [[accelerometerCellTemplate alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Accelerometer"];
//            self.acc.accLabel.text = @"Accelerometer";
//            self.acc.accValueX.text = @"-";
//            self.acc.accValueY.text = @"-";
//            self.acc.accValueZ.text = @"-";
//            self.acc.accCalibrateButton.hidden = YES;
//        }
        if (!self.rH) {
            self.rH = [[temperatureCellTemplate alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Relative humidity"];
            self.rH.temperatureIcon.image = [UIImage imageNamed:@"relativehumidity.png"];
            self.rH.temperatureLabel.text = @"Relative humidity";
            self.rH.temperature.text = @"-%rH";
        }
        
    }
    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(alphaFader:) userInfo:nil repeats:YES];
    
    self.currentVal = [[sensorTagValues alloc]init];
    self.vals = [[NSMutableArray alloc]init];
    
    self.logInterval = 1.0; //1000 ms
    
    self.logTimer = [NSTimer scheduledTimerWithTimeInterval:self.logInterval target:self selector:@selector(logValues:) userInfo:nil repeats:YES];
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    self.sensorsEnabled = [[NSMutableArray alloc] init];
    if (!self.d.p.isConnected) {
        self.d.manager.delegate = self;
        [self.d.manager connectPeripheral:self.d.p options:nil];
    }
    else {
        self.d.p.delegate = self;
        [self configureSensorTag];
        self.title = @"TI BLE Sensor Tag application";
    }
}


-(void)viewWillDisappear:(BOOL)animated {
    [self deconfigureSensorTag];
    
}

-(void)viewDidDisappear:(BOOL)animated {
    self.sensorsEnabled = nil;
    self.d.manager.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *mailer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(use:)];
    
    [self.navigationItem setRightBarButtonItem:mailer];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellType = [self.sensorsEnabled objectAtIndex:indexPath.row];
    
    if ([cellType isEqualToString:@"Ambient temperature"]) return self.ambientTemp.height;
 //   if ([cellType isEqualToString:@"IR temperature"]) return self.irTemp.height;
 //   if ([cellType isEqualToString:@"Accelerometer"]) return self.acc.height;
    if ([cellType isEqualToString:@"Humidity"]) return self.rH.height;
    
    return 50;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Sensors";
    }
    return @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int number=self.sensorsEnabled.count;
    return number;
    // return self.sensorsEnabled.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellType = [self.sensorsEnabled objectAtIndex:indexPath.row];
    // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if ([cellType isEqualToString:@"Ambient temperature"]) {
        
        return self.ambientTemp;
    }
//    else if ([cellType isEqualToString:@"IR temperature"]) {
//        return self.irTemp;
//    }
//    else if ([cellType isEqualToString:@"Accelerometer"]) {
//        return self.acc;
//    }
    else if ([cellType isEqualToString:@"Humidity"]) {
        return self.rH;
    }
    return [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Unkown Cell"];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void) configureSensorTag {
    
    if (([self sensorEnabled:@"Ambient temperature active"]) || ([self sensorEnabled:@"IR temperature active"])) {
        
        CBUUID *sUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"IR temperature service UUID"]];
        CBUUID *cUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"IR temperature config UUID"]];
        uint8_t data = 0x01;
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"IR temperature data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:YES];
        
        if ([self sensorEnabled:@"Ambient temperature active"]) [self.sensorsEnabled addObject:@"Ambient temperature"];
//        if ([self sensorEnabled:@"IR temperature active"]) [self.sensorsEnabled addObject:@"IR temperature"];
        
    }
    
//    if ([self sensorEnabled:@"Accelerometer active"]) {
//        CBUUID *sUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Accelerometer service UUID"]];
//        CBUUID *cUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Accelerometer config UUID"]];
//        CBUUID *pUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Accelerometer period UUID"]];
//        NSInteger period = [[self.d.setupData valueForKey:@"Accelerometer period"] integerValue];
//        uint8_t periodData = (uint8_t)(period / 10);
//        NSLog(@"%d",periodData);
//        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:pUUID data:[NSData dataWithBytes:&periodData length:1]];
//        uint8_t data = 0x01;
//        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
//        cUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Accelerometer data UUID"]];
//        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:YES];
//        [self.sensorsEnabled addObject:@"Accelerometer"];
//    }
//    
    if ([self sensorEnabled:@"Humidity active"]) {
        CBUUID *sUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Humidity service UUID"]];
        CBUUID *cUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Humidity config UUID"]];
        uint8_t data = 0x01;
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Humidity data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:YES];
        [self.sensorsEnabled addObject:@"Humidity"];
    }
    
    
}

-(void) deconfigureSensorTag {
    if (([self sensorEnabled:@"Ambient temperature active"]) || ([self sensorEnabled:@"IR temperature active"])) {
        
        CBUUID *sUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"IR temperature service UUID"]];
        CBUUID *cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"IR temperature config UUID"]];
        unsigned char data = 0x00;
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"IR temperature data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:NO];
    }
//    if ([self sensorEnabled:@"Accelerometer active"]) {
//        CBUUID *sUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Accelerometer service UUID"]];
//        CBUUID *cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Accelerometer config UUID"]];
//        uint8_t data = 0x00;
//        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
//        cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Accelerometer data UUID"]];
//        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:NO];
//    }
    if ([self sensorEnabled:@"Humidity active"]) {
        CBUUID *sUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Humidity service UUID"]];
        CBUUID *cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Humidity config UUID"]];
        uint8_t data = 0x00;
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Humidity data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:NO];
    }
}

-(bool)sensorEnabled:(NSString *)Sensor {
    NSString *val = [self.d.setupData valueForKey:Sensor];
    if (val) {
        if ([val isEqualToString:@"1"]) return TRUE;
    }
    return FALSE;
}

-(int)sensorPeriod:(NSString *)Sensor {
    NSString *val = [self.d.setupData valueForKey:Sensor];
    return [val integerValue];
}



#pragma mark - CBCentralManager delegate function

-(void) centralManagerDidUpdateState:(CBCentralManager *)central {
    
}

-(void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
}


#pragma mark - CBperipheral delegate functions

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    NSLog(@"..");
    if ([service.UUID isEqual:[CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Gyroscope service UUID"]]]) {
        [self configureSensorTag];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    NSLog(@".");
    for (CBService *s in peripheral.services) [peripheral discoverCharacteristics:nil forService:s];
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"didUpdateNotificationStateForCharacteristic %@, error = %@",characteristic.UUID, error);
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:[self.d.setupData valueForKey:@"IR temperature data UUID"]]]) {
        float tAmb = [sensorTMP006 calcTAmb:characteristic.value];
//        float tObj = [sensorTMP006 calcTObj:characteristic.value];
        
        self.ambientTemp.temperature.text = [NSString stringWithFormat:@"%.1f°C",tAmb];
        self.ambientTemp.temperature.textColor = [UIColor blackColor];
        self.ambientTemp.temperatureGraph.progress = (tAmb / 100.0) + 0.5;
//        self.irTemp.temperature.text = [NSString stringWithFormat:@"%.1f°C",tObj];
//        self.irTemp.temperatureGraph.progress = (tObj / 1000.0) + 0.5;
//        self.irTemp.temperature.textColor = [UIColor blackColor];
        
        self.currentVal.tAmb = tAmb;
//        self.currentVal.tIR = tObj;
        
        
    }
    
    
//    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Accelerometer data UUID"]]]) {
//        float x = [sensorKXTJ9 calcXValue:characteristic.value];
//        float y = [sensorKXTJ9 calcYValue:characteristic.value];
//        float z = [sensorKXTJ9 calcZValue:characteristic.value];
//        
//        self.acc.accValueX.text = [NSString stringWithFormat:@"X: % 0.1fG",x];
//        self.acc.accValueY.text = [NSString stringWithFormat:@"Y: % 0.1fG",y];
//        self.acc.accValueZ.text = [NSString stringWithFormat:@"Z: % 0.1fG",z];
//        
//        self.acc.accValueX.textColor = [UIColor blackColor];
//        self.acc.accValueY.textColor = [UIColor blackColor];
//        self.acc.accValueZ.textColor = [UIColor blackColor];
//        
//        self.acc.accGraphX.progress = (x / [sensorKXTJ9 getRange]) + 0.5;
//        self.acc.accGraphY.progress = (y / [sensorKXTJ9 getRange]) + 0.5;
//        self.acc.accGraphZ.progress = (z / [sensorKXTJ9 getRange]) + 0.5;
//        
//        self.currentVal.accX = x;
//        self.currentVal.accY = y;
//        self.currentVal.accZ = z;
//        
//    }
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Humidity data UUID"]]]) {
        
        float rHVal = [sensorSHT21 calcPress:characteristic.value];
        self.rH.temperature.text = [NSString stringWithFormat:@"%0.1f%%rH",rHVal];
        self.rH.temperatureGraph.progress = (rHVal / 100);
        self.rH.temperature.textColor = [UIColor blackColor];
        
        self.currentVal.humidity = rHVal;
        
    }
    
    [self.tableView reloadData];
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"didWriteValueForCharacteristic %@ error = %@",characteristic.UUID,error);
}



- (IBAction) handleCalibrateMag {
    NSLog(@"Calibrate magnetometer pressed !");
    [self.magSensor calibrate];
}
- (IBAction) handleCalibrateGyro {
    NSLog(@"Calibrate gyroscope pressed ! ");
    [self.gyroSensor calibrate];
}

-(void) alphaFader:(NSTimer *)timer {
    CGFloat w,a;
    if (self.ambientTemp) {
        [self.ambientTemp.temperature.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.ambientTemp.temperature.textColor = [self.ambientTemp.temperature.textColor colorWithAlphaComponent:a];
    }
//    if (self.irTemp) {
//        [self.irTemp.temperature.textColor getWhite:&w alpha:&a];
//        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
//        self.irTemp.temperature.textColor = [self.irTemp.temperature.textColor colorWithAlphaComponent:a];
//    }
//    if (self.acc) {
//        [self.acc.accValueX.textColor getWhite:&w alpha:&a];
//        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
//        self.acc.accValueX.textColor = [self.acc.accValueX.textColor colorWithAlphaComponent:a];
//        
//        [self.acc.accValueY.textColor getWhite:&w alpha:&a];
//        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
//        self.acc.accValueY.textColor = [self.acc.accValueY.textColor colorWithAlphaComponent:a];
//        
//        [self.acc.accValueZ.textColor getWhite:&w alpha:&a];
//        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
//        self.acc.accValueZ.textColor = [self.acc.accValueZ.textColor colorWithAlphaComponent:a];
//    }
    if (self.rH) {
        [self.rH.temperature.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.rH.temperature.textColor = [self.rH.temperature.textColor colorWithAlphaComponent:a];
    }
}


-(void) logValues:(NSTimer *)timer {
    NSString *date = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                    dateStyle:NSDateFormatterShortStyle
                                                    timeStyle:NSDateFormatterMediumStyle];
    self.currentVal.timeStamp = date;
    sensorTagValues *newVal = [[sensorTagValues alloc]init];
    newVal.tAmb = self.currentVal.tAmb;
    newVal.tIR = self.currentVal.tIR;
    newVal.accX = self.currentVal.accX;
    newVal.accY = self.currentVal.accY;
    newVal.accZ = self.currentVal.accZ;
    newVal.humidity = self.currentVal.humidity;
    newVal.timeStamp = date;
    
    [self.vals addObject:newVal];
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    NSLog(@"Finished with result : %u error : %@",result,error);
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)use:(id)sender {
    
    UIStoryboard *str = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UploadParkingViewController *uploadparking = [str instantiateViewControllerWithIdentifier:@"uploadparking"];
    uploadparking.uid=self.uid;
    uploadparking.tem=self.ambientTemp.temperature.text;
    uploadparking.hum=self.rH.temperature.text;
    uploadparking.panduan=@"YES";
    [self presentViewController: uploadparking animated: YES completion: nil];//到达别的viewcontroller
    
}
@end
