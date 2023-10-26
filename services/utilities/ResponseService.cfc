component name = "ResponseService" {

	property name="myResponse" type="struct";

	// Constructor
	/**
	 * This is the constructor for the ResponseService component. It is used to initialize the component.
	 * @return ResponseService
	 */
	public ResponseService function init() {
		myResponse = EmptyResponse();
		return this;
	}

	/**
	 * This function is used to return the response struct.
	 * @return struct
	 */
	public struct function EmptyResponse() {
		return {
			 'timeStamp': now()
			,'contents': { }
			,'messages': [ ]
		};
	}


	// Contents

	/**
	 * This function is used to set the contents of the response.
	 * @contents any The contents to set
	 * @return void
	 */
	public void function setContents( required any contents ) {
		myResponse.contents = contents;
	}

	// Messages

	/**
	 * This function is used to set the messages of the response.
	 * @messages array The messages to set
	 * @return void
	 */
	public void function setMessages( required array messages ) {
		myResponse.messages = messages;
	}

	/**
	 * This function is used to add a message to the response.
	 * @message string The message to add
	 * @return void
	 */
	public void function addMessage( required string message, type = 'Custom' ) {
		var message = "#uCase(arguments.type)# Message: #arguments.message#"
		arrayAppend( myResponse.messages, message );
	}

	/**
	 * This function is used to clear the messages of the response.
	 * @return void
	 */
	public void function clearMessages() {
		myResponse.messages = [ ];
	}


	// Dump Responses

	/**
	 * This function is used to dump a variable to the screen. It is used to help with debugging.
	 *
	 * @dump any The variable to dump
	 * @label string The label to use for the dump -- optional
	 * @doAbort boolean Whether or not to abort after the dump -- optional
	 */
	public function simpleDump(
		required any dump,
		string label = 'simpleDump',
		boolean doAbort = true
	) {
		writeDump( var = dump, label=arguments.label, abort = doAbort );
	}

	/**
	 * This function is used to return the response struct, that has been created, or one that is provided.
	 */
	public struct function getResponse() { return myResponse }

}
