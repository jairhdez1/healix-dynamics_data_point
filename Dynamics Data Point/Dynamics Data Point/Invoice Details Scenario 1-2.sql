  /* [HLX-Netsuite-CP-DB].[dbo].[PJInvDet] */
SELECT invGp.invoicegroupnumber AS draft_num,
  item.description AS comment,
  CASE
    WHEN classif.fullname = 'Biologics'
    OR classif.fullname = 'Drugs'
    OR classif.fullname = 'IVIG' THEN 'COGS-DRUGS'
    WHEN classif.fullname = 'COGS Rebates'
    OR classif.fullname = 'Payment Discounts'
    OR classif.fullname = 'Sales Rebates' THEN 'COGS-DRUGDISC'
    WHEN classif.fullname = 'Delivery' THEN 'COGS-DELIVERY'
    WHEN classif.fullname = 'Dispensing Fees' THEN 'COGS-DISPFEES'
    WHEN classif.fullname = 'Management Fee' THEN 'CMF'
    WHEN classif.fullname = 'Non-Inv Supplies' THEN 'COGS-PHDL'
    WHEN classif.fullname = 'Operating Exp' THEN 'OPEX'
    WHEN classif.fullname = 'Payroll' THEN 'COGS-WAGESNUR'
    WHEN classif.fullname = 'Pumps' THEN 'COGS-PUMPS'
    WHEN classif.fullname = 'Reimbursment Fees' THEN 'COGS-REIMBFEE'
    WHEN classif.fullname = 'Sales Rebates' THEN 'COGS-DRUGDISC'
    WHEN classif.fullname = 'Supplies' THEN 'COGS-SUPPLIES'
    ELSE ''
  END AS act,
  classif.fullname AS class,
  CAST(SUM(ABS(trnLn.quantity)) AS float) AS units,
  trnLn.rate AS rate,
  CAST(SUM(ABS(trnLn.grossamt)) AS float) AS amount,
  trnBillAdd.label AS project,
  trnBillAdd.label AS project_billwith
FROM [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[InvoiceGroup] AS invGp
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[transaction] AS trn ON trn.groupedto = invGp.id
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[transactionLine] AS trnLn ON trnLn."transaction" = trn.id
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[item] AS item ON item.id = trnLn.item
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[classification] AS classif ON classif.id = item.class
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[transactionBillingAddressbook] AS trnBillAdd ON trnBillAdd.internalid = invGp.billaddresslist
GROUP BY invGp.invoicegroupnumber,
  item.itemid,
  item.description,
  classif.fullname,
  trnLn.rate,
  trnBillAdd.label
ORDER BY invGp.invoicegroupnumber,
  item.itemid,
  classif.fullname

  /** [dbo].[InvoiceDetails] */
SELECT CASE
    WHEN classif.fullname = 'Biologics'
    OR classif.fullname = 'Drugs'
    OR classif.fullname = 'IVIG' THEN 'COGS-DRUGS'
    WHEN classif.fullname = 'COGS Rebates'
    OR classif.fullname = 'Payment Discounts'
    OR classif.fullname = 'Sales Rebates' THEN 'COGS-DRUGDISC'
    WHEN classif.fullname = 'Delivery' THEN 'COGS-DELIVERY'
    WHEN classif.fullname = 'Dispensing Fees' THEN 'COGS-DISPFEES'
    WHEN classif.fullname = 'Management Fee' THEN 'CMF'
    WHEN classif.fullname = 'Non-Inv Supplies' THEN 'COGS-PHDL'
    WHEN classif.fullname = 'Operating Exp' THEN 'OPEX'
    WHEN classif.fullname = 'Payroll' THEN 'COGS-WAGESNUR'
    WHEN classif.fullname = 'Pumps' THEN 'COGS-PUMPS'
    WHEN classif.fullname = 'Reimbursment Fees' THEN 'COGS-REIMBFEE'
    WHEN classif.fullname = 'Sales Rebates' THEN 'COGS-DRUGDISC'
    WHEN classif.fullname = 'Supplies' THEN 'COGS-SUPPLIES'
    ELSE ''
  END AS Name_Account,
  invGp.invoicegroupnumber AS Invoice_Number,
  classif.fullname AS Category,
  item.itemid AS Line_Item,
  item."description" AS Item_Label,
  ABS(trnLine.rate) AS Rate,
  SUM(ABS(trnLine.quantity)) AS Quantity,
  SUM(ABS(trnLine.grossamt)) AS Amount,
  CONCAT(emp.firstname, CONCAT(' ', emp.lastname)) AS CreatedBy,
  trn.createdDate AS CreatedDate,
  CONCAT(emp2.firstname, CONCAT(' ', emp2.lastname)) AS LastModifiedBy,
  trn.lastModifiedDate AS LastModifiedDate
FROM [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[transaction] AS trn
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[InvoiceGroup] AS invGp ON invGp.id = trn.groupedto
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[transactionLine] AS trnLine ON trnLine."transaction" = trn.id
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[item] AS item ON item.id = trnLine.item
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[classification] AS classif ON classif.id = item.class
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[transactionAccountingLine] AS trnAccLine ON trnAccLine.transactionLine = trnLine.id
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[entity] AS emp ON emp.id = trn.createdby
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[entity] AS emp2 ON emp2.id = trn.lastmodifiedby
WHERE trn.groupedto IS NOT NULL
  AND trnLine.item IS NOT NULL
GROUP BY invGp.invoicegroupnumber,
  item.itemid,
  item."description",
  classif.fullname,
  ABS(trnLine.rate),
  CONCAT(emp.firstname, CONCAT(' ', emp.lastname)),
  trn.createdDate,
  CONCAT(emp2.firstname, CONCAT(' ', emp2.lastname)),
  trn.lastModifiedDate
ORDER BY invGp.invoicegroupnumber,
  item.itemid,
  classif.fullname