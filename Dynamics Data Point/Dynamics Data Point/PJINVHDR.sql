/* [HLX-Netsuite-CP-DB].[dbo].[PJINVHDR] */
SELECT invGp.invoicegroupnumber AS draft_num,
  invGp.invoicegroupnumber AS invoice_num,
  trnBillAdd.label AS project_billwith,
  invGp.custrecord_hlx_start_date AS [START DATE],
  invGp.custrecord_hlx_end_date AS [END DATE],
  invGp.trandate AS [Date Invoice First Generated],
  invGp.duedate AS [Due Date],
  invGp.total AS gross_amt,
  CONCAT(emp.firstname, CONCAT(' ', emp.lastname)) AS crtd_user,
  CAST(invGp.lastmodifieddate AS DATE) crtd_datetime,
  CONCAT(emp.firstname, CONCAT(' ', emp.lastname)) AS lupd_user,
  CAST(invGp.lastmodifieddate AS DATE) AS lupd_datetime
FROM [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[InvoiceGroup] AS invGp
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[transactionBillingAddressbook] AS trnBillAdd ON trnBillAdd.internalid = invGp.billaddresslist
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[entity] AS emp ON emp.id = invGp.lastmodifiedby
ORDER BY invGp.invoicegroupnumber ASC