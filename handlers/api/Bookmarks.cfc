/**
 * Journal REST Handler
 */
component extends = "../BaseHandler.cfc" {

	property
		name   = "dataServer"
		inject = "bookmarkServer";

	// OPTIONAL HANDLER PROPERTIES
	this.prehandler_only      = '';
	this.prehandler_except    = '';
	this.posthandler_only     = '';
	this.posthandler_except   = '';
	this.aroundHandler_only   = '';
	this.aroundHandler_except = '';

	// REST Allowed HTTP Methods Ex: this.allowedMethods = {delete='POST,DELETE',index='GET'}
	this.allowedMethods = { };

	remote function index (
		 event
		,rc
		,prc
	) {
		var target = dataServer.list( );
		event.renderData(
			 type = 'json'
			,data = target
		);
	}

	remote function search (
		 event
		,rc
		,prc
	) {
		var target = dataServer.search(
			 column = rc.column
			,value  = rc.value
		);
		event.renderData(
			 type = 'json'
			,data = target
		);
	}

	remote function getBookmark (
		 event
		,rc
		,prc
	) {
		var target = dataServer.read( rc.id );
		event.renderData(
			 type = 'json'
			,data = target
		);
	}

	remote function getBookmarksFromJournal (
		 event
		,rc
		,prc
	) {
		var target = dataServer.getFromJournal( rc.id );
		event.renderData(
			 type = 'json'
			,data = target
		);
	}

	remote function searchBookmarksForYoutubeFromJournal (
		 event
		,rc
		,prc
	) {
		var target = dataServer.getYoutubeURLs(
			 rc.youtube
			,rc.journalID
		);
		event.renderData(
			 type = 'json'
			,data = target
		);
	}

	remote function searchBookmarkUrlsFromJournalContaining (
		 event
		,rc
		,prc
	) {
		var target = dataServer.getBySearchTerm(
			 rc.searchTerm
			,rc.journalID
		);
		event.renderData(
			 type = 'json'
			,data = target
		);
	}

	remote function store (
		 event
		,rc
		,prc
	) {
		var target = dataServer.store( rc );
		event.renderData(
			 type = 'json'
			,data = target
		);
	}

}
