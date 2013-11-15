//
//  WhasaChatViewController.m
//  Whasa_ite1
//
//  Created by chipont on 18/07/13.
//  Copyright (c) 2013 corenetworks. All rights reserved.
//

#import "WhasaChatViewController.h"
#import "SendMessage.h"
#import "ReceiveMessage.h"
#import "Chat.h"

@interface WhasaChatViewController ()

@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;
@property (strong, nonatomic) IBOutlet UITextField *mensaje;
@property (strong, nonatomic) NSMutableArray *conversacionAux;
//@property (strong, nonatomic) IBOutlet UITextView *conversacion;
@property (strong, nonatomic) IBOutlet UITableView *conversacion;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *verContactoBtn;
@property (strong, nonatomic)  NSString* nombreDelContacto;
@property (strong, nonatomic) Chat *chat;
@end
static CGFloat espacio = 20.0;
@implementation WhasaChatViewController


//Métodos de delegacion de UITableView: UITableViewDataSource y UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UILabel *infoLabel;
    UITextView *messageTextView;
    
    id message = (Message *) [_conversacionAux objectAtIndex:indexPath.row];
    static NSString *cellIdentifier = @"messageCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell != nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
        
    }
    
    //Configuracion del label con la información del mensaje(emisor y fecha)
    infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 20)];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.font = [UIFont systemFontOfSize:13.0];
    infoLabel.textColor = [UIColor lightGrayColor];
    infoLabel.backgroundColor =[UIColor clearColor];
    infoLabel.text = [NSString stringWithFormat:@"%@:%@", [message time], [message from] ];

    [cell.contentView addSubview: infoLabel];

    //Configuracion del textview con el mensaje
    messageTextView = [[UITextView alloc] init];
    messageTextView.editable = NO;
    messageTextView.scrollEnabled = NO;
    messageTextView.text = [message message];
    messageTextView.font = [UIFont systemFontOfSize:14.0];
    messageTextView.textAlignment = NSTextAlignmentLeft;
    messageTextView.layer.cornerRadius = 8;
    [messageTextView sizeToFit];

    //Calculo de tamaños y limites
    CGSize size = [[message message] sizeWithFont:[UIFont boldSystemFontOfSize:14]
           constrainedToSize:CGSizeMake(260.0, 10000.0)
               lineBreakMode:NSLineBreakByCharWrapping];
    size = CGSizeMake(size.width+1, size.height - 1);

    //Ancho más Espacio
    size.width += espacio;
    
    messageTextView.text = [message message];
    
    if ([[message from] isEqualToString:_nick]) { // sent messages
        [messageTextView setFrame:CGRectMake(cell.frame.size.width - size.width, espacio + 5, size.width, size.height + espacio)];
        messageTextView.backgroundColor = [UIColor colorWithHue: 0.9
                                              saturation: 0.8
                                              brightness: 0.8
                                                   alpha: 0.9];

    } else {
        [messageTextView setFrame:CGRectMake(infoLabel.frame.origin.x - espacio/2, infoLabel.frame.origin.y + infoLabel.frame.size.height - 5, size.width, size.height * 2)];
        messageTextView.backgroundColor = [UIColor colorWithHue: 0.3
                                              saturation: 0.7
                                              brightness: 0.7
                                                   alpha: 0.9];
    }
    [cell.contentView addSubview: messageTextView];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.userInteractionEnabled = NO;

    //Actualizar el scroll
    [_conversacion scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    return cell;
}
//Callback llamado para ajustar los tamaños del ancho de la celda
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	id message = [_conversacionAux objectAtIndex:indexPath.row];
    
	CGSize  textSize = { 260.0, 10000.0 };
	CGSize size = [[message message] sizeWithFont:[UIFont boldSystemFontOfSize:14]
				  constrainedToSize:textSize
					  lineBreakMode:NSLineBreakByWordWrapping];
    size = CGSizeMake(size.width+1, size.height);
    
	size.height += (espacio+5) * 2;
    
	CGFloat height = size.height < 65 ? 65 : size.height;
	return height;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_conversacionAux count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


//Callback del boton
- (IBAction)enviarMensaje:(id)sender {
    //[_conversacionAux appendFormat:@"\n%@:%@", _nick, _mensaje.text];
    //_conversacion.text = _conversacionAux.description;
    
    SendMessage *message = [[SendMessage alloc] initWithData:_mensaje.text from:_nick to:_nombreDelContacto];
    [_chat sendMessage:message];

    [_conversacionAux addObject:message];
    [_conversacion reloadData];
    
    _mensaje.text = @"";    

}

//callbacks de la vista
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
   [super viewDidLoad];
    
    
    NSString* name = [NSString stringWithFormat:@"%@ %@", ((__bridge_transfer NSString*) ABRecordCopyValue(_contacto,kABPersonFirstNameProperty)), ((__bridge_transfer NSString*)ABRecordCopyValue(_contacto,                                                                     kABPersonLastNameProperty))];
    
	_navItem.prompt = [NSString stringWithFormat:@"Hablando con %@", name];
    
    if (!_conversacionAux)
        _conversacionAux = [[NSMutableArray alloc]init];
    
    _chat = [[Chat alloc] initWithRegisterController:nil from:_nick];
    
    _nombreDelContacto = (__bridge_transfer NSString*)ABRecordCopyValue(_contacto,                                                                    kABPersonFirstNameProperty);
    //Imagen del fondo del chat
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"fondo.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    //Configuracion de la tabla
    _conversacion.separatorStyle = UITableViewCellSeparatorStyleNone;
    _conversacion.backgroundColor = [[UIColor alloc] initWithWhite:1 alpha:0.0]; //tabla transparente    
    
    //Registro del modelo
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (updateConversacion:) name:@"ReceivedData" object:nil];
}

//Callbacks del teclado y caja de texto
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    [self enviarMensaje:nil];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 216;
    const float movementDuration = 0.3f; 
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}


//Método de actualizacion por parte del modelo
- (void) updateConversacion:  (NSNotification *) notification //Array de ReceiveMessage(s)
{
    for (ReceiveMessage *rMessage in notification.object) {
        //[_conversacionAux appendFormat:@"\n%@:%@", rMessage.from, rMessage.message];
        [_conversacionAux addObject:rMessage];
        //_conversacion.text = _conversacionAux.description;
        [_conversacion reloadData];
    }
}

@end
