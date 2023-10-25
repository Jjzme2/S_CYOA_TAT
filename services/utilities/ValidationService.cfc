component name = "ValidationService" {

	/**
	 * Checks a given struct by the keys provided.
	 *
	 * @param structToValidate The struct to validate.
	 * @param keysToCheck An array of keys to check in the struct.
	 *
	 * @return Boolean indicating whether the struct contains all the required keys.
	 */
	public boolean function ValidStruct (
		 struct structToValidate
		,array keysToCheck
	) {
		for ( var key in keysToCheck ) {
			if (
				!structKeyExists(
					 structToValidate
					,key
				)
			) {
				throw(
					 type    = 'ValidationException'
					,message = '#key# is required'
				);
			}
		}
		return true;
	}

}
