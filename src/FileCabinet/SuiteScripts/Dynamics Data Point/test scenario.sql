/* [HLX-Netsuite-CP-DB].[dbo].[PJINVHDR] */
SELECT invGp.invoicegroupnumber AS invoice_num,
  trnBillAdd.label AS project_billwith,
  invGp.trandate AS begin_date,
  invGp.duedate AS end_date,
  invGp.total AS gross_amt,
  'user' AS crtd_user,
  'date' AS crtd_datetime,
  CONCAT(emp.firstname, CONCAT(' ', emp.lastname)) AS lupd_user,
  invGp.lastmodifieddate AS lupd_datetime
FROM [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[InvoiceGroup] AS invGp
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[transactionBillingAddressbook] AS trnBillAdd ON trnBillAdd.internalid = invGp.billaddresslist
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[entity] AS emp ON emp.id = invGp.lastmodifiedby
ORDER BY invGp.invoicegroupnumber ASC
  /* [HLX-Netsuite-CP-DB].[dbo].[PJInvDet] */
SELECT invGp.invoicegroupnumber AS draft_num,
  item.itemid AS ndc,
  item.description AS description,
  classif.fullname AS class,
  SUM(ABS(trnLn.quantity)) AS units,
  trnLn.rate AS rate,
  SUM(ABS(trnLn.grossamt)) AS amout
FROM [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[InvoiceGroup] AS invGp
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[transaction] AS trn ON trn.groupedto = invGp.id
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[transactionLine] AS trnLn ON trnLn."transaction" = trn.id
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[item] AS item ON item.id = trnLn.item
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[classification] AS classif ON classif.id = item.class
GROUP BY invGp.invoicegroupnumber,
  item.itemid,
  item.description,
  classif.fullname,
  trnLn.rate
ORDER BY invGp.invoicegroupnumber,
  item.itemid,
  classif.fullname
  /** [HLX-Netsuite-CP-DB].[dbo].[CUSTOMER] */
SELECT trnBillAddEnt.addressee AS BillAttn,
  trnBillAdd.label AS BillName,
  trnBillAddEnt.addr1 AS BillAddr1,
  trnBillAddEnt.addr2 AS BillAddr2,
  trnBillAddEnt.zip AS BillZip,
  trnBillAddEnt.city AS BillCity,
  trnBillAddEnt.state AS BillState,
  term.name AS Terms,
  trnBillAdd.label AS Custid
FROM [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[InvoiceGroup] AS invGp
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[transactionBillingAddressbook] AS trnBillAdd ON trnBillAdd.internalid = invGp.billaddresslist
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[transactionBillingAddressbookEntityAddress] AS trnBillAddEnt ON trnBillAddEnt.nkey = trnBillAdd.addressbookaddress
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[term] ON term.id = invGp.terms
ORDER BY invGp.invoicegroupnumber
  /** [HLX-Netsuite-CP-DB].[dbo].[PJBILL] */
SELECT invGp.invoicegroupnumber AS draft_num,
  trnBillAdd.label AS project,
  trn.type AS inv_format_cd
FROM [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[InvoiceGroup] AS invGp
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[transaction] AS trn ON trn.groupedto = invGp.id
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[transactionBillingAddressbook] AS trnBillAdd ON trnBillAdd.internalid = invGp.billaddresslist
GROUP BY invGp.invoicegroupnumber,
  trnBillAdd.label,
  trn.type
ORDER BY invGp.invoicegroupnumber