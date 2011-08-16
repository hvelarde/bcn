//
//  ListadoPublicaciones.m
//  BCN
//
//  Created by Claudio Horvilleur on 8/9/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import "ListadoPublicaciones.h"
#import "TitleCell.h"
#import "SimpleCell.h"
#import "CommonConstants.h"
#import "PublicacionesDataManager.h"
#import "MyTableViewController.h"

#pragma mark - Private Interface

@interface ListadoPublicaciones()

-(NSString*)labelForSection:(NSInteger)section row:(NSInteger)row;
-(NSInteger)categoryPageForSection:(NSInteger)section row:(NSInteger)row;

@end

#pragma mark - Implementation

@implementation ListadoPublicaciones

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 1:
            return NSLocalizedString(@"titulo_mensual", @"Titulo  Publicaciones Mensuales");
        case 2:
            return NSLocalizedString(@"titulo_trimestral", @"Titulo  Publicaciones Trimestrales");
        case 3:
            return NSLocalizedString(@"titulo_anual", @"Titulo  Publicaciones Anuales");
        case 4:
            return NSLocalizedString(@"titulo_eventual", @"Titulo  Publicaciones Eventuales");
        default:
            return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 6;
        case 2:
            return 8;
        case 3:
            return 2;
        case 4:
            return 4;
        default:
            return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        TitleCell* cell = (TitleCell*)[tv dequeueReusableCellWithIdentifier:TITLE_CELL_IDENTIFIER];
        if (cell == nil) {
            cell = [TitleCell create];
        }
        [cell defineTitle:NSLocalizedString(@"publicaciones", @"Titulo de la pagina listado de publicaciones")];
        return cell;
    }
    SimpleCell* cell = (SimpleCell*) [tv dequeueReusableCellWithIdentifier:SIMPLE_CELL_IDENTIFIER];
    if (cell == nil) {
        cell = [SimpleCell create];
    }
    [cell defineContent:[self labelForSection:section row:row]];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0) {
        [tv deselectRowAtIndexPath:indexPath animated:NO];
        return;
    }
    PublicacionesDataManager* dataManager = [[PublicacionesDataManager alloc] init];
    dataManager.model = model;
    dataManager.pagina = [self categoryPageForSection:section row:row];
    dataManager.tituloLista = [self labelForSection:section row:row];
    MyTableViewController* mvc = [MyTableViewController createWithDataManager:dataManager];
    [dataManager release];
    [navigationController pushViewController:mvc animated:YES];
    [tv deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Labels and constants

-(NSString*)labelForSection:(NSInteger)section row:(NSInteger)row {
    switch (section) {
        case 1:
            switch(row) {
                case 0:
                    return NSLocalizedString(@"etiqueta_informemonetario", @"Informe Monterio Financiero");
                case 1:
                    return NSLocalizedString(@"etiqueta_inflacion", @"Inflación");
                case 2:
                    return NSLocalizedString(@"etiqueta_imae", @"Imae");
                case 3:
                    return NSLocalizedString(@"etiqueta_pconstruccion", @"Indice de Precios de Materiales de Construccion");
                case 4:
                    return NSLocalizedString(@"etiqueta_fiscal", @"Fiscal");
                case 5:
                    return NSLocalizedString(@"etiqueta_sectorexterno", @"Sector Externo");
            }
        case 2:
            switch(row) {
                case 0:
                    return NSLocalizedString(@"etiqueta_boletineconomico", @"Boletin Económico");
                case 1:
                    return NSLocalizedString(@"etiqueta_boletinfinanciero", @"Boletin Financiero");
                case 2:
                    return NSLocalizedString(@"etiqueta_finanzasublicas", @"Finanzas Públicas");
                case 3:
                    return NSLocalizedString(@"etiqueta_construccionprivada", @"Construccion Privada");
                case 4:
                    return NSLocalizedString(@"etiqueta_deudapublica", @"Deuda Pública");
                case 5:
                    return NSLocalizedString(@"etiqueta_deudaexterna", @"Deuda Externa privada");
                case 6:
                    return NSLocalizedString(@"etiqueta_cuentasnacionales", @"Cuentas nacionales trimestrales");
                case 7:
                    return NSLocalizedString(@"etiqueta_balanzapagos", @"Balanza de pagos");
            }
        case 3:
            switch(row) {
                case 0:
                    return NSLocalizedString(@"etiqueta_informeanual", @"Informe Anual");
                case 1:
                    return NSLocalizedString(@"etiqueta_deudaanual", @"Deuda Anual");
            }
        case 4:
            switch(row) {
                case 0:
                    return NSLocalizedString(@"etiqueta_metodologias", @"Metodologias");
                case 1:
                    return NSLocalizedString(@"etiqueta_investigaciones", @"Investigaciones");
                case 2:
                    return NSLocalizedString(@"etiqueta_informesespeciales", @"Informes Especiales");
                case 3:
                    return NSLocalizedString(@"etiqueta_acuerdosinternacionales", @"Acuerdos Internacionales");
            }
    }
    return nil;
}

-(NSInteger)categoryPageForSection:(NSInteger)section row:(NSInteger)row {
    switch (section) {
        case 1:
            switch(row) {
                case 0:
                    return PAGINA_informemonetario;
                case 1:
                    return PAGINA_inflacion;
                case 2:
                    return PAGINA_imae;
                case 3:
                    return PAGINA_pconstruccion;
                case 4:
                    return PAGINA_fiscal;
                case 5:
                    return PAGINA_sectorexterno;
            }
        case 2:
            switch(row) {
                case 0:
                    return PAGINA_boletineconomico;
                case 1:
                    return PAGINA_boletinfinanciero;
                case 2:
                    return PAGINA_finanzasublicas;
                case 3:
                    return PAGINA_construccionprivada;
                case 4:
                    return PAGINA_deudapublica;
                case 5:
                    return PAGINA_deudaexterna;
                case 6:
                    return PAGINA_cuentasnacionales;
                case 7:
                    return PAGINA_balanzapagos;
            }
        case 3:
            switch(row) {
                case 0:
                    return PAGINA_informeanual;
                case 1:
                    return PAGINA_deudaanual;
            }
        case 4:
            switch(row) {
                case 0:
                    return PAGINA_metodologias;
                case 1:
                    return PAGINA_investigaciones;
                case 2:
                    return PAGINA_informesespeciales;
                case 3:
                    return PAGINA_acuerdosinternacionales;
            }
    }
    return PAGINA_DOCUMENTOS;
}

#pragma mark - Data Management

-(void)updateData {
    // Esta es una lista fija, no requiere actualizaciones.
}


@end
