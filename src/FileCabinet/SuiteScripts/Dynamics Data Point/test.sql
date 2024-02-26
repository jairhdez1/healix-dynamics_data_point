SELECT acc.fullname AS Name_Account,
  invGp.invoicegroupnumber AS Invoice_Number,
  item.itemid AS NDC,
  classif.fullname AS Category,
  trnLn.uniqueKey AS Line_Item,
  ABS(trnLn.quantity) AS Quantity,
  ABS(trnLn.rate) AS Rate,
  ABS(trnLn.grossamt) AS Amount
FROM [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[InvoiceGroup] AS invGp
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[transaction] AS trn ON trn.groupedto = invGp.id
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[transactionLine] AS trnLn ON trnLn."transaction" = trn.id
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[item] AS item ON item.id = trnLn.item
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[classification] AS classif ON classif.id = item.class
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].TransactionAccountingLine AS trnAccLine ON trnAccLine.transactionLine = trnLn.id
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[Account] AS acc ON acc.id = trnAccLine."account"
  --INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[entity] AS emp ON emp.id = trn.createdby OR emp.id = trn.lastmodifiedby
  --INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[entity] AS emp2 ON emp2.id = trn.lastmodifiedby
--WHERE invGp.invoicegroupnumber = 'IG-000002'
/* GROUP BY acc.fullname,
  invGp.invoicegroupnumber,
  item.itemid,
  classif.fullname,
  trnLn.uniqueKey,
  ABS(trnLn.rate) */
ORDER BY invGp.invoicegroupnumber