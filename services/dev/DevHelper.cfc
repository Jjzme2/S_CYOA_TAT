component
	name   = "DevHelper"
	output = "false"
{

	// ----------------------------------------------------------- Properties ----------------------------------------------------------- //
	property
		name   = "logger"
		inject = "Logger";
	// ----------------------------------------------------------- Variables ----------------------------------------------------------- //
	variables.reminderDirectory = 'reminders/';

	// ----------------------------------------------------------- Objects/Models ----------------------------------------------------------- //

	private struct function ReminderLog ( ) {
		return {
			 'message'  : ''
			,'timestamp': now( )
			,'topic'    : '#variables.reminderDirectory#_undefined'
		}
	}

	// ----------------------------------------------------------- Log Entry Types ----------------------------------------------------------- //


	// ----------------------------------------------------------- Private Functions ----------------------------------------------------------- //

	private boolean function isValidMessage ( required string message ) {
		var hasLength = len( message ) > 0;

		return hasLength;
	}

	// ----------------------------------------------------------- Logging Functions ----------------------------------------------------------- //

	public void function sendReminder (
		 required string message
		,string topic
	) {
		var reminderLog     = reminderLog( );
		reminderLog.message = message;
		if (
			structKeyExists(
				 arguments
				,'topic'
			)
		) {
			reminderLog.topic = topic;
		}
		if ( isValidMessage( reminderLog.message ) ) {
			logger.sendSimpleLog(
				 message = reminderLog.message
				,prefix  = reminderLog.topic
			);
		} else {
			logger.sendSimpleLog(
				 message = 'Invalid reminder message: ' & reminderLog.message
				,prefix  = 'DEVHELPER_ERROR'
			);
		}
	}

}
