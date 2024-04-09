/** Test Scenario 1 */
/** [HLX-Netsuite-CP-DB].[dbo].[QQ_ARDOC] */
SELECT invGp.invoicegroupnumber AS [Reference Number],
  CAST(invGp.trandate AS date) AS [Document Date],
  entity.entityid AS [Customer ID],
  entity.altname AS [Customer Name],
  entAdd.addressee AS [Site_Name],
  entAdd.addrtext AS [Site_Address],
  entAdd.zip AS [Site_Zip_Code],
  entAdd.city AS [Site_City],
  entAdd.state AS [Site_State],
  CAST(invGp.trandate AS date) AS [Statement_Date],
  invGp.total AS [Statement Balance],
  invGp.total AS [Original Document Amount],
  invGp.total AS [Document Balance],
  'Invoice Group' AS [Document Type],
  invGp.memo AS [Document Description],
  CAST(invGp.lastmodifieddate AS date) AS [Created Date],
  CONCAT(employee.firstname, CONCAT(' ', employee.lastname)) AS [Created User],
  CAST(invGp.trandate AS date) AS [Date_Statement_First_Generated],
  CONCAT(employee.firstname, CONCAT(' ', employee.lastname)) AS [Last Updated User],
  CAST(invGp.lastmodifieddate AS date) AS [Last Updated Date]
FROM [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[invoicegroup] AS invGp
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[entity] AS entity ON entity.id = invGp.customer
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[customerAddressbook] AS cAddB ON cAddB.entity = invGp.customer
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[customerAddressbookEntityAddress] AS entAdd ON entAdd.nkey = invGp.billaddresslist
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[entity] AS employee ON employee.id = invGp.lastmodifiedby
WHERE cAddB.defaultbilling = 'T'
ORDER BY invGp.invoicegroupnumber