component name = "EncryptionService" {

	property
		name   = "BCrypt"
		inject = "@BCrypt";


	string function hashPassword (
		 password
		,saltRounds = 10
	) {
		try {
			return BCrypt.hashPassword(
				 password
				,saltRounds
			);
		} catch ( e ) {
			throw( 'Error hashing password: ' & e.message );
		}
	}

	boolean function checkPassword (
		 password
		,hash
	) {
		return BCrypt.checkPassword(
			 password
			,hash
		);
	}

	string function generateSalt ( rounds ) {
		return BCrypt.generateSalt( );
	}

}
