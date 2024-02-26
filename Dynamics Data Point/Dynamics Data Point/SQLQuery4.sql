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