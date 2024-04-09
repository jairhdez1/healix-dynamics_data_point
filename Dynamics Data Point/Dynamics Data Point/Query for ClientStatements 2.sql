/** Test Scenario 2 */
/** [dbo].[StatementHeader] */
SELECT '' AS [Record_ID],
  trn.tranid AS [Statement_Number],
  cAddB.label AS [Site],
  CAST(trn.trandate AS date) AS [Statement_Date],
  entAdd.attention AS [Site_Recipient],
  entAdd.addressee AS [Site_Name],
  entAdd.addrtext AS [Site_Address],
  entAdd.zip AS [Site_Zip_Code],
  entAdd.city AS [Site_City],
  entAdd.state AS [Site_State],
  CAST(ABS(trn.foreigntotal) AS float) AS [Statement_Total],
  CAST(trn.trandate AS date) AS [Date_Statement_First_Generated],
  CONCAT(
    createdby.firstname,
    CONCAT(' ', createdby.lastname)
  ) AS [CreatedBy],
  CAST(trn.createddate AS date) AS [CreatedDate],
  CONCAT(
    updatedby.firstname,
    CONCAT(' ', updatedby.lastname)
  ) AS [LastModifiedBy],
  CAST(trn.lastmodifieddate AS date) AS [LastModifiedDate],
  '' AS [Confirm],
  '' AS [IsActive]
FROM [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[transaction] AS trn
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[entity] AS customer ON customer.id = trn.entity
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[customerAddressbook] AS cAddB ON cAddB.entity = customer.id
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[customerAddressbookEntityAddress] AS entAdd ON entAdd.nkey = cAddB.addressbookaddress
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[entity] AS createdby ON createdby.id = trn.createdby
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[entity] AS updatedby ON updatedby.id = trn.lastmodifiedby
WHERE (
    trn.recordtype = 'creditmemo'
    OR trn.recordtype = 'customerpayment'
  )
  AND cAddB.defaultbilling = 'T'
ORDER BY trn.tranid
  /** [dbo].[ StatementDetails] */
SELECT '' AS [Record_ID],
  trn.tranid AS [Statement_Number],
  cAddB.label AS [Site],
  CASE
    WHEN applyTrn.tranid IS NULL THEN applyTrn.transactionnumber
    ELSE applyTrn.tranid
  END AS [Invoice_Number],
  CAST(applyTrn.trandate AS date) AS [Invoice_Date],
  applyTrn.memo AS [Invoice_Description],
  CAST(ABS(applyTrn.foreigntotal) AS float) AS [Invoice_Balance],
  CONCAT(
    createdby.firstname,
    CONCAT(' ', createdby.lastname)
  ) AS [CreatedBy],
  CAST(trn.createddate AS date) AS [CreatedDate],
  CONCAT(
    updatedby.firstname,
    CONCAT(' ', updatedby.lastname)
  ) AS [LastModifiedBy],
  CAST(trn.lastmodifieddate AS date) AS [LastModifiedDate],
  '' AS [Deleted],
  '' AS [Confirm]
FROM [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[transaction] AS trn
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[PreviousTransactionLink] AS pTrnLink ON pTrnLink.nextdoc = trn.id
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[transaction] AS applyTrn ON applyTrn.id = pTrnLink.previousdoc
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[customerAddressbook] AS cAddB ON cAddB.entity = trn.entity
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[entity] AS createdby ON createdby.id = trn.createdby
  INNER JOIN [HEALIX_SB1].[Healix, LLC__SB1_HLX].[HEALIX - SuiteConnect].[entity] AS updatedby ON updatedby.id = trn.lastmodifiedby
WHERE (
    trn.recordtype = 'creditmemo'
    OR trn.recordtype = 'customerpayment'
  )
  AND cAddB.defaultbilling = 'T'
ORDER BY trn.tranid