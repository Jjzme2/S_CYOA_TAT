/**
 * @Author      Jj Zettler
 * @Description This will be the API Handler for the Quote Object
 * @date        9/21/2023
 * @version     0.1
 * @Find        = Quote
 */
component extends = "../BaseHandler" {

	property
		name   = "dataServer"
		inject = "QuoteServer";

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
		var target = dataServer.list( );
		var response = {
			 'message'   : 'Active Quotes Listed Successfully'
			,'data'      : target
			,'statusCode': 200
		};

		// writeDump(var=response.data, abort=true);
		sendResponse(
			 event      = event
			,message    = response.message
			,data       = response.data
			,statusCode = 200
		);
		// event.renderData( type="json", data=target );
	}

}
