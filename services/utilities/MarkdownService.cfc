component name = "markdownService" {

	/**
	 * Extracts metadata and content from a Markdown document.
	 *
	 * @param markdownContent The Markdown content to extract data from.
	 *
	 * @return A struct containing metadata, content, and comments.
	 *
	 * @throws Application -specific exceptions for empty content or missing metadata.
	 */
	struct function extractFrom ( required string markdownContent ) {
		// Clean the Markdown content
		var markdownValue = clean( markdownContent );
		// Define regular expressions
		var metaRegex     = '(---\n)(.*\n)(---\n)';
		var styleRegex    = '(<style>)(.*\n)(</style>)';
		var commentRegex  = '(<!--\n)(.*\n)(-->)';

		// Attempt to match regular expressions
		var metaData = trim(
			 replace(
				 reFind(
					 metaRegex
					,markdownContent
					,1
					,1
					,'all'
				)[ 1 ].match[ 1 ]
				,'---'
				,''
				,'all'
			)
		);
		var styleData = trim(
			 replace(
				 reFind(
					 styleRegex
					,markdownContent
					,1
					,1
					,'all'
				)[ 1 ].match[ 1 ]
				,'<style>'
				,''
				,'all'
			)
		);
		var commentData = trim(
			 replace(
				 reFind(
					 commentRegex
					,markdownContent
					,1
					,1
					,'all'
				)[ 1 ].match[ 1 ]
				,'<!--'
				,''
				,'all'
			)
		);

		// Remove metadata, style data, and comments from the Markdown content
		var content = reReplace(
			 markdownContent
			,metaRegex
			,''
		);
		content = reReplace(
			 content
			,styleRegex
			,''
		);
		content = reReplace(
			 content
			,commentRegex
			,''
		);

		return {
			 'allContent' : markdownContent
			,'metaData'   : ( len( metaData ) GT 0 ) ? deserializeJSON( metaData ) : ''
			,'content'    : ( len( content ) GT 0 ) ? content : ''
			,'styleData'  : ( len( styleData ) GT 0 ) ? styleData : ''
			,'commentData': ( len( commentData ) GT 0 ) ? commentData : ''
		};
	}

	/**
	 * Cleans Markdown content by removing any leading or trailing whitespace.
	 *
	 * @param markdownContent The Markdown content to clean.
	 *
	 * @return The cleaned Markdown content.
	 *
	 * @throws Application -specific exceptions for empty content or only whitespace.
	 */
	string function clean ( required string v ) {
		// Trim leading and trailing whitespace
		var cleanedValue = trim( v );
		if ( cleanedValue == '' ) {
			throw(
				 type    = 'Application'
				,message = 'The value contained an empty string or only whitespace'
			);
		}
		return cleanedValue;
	}

}
