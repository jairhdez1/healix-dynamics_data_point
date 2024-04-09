/**
 * @NApiVersion 2.1
 * @NScriptType Suitelet
 */
define(['N/dataset', 'N/log', 'N/query', 'N/workbook'], /**
 * @param{dataset} dataset
 * @param{log} log
 * @param{query} query
 * @param{workbook} workbook
 */ (dataset, log, query, workbook) => {
  /**
   * Defines the Suitelet script trigger point.
   * @param {Object} scriptContext
   * @param {ServerRequest} scriptContext.request - Incoming request
   * @param {ServerResponse} scriptContext.response - Suitelet response
   * @since 2015.2
   */
  const onRequest = scriptContext => {
    try {
      const { response } = scriptContext
      const objDataSet = query.load({
        id: 'custdataset49'
      })
      const results = objDataSet.toSuiteQL()
      let qry = results.query
      qry = qry.replace('\n', ' ')
      do {
        let n1 = qry.indexOf('/*')
        let n2 = qry.indexOf('*/')
        let tempSlice = qry.slice(n1, n2 + 2)
        qry = qry.replace(tempSlice, '')
      } while (qry.indexOf('/*') != -1 && qry.indexOf('*/') != -1)
      response.write({ output: JSON.stringify({ qry }) })
    } catch (error) {
      log.error('Error on onRequest', error)
    }
  }

  return { onRequest }
})
