/**
 * @Author Jj Zettler
 * @Description This will be the API Handler for the Category Object
 * @date 9/21/2023
 * @version 0.1
 * @Find = Category
 */
component extends="../BaseHandler" {

	property
		name   = "dataServer"
		inject = "LearningCategoryServer";

	// OPTIONAL HANDLER PROPERTIES
	this.prehandler_only      = "";
	this.prehandler_except    = "";
	this.posthandler_only     = "";
	this.posthandler_except   = "";
	this.aroundHandler_only   = "";
	this.aroundHandler_except = "";

	// REST Allowed HTTP Methods Ex: this.allowedMethods = {delete='POST,DELETE',index='GET'}
	this.allowedMethods = {};


	/**
	 * Main entry point for the handler, Lists all gratitude entries
	 */
	remote function index( event, rc, prc ){
		var target   = dataServer.getByActivity(1);
		var response = {
			"message"    : "Active Categories Listed Successfully",
			"data"       : target,
			"statusCode" : 200
		};
		sendResponse(
			event      = event,
			message    = response.message,
			data       = response.data,
			statusCode = response.statusCode
		);
		// event.renderData( type="json", data=target );
	}
}
