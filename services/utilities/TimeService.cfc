component name = "TimeService" {

	/**
	 * Return the time relative to the passed in TimeZone
	 *
	 * @param string timeZone
	 *
	 * @return string The time in the local time zone
	 */
	public string function getLocalTime ( required string timeZone ) {
		var mask = 'mm/dd/yyyy @ HH:nn zzz';
		return now( ).dateTimeFormat(
			 mask
			,timeZone
		)
	}

	public string function convertToDate (
		 required string date
		,string format = 'yyyy-mm-dd'
	) {
		return date.dateFormat( arguments.format )
	}

	public string function convertToDateTime (
		 required string date
		,string format = 'mm/dd/yyyy @ HH:nn zzz'
	) {
		return date.dateTimeFormat( arguments.format )
	}

}
