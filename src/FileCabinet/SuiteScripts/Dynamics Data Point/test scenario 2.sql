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
SELECT acc.fullname AS Name_Account,
  invGp.invoicegroupnumber AS Invoice_Number,
  item.itemid AS NDC,
  classif.fullname AS Category,
  trnLn.uniqueKey AS Line_Item,
  SUM(ABS(trnLn.quantity)) AS Quantity,
  ABS(trnLn.rate) AS Rate,
  SUM(ABS(trnLn.grossamt)) AS Amount,
  CONCAT(emp.firstname, CONCAT(' ', emp.lastname)) AS CreatedBy,
  trn.createddate AS CreatedDate,
  CONCAT(emp.firstname, CONCAT(' ', emp.lastname)) AS LastModifiedBy,
  trn.lastModifiedDate AS LastModifiedDate
FROM [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[InvoiceGroup] AS invGp
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[transaction] AS trn ON trn.groupedto = invGp.id
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[transactionLine] AS trnLn ON trnLn."transaction" = trn.id
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[item] AS item ON item.id = trnLn.item
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[classification] AS classif ON classif.id = item.class
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].TransactionAccountingLine AS trnAccLine ON trnAccLine.transactionLine = trnLn.id
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[Account] AS acc ON acc.id = trnAccLine."account"
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[entity] AS emp ON emp.id = trn.createdby OR emp.id = trn.lastmodifiedby
  --INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[entity] AS emp2 ON emp2.id = trn.lastmodifiedby
--WHERE invGp.invoicegroupnumber = 'IG-000002'
GROUP BY acc.fullname,
  invGp.invoicegroupnumber,
  item.itemid,
  classif.fullname,
  trnLn.uniqueKey,
  ABS(trnLn.rate),
  trn.createddate,
  CONCAT(emp.firstname, CONCAT(' ', emp.lastname)),
  trn.lastModifiedDate
ORDER BY invGp.invoicegroupnumber