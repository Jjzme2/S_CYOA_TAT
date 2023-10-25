component name = "EmailService" {

	/**
	 * Send an email to the developer
	 *
	 * @subject string
	 * @body    string
	 */
	public void function sendEmail (
		 required string subject
		,required string body
		,string type = 'html'
	) {
		var devEmail = 'ilytat.dev@gmail.com';

		try {
			new mail(
				 to      = devEmail
				,from    = devEmail
				,subject = subject
				,body    = body
				,type    = type
			).send( );
		} catch ( any e ) {
			throw( e );
		}
	}

}
