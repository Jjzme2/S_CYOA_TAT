/**
 * @Author      Jj Zettler
 * @Description This will be the API Handler for the Adventure Object
 * @date        9/21/2023
 * @version     0.1
 * @Find        = Adventure
 */
component extends = "../BaseHandler" {

	property
		name   = "dataServer"
		inject = "AdventureServer";

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
		var target = dataServer.get( {
			 'searchTerm' : 'active'
			,'sqlType'    : 'cf_sql_bit'
			,'searchValue': '1'
		} );


		var response = {
			 'message'   : 'Active Adventures Listed Successfully'
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


	/**
	 * Read an entry by its id
	 */
	remote function show (
		 event
		,rc
		,prc
	) {
		var target = dataServer.get( {
			 'searchTerm' : 'id'
			,'sqlType'    : 'cf_sql_varchar'
			,'searchValue': rc.id
		} );

		var response = {
			 'message'   : 'Adventure Listed Successfully'
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

	remote function getPages (
		 event
		,rc
		,prc
	 ) {
		var pagesInAdventure = dataServer.getPages( adventureId = rc.id );

		var target = pagesInAdventure;

		var response = {
			 'message'   : 'Adventures in { #rc.id# } Listed Successfully'
			,'data'      : target
			,'statusCode': 200
		};

		sendResponse(
			 event      = event
			,message    = response.message
			,data       = response.data
			,statusCode = response.statusCode
		);
	}

}
