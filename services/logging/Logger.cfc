component name = "Logger" {

	// ----------------------------------------------------------- Variables ----------------------------------------------------------- //
	variables.parentDirectory = '/assets/logs/';
	variables.fileType        = 'json';

	// ----------------------------------------------------------- Objects/Models ----------------------------------------------------------- //
	// Directory to store the log files
	private string function getDirectory ( prefix ) {
		prefix = right(
			 prefix
			,1
		) eq '/' ? prefix : prefix & '/';
		if ( !directoryExists( variables.parentDirectory & prefix ) ) {
			directoryCreate( variables.parentDirectory & prefix );
		}

		return variables.parentDirectory & prefix;
	}

	// Function to get the file creation data
	private string function getFileName ( directory ) {
		var fileName = arguments.directory & 'Log_#dateFormat(
			 now( )
			,'yyyymmdd'
		)#.#variables.fileType#';

		if ( !fileExists( fileName ) ) {
			writeOutput( 'Creating file: ' & fileName );
			fileWrite(
				 expandPath( fileName )
				,''
			);
		}

		return fileName;
	}

	// ----------------------------------------------------------- Log Entry Types ----------------------------------------------------------- //
	private struct function newLogEntrySimple (
		 required includeTimestamp
		,string prefix
	) {
		if ( arguments.includeTimestamp ) {
			return {
				 'message'  : ''
				,'prefix'   : isNull( arguments.prefix ) ? 'UNDEFINED' : arguments.prefix
				,'timestamp': now( )
			};
		} else {
			return {
				 'message': ''
				,'prefix' : isNull( arguments.prefix ) ? 'UNDEFINED' : arguments.prefix
			};
		}
	}
	// Function to initialize the log entry
	private struct function newLogEntryWithProperties (
		 required struct properties
		,required includeTimestamp
		,string prefix
	) {
		return {
			 'message'   : ''
			,'prefix'    : isNull( arguments.prefix ) ? 'UNDEFINED' : arguments.prefix
			,'timestamp' : now( )
			,'properties': properties
		};
	}

	// ----------------------------------------------------------- Private Functions ----------------------------------------------------------- //
	// Function to write the log entry to the log file
	private void function write (
		 required struct logEntry
		,string preLogMessage  = ''
		,string postLogMessage = ''
		,string separator      = '/-------------------- New Log -------------------/'
	) {
		// Write the log entry to the log file
		var directory    = getDirectory( logEntry.prefix );
		var logFileName  = getFileName( directory );
		var file         = '';
		// Format the log entry as a JSON string
		var logEntryJSON = serializeJSON( logEntry );

		try {
			// Build the full path to the log file
			// Open the log file in append mode
			var file = fileOpen(
				 logFileName
				,'append'
			);
			var logMessage = preLogMessage & logEntryJSON & postLogMessage;

			// Write the log entry to the file
			fileWriteLine(
				 file
				,separator
			);
			fileWriteLine(
				 file
				,logMessage
			);

			// Close the log file
			fileClose( file );
		} catch ( any e ) {
			// Handle any errors that occur while logging
			var errorMessages = [
				 'An error occurred while logging: ' & e.message
				,'Path: ' & logFileName
				,'More info: ' & e
			];
			// Write the error messages to the console
			writeDump( errorMessages );
		}
	}


	// ----------------------------------------------------------- Logging Functions ----------------------------------------------------------- //
	public void function sendSimpleLog (
		 required string message
		,hasTimeStamp = false
		,required string prefix
	) {
		var logEntry     = newLogEntrySimple( hasTimeStamp );
		logEntry.message = arguments.message;
		logEntry.prefix  = uCase( arguments.prefix );
		write( logEntry );
	}

	// Function to log a message
	public void function sendDetailedLog (
		 required string message
		,required struct additionalInfo = { }
		,required string prefix
	) {
		var preLogMessage  = '';
		var postLogMessage = '';

		var logEntry = newLogEntryWithProperties( additionalInfo );

		// Set the log entry properties
		logEntry.message   = arguments.message;
		logEntry.prefix    = uCase( arguments.prefix );
		logEntry.timestamp = now( );
		// If the log entry type is "withproperties", set the properties
		if ( logEntryType == 'withproperties' )
			logEntry.properties = duplicate( arguments.properties );

		write(
			 logEntry
			,contentToAdd
		);
	}

}
