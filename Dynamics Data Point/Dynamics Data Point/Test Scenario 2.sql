/** [dbo].[InvoiceHeader] */
SELECT invGp.invoicegroupnumber AS Invoice_Number,
  trnBillAdd.label AS Site_Label,
  DATEFROMPARTS(
    year(invGp.trandate),
    month(invGp.trandate),
    '01'
  ) AS Invoice_Start_Date,
  CONVERT(varchar, EOMONTH(invGp.trandate), 120) AS Invoice_End_Date,
  trnBillAdd.label AS Site_Recipient,
  trnBillAddEnt.addressee AS Site_Name,
  trnBillAddEnt.addrtext AS Site_Address,
  trnBillAddEnt.zip AS Site_Zip_Code,
  trnBillAddEnt.city AS Site_City,
  trnBillAddEnt.state AS Site_State,
  invGp.total AS Invoice_Total,
  invGp.duedate AS Invoice_Due_Date,
  invGp.trandate AS Date_Invoice_First_Generated,
  'createdby' AS CreatedBy,
  'createddate' AS CreatedDate,
  CONCAT(emp.firstname, CONCAT(' ', emp.lastname)) AS LastModifiedBy,
  invGp.lastmodifieddate AS LastModifiedDate
FROM [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[InvoiceGroup] AS invGp
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[transactionBillingAddressbook] AS trnBillAdd ON trnBillAdd.internalid = invGp.billaddresslist
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[transactionBillingAddressbookEntityAddress] AS trnBillAddEnt ON trnBillAddEnt.nkey = trnBillAdd.addressbookaddress
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[entity] AS emp ON emp.id = invGp.lastmodifiedby
WHERE invGp.invoicegroupnumber = 'IG-000002'
/** [dbo].[InvoiceDetails] */
SELECT ccnt.fullname AS Name_Account,
  invGp.invoicegroupnumber AS Invoice_Number,
  classif.fullname AS Category,
  item.itemid AS Line_Item,
  item."description" AS Item_Label,
  ABS(trnLine.rate) AS Rate,
  SUM(ABS(trnLine.quantity)) AS Quantity,
  SUM(ABS(trnLine.grossamt)) AS Amount,
  CONCAT(emp.firstname, CONCAT(' ',emp.lastname)) AS CreatedBy,
  trn.createdDate AS CreatedDate,
  CONCAT(emp2.firstname, CONCAT(' ',emp2.lastname)) AS LastModifiedBy,
  trn.lastModifiedDate AS LastModifiedDate 
FROM [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[transaction] AS trn
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[InvoiceGroup] AS invGp ON invGp.id = trn.groupedto
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[transactionLine] AS trnLine ON trnLine."transaction" = trn.id
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[item] AS item ON item.id = trnLine.item
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[classification] AS classif ON classif.id = item.class
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[transactionAccountingLine] AS trnAccLine ON trnAccLine.transactionLine = trnLine.id
  LEFT JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[Account] AS ccnt ON ccnt.id = trnAccLine."account"
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[entity] AS emp ON emp.id = trn.createdby
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[entity] AS emp2 ON emp2.id = trn.lastmodifiedby
WHERE trn.groupedto IS NOT NULL
  AND trnLine.item IS NOT NULL
GROUP BY invGp.invoicegroupnumber,
  item.itemid,
  item."description",
  classif.fullname,
  ABS(trnLine.rate),
  ccnt.fullname,
  CONCAT(emp.firstname, CONCAT(' ',emp.lastname)),
  trn.createdDate,
  CONCAT(emp2.firstname, CONCAT(' ',emp2.lastname)),
  trn.lastModifiedDate
ORDER BY invGp.invoicegroupnumber,
  item.itemid,
  classif.fullname
