@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS - For Search Help Carrier IDs'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZVH_CARRIERID as select from /dmo/carrier
{
  @UI.lineItem: [ { position: 10, 
                    label: 'Carrier ID', 
                    importance: #HIGH  } ]
    key carrier_id as CarrierID, 
     @UI.lineItem: [ { position: 20, 
                  label: 'Carrier ID Description', 
                  importance: #HIGH  } ]
    name           as Name
    
}
