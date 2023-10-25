component name = "MarkdownGenerationService" {

	property
		name   = "logService"
		inject = "Logger";

	// Set default values
	variables.defaultOutputDirectory = expandPath( '/assets/docs/generated/markdown/' );

	public string function getFullPathToMarkdownFile (
		 required string fileName
		,string directory
	) {
		var directoryArgPassedIn = structKeyExists(
			 arguments
			,'directory'
		) && len( trim( arguments.directory ) );

		if ( !directoryArgPassedIn ) {
			arguments.directory = variables.defaultOutputDirectory;
		} else {
			// Use the default directory as the parent
			arguments.directory = variables.defaultOutputDirectory & arguments.directory;
		}

		return arguments.directory & arguments.fileName & '.md';
	}

	public function createNewMarkdownFile (
		 required string fileName
		,string directory
	) {
		var directoryArgPassedIn = structKeyExists(
			 arguments
			,'directory'
		) && len( trim( arguments.directory ) );

		if ( !directoryArgPassedIn ) {
			arguments.directory = variables.defaultOutputDirectory;
		} else {
			// Use the default directory as the parent
			arguments.directory = variables.defaultOutputDirectory & '/' & arguments.directory;
		}

		if ( !directoryExists( arguments.directory ) ) {
			logService.sendSimpleLog(
				 message = 'Directory does not exist, creating it now'
				,prefix  = 'Services_MDGen'
			);
			directoryCreate( arguments.directory );
		}

		// Check if the file already exists
		if ( fileExists( arguments.directory & '/' & arguments.fileName ) ) {
			throw(
				 message = 'File already exists'
				,detail  = 'File already exists'
				,type    = 'FileAlreadyExists'
			);
		} else {
			// Create the file
			fileWrite(
				 arguments.directory & '/' & arguments.fileName & '.md'
				,''
			);
		}
	}

	private function appendToFile (
		 required string fileName
		,required string content
		,boolean createIfNA = false
	) {
		if ( createIfNA ) {
			if ( !fileExists( arguments.fileName ) ) {
				createNewMarkdownFile( fileName = arguments.fileName );
			}
		} else if ( !fileExists( arguments.fileName ) ) {
			throw(
				 message = '(' & fileName & ')' & ' does not exist.'
				,detail  = fileName & ' does not exist.'
				,type    = 'FileDoesNotExist'
			)
		}

		fileAppend(
			 arguments.fileName
			,arguments.content
		);
	}

	// TODO: Most of the adds should be converted to Gets, we should get the string and then we can decide what to do with it
	public function addNewTitle (
		 required string fileName
		,required string contentToAdd
		,boolean applyStyle = true
	) {
		var content     = chr( 35 ) & ' ' & contentToAdd;
		var idAttribute = " id='" & replace(
			 contentToAdd
			,' '
			,'-'
			,'all'
		) & "' ";
		var classAttribute = " class='title' ";

		if ( applyStyle ) {
			content &= ' {' & idAttribute & classAttribute & '}' & chr( 10 );
		} else {
			content &= ' {' & idAttribute & '}' & chr( 10 );
		}

		appendToFile(
			 fileName = fileName
			,content  = content
		);
	}

	public function getTitleById ( required string hyphenSepareatedID ) {
		var fileContent = fileRead( arguments.fileName );
		var title       = '';

		if ( len( trim( arguments.hyphenSepareatedID ) ) ) {
			var id = replace(
				 arguments.hyphenSepareatedID
				,'-'
				,' '
				,'all'
			);
			var idRegex        = "id='" & id & "'";
			var idRegexMatches = reFind(
				 arguments.idRegex
				,arguments.fileContent
			);

			if ( arrayLen( arguments.idRegexMatches ) ) {
				var titleRegex        = chr( 35 ) & ' ' & id & '.*';
				var titleRegexMatches = reFind(
					 arguments.titleRegex
					,arguments.fileContent
				);

				if ( arrayLen( arguments.titleRegexMatches ) ) {
					var title = trim(
						 replace(
							 arguments.titleRegexMatches[ 1 ]
							,chr( 35 )
							,''
							,'all'
						)
					);
				}
			}
		}

		return arguments.title;
	}

	public function addNewSubTitle (
		 required string fileName
		,required string contentToAdd
		,boolean applyStyle = true
	) {
		var content     = chr( 35 ) & chr( 35 ) & ' ' & contentToAdd;
		var idAttribute = " id='" & replace(
			 contentToAdd
			,' '
			,'-'
			,'all'
		) & "' ";
		var classAttribute = " class='sub-title' ";

		if ( applyStyle ) {
			content &= ' {' & idAttribute & classAttribute & '}' & chr( 10 );
		} else {
			content &= ' {' & idAttribute & '}' & chr( 10 );
		}

		appendToFile(
			 fileName = fileName
			,content  = content
		);
	}

	public function addNewTriTitle (
		 required string fileName
		,required string contentToAdd
		,boolean applyStyle = true
	) {
		var content     = chr( 35 ) & chr( 35 ) & chr( 35 ) & ' ' & contentToAdd;
		var idAttribute = " id='" & replace(
			 contentToAdd
			,' '
			,'-'
			,'all'
		) & "' ";
		var classAttribute = " class='tri-title' ";

		if ( applyStyle ) {
			content &= ' {' & idAttribute & classAttribute & '}' & chr( 10 );
		} else {
			content &= ' {' & idAttribute & '}' & chr( 10 );
		}

		appendToFile(
			 fileName = fileName
			,content  = content
		);
	}

	public function addLink (
		 required string fileName
		,required string contentToAdd
		,required string link
	) {
		var content = '[' & arguments.contentToAdd & '](' & arguments.link & ')' & chr(
			 10
		);
		appendToFile(
			 fileName = fileName
			,content  = content
		);
	}

	public function addCode (
		 required string fileName
		,required string contentToAdd
		,string codeType = 'inline'
		,language        = ''
	) {
		var acceptedCodeTypes = [
			 'inline'
			,'block'
		];
		var content = '';
		if (
			arrayFind(
				 arguments.acceptedCodeTypes
				,arguments.codeType
			)
		) {
			if ( arguments.codeType == 'inline' ) {
				content = '`' & arguments.contentToAdd & '`' & chr( 10 );
			} else {
				content = '```' & arguments.language & chr( 10 ) & arguments.contentToAdd & chr(
					 10
				) & '```' & chr( 10 );
			}
		} else {
			throw(
				 message = 'Code type not accepted'
				,detail  = 'Code type not accepted'
				,type    = 'CodeTypeNotAccepted'
			);
		}
	}

	public function addList (
		 required string fileName
		,required array listItems
		,string listType = 'o'
	) {
		var references = {
			 'ordered': [
				 'ordered'
				,'numbered'
				,'o'
				,'ord'
			]
			,'unordered': [
				 'unordered'
				,'bullet'
				,'u'
				,'unord'
			]
		};

		var content  = '';
		var listType = listType.toLowerCase( );

		cfabort( showerror = arrayToList( listItems ) );

		if (
			arrayFindNoCase(
				 references.ordered
				,listType
			)
		) {
			for ( i = 1; i <= arrayLen( arguments.listItems ); i++ ) {
				content &= '1. ' & arguments.listItems[ i ] & chr( 10 );
			}
		} else if (
			arrayFindNoCase(
				 references.unordered
				,listType
			)
		) {
			for ( i = 1; i <= arrayLen( arguments.listItems ); i++ ) {
				content &= '- ' & arguments.listItems[ i ] & chr( 10 );
			}
		} else {
			throw(
				 message = 'List type not accepted'
				,detail  = 'List type not accepted'
				,type    = 'ListTypeNotAccepted'
			);
		}

		appendToFile(
			 fileName
			,content
		);
	}

}
