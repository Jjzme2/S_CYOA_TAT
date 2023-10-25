/**
 * Gratitude Event Handler
 */
component extends = "../BaseHandler" {

	// Don't forget to Map in config/Wirebox.cfc where applicable.

	property
		name   = "dataServer"
		inject = "AuthorServer";

	// OPTIONAL HANDLER PROPERTIES
	this.prehandler_only      = '';
	this.prehandler_except    = '';
	this.posthandler_only     = '';
	this.posthandler_except   = '';
	this.aroundHandler_only   = '';
	this.aroundHandler_except = '';

	// REST Allowed HTTP Methods Ex: this.allowedMethods = {delete='POST,DELETE',index='GET'}
	this.allowedMethods = { };


	/**
	 * Main entry point for the handler, Lists all gratitude entries
	 */
	remote function index (
		 event
		,rc
		,prc
	) {
		var target   = dataServer.getByActivity( 1 );
		var response = {
			 'message'   : 'Active Authors Listed Successfully'
			,'data'      : target
			,'statusCode': 200
		};
		sendResponse(
			 event      = event
			,message    = response.message
			,data       = response.data
			,statusCode = response.statusCode
		);
		// event.renderData( type="json", data=target );
	}

	// /**
	//  * Creates a new entry
	//  */
	// remote function save( event, rc, prc ){
	// 	// gratitudeStatement comes from the Vue front end that calls this.
	// 	var target = dataServer.store( rc.gratitudeStatement );
	// 	var response = {
	// 			"message": "Gratitude Saved Successfully",
	// 			"data": target,
	// 			"statusCode": 200
	// 		};
	// 		sendResponse(event=event, message=response.message, data=response.data, statusCode=response.statusCode);
	// 	// event.renderData( type="json", data=target );
	// }

}
