component name = "ResponseService" {


	/**
	 * This function is used to dump a variable to the screen. It is used to help with debugging.
	 *
	 * @dump any The variable to dump
	 * @label string The label to use for the dump -- optional
	 */
	public function stopDumpSimple( required any dump, string label = 'stopDumpSimple' ) {
		writeDump( var = dump, label=arguments.label, abort = true );
	}

	/**
	 * This function is used to send a response back to the client. if no data is provided, a message is expected. If no message is provided, a default message is sent.
	 *
	 * @data any The data to send back to the client -- optional
	 * @messages array The messages to send back to the client -- optional
	 */
	public struct function sendData (
		 any data       = { }
		,array messages = [ ]
	) {
		if ( empty( arguments.data ) ) {
			if ( messages.len( ) LT 1 ) {
				messages = [
					 'messages': "You may have forgotten to set data or a message when calling this, please make sure if you aren't setting data that you include a message."
				];
			}
		}

		return {
			 'contents': data
			,'messages': messages
		};
	}

}
