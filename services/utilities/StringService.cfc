component name = "StringService" {

	/** Converts a string to a case and trims it.
	 *
	 * @param string case The case to convert to. Defaults to lower.
	 *
	 * @return string The converted and trimmed string.
	 */
	public string function convertToCaseAndTrim (
		 required string contentToConvert
		,string case = 'lower'
	) {
		switch ( arguments.case ) {
			case 'upper':
				return uCase( trim( arguments.contentToConvert ) );
			case 'lower':
				return lCase( trim( arguments.contentToConvert ) );
			case 'sentence':
				return uCase(
					 left(
						 trim( arguments.contentToConvert )
						,1
					)
				) & lCase(
					 mid(
						 trim( arguments.contentToConvert )
						,2
					)
				);
			default:
				throw 'Invalid case specified. Passed: #arguments.case# -- ValidCases: upper, lower, sentence';
		}
	}

}
