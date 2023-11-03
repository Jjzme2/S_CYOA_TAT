/**
 * @Author Jj Zettler
 * @Description This will be the service that will handle all the related functions for this named object.
 * @date 9/21/2023
 * @version 0.1
 * @Find = Quiz
 */
component singleton accessors="true" name="QuizServer" extends="BaseServer" {

	property name="accessPoint" inject="QuizAccess";

	/**
	* ----------------------------------------------------------------------------------------------
    * OBJECT INSTANTIATION
	* ----------------------------------------------------------------------------------------------
	*/

	/** Private functions for this service. */


	/** Common functions for this service. */

	/**
	 * This will get an empty QuizDTO.
	 * @return An empty Quiz DTO.
	 */
	public QuizDTO function getEmpty()
	{
		return new models.DTO.QuizDTO(); // Check path
	}

	public function list(){
		return getAll(accessPoint=accessPoint);
	}

// Searches

	public function getById(required string value)
	{
		var searchParams = {
			searchTerm  : "id"
			,sqlType 	: "cf_sql_varchar"
			,searchValue: value
		};
		var quiz = read( accessPoint = accessPoint, searchParams = searchParams );

		return successResponse(
			data= parseQuiz(quiz)
			,successMessage = "Quiz found and parsed successfully."
			,functionName = "QuizServer.getByActivity"
		);
	}

	public function getByName(required string value)
	{
		var searchParams = {
			searchTerm  : "name"
			,sqlType 	: "cf_sql_varchar"
			,searchValue: value
		};
		var quiz = read( accessPoint = accessPoint, searchParams = searchParams );

		return successResponse(
			data= parseQuiz(quiz)
			,successMessage = "Quiz found and parsed successfully."
			,functionName = "QuizServer.getByActivity"
		);
	}

	public function getByActivity(required boolean status)
	{
		var searchParams = {
			searchTerm  : "active"
			,sqlType 	: "cf_sql_bit"
			,searchValue: status
		};
		var quiz = read( accessPoint = accessPoint, searchParams = searchParams );

		return successResponse(
			data= parseQuiz(quiz)
			,successMessage = "Quiz found and parsed successfully."
			,functionName = "QuizServer.getByActivity"
		);
	}

	public function getByCreatedDate(required date value)
	{
		var searchParams = {
			searchTerm  : "creationDate"
			,sqlType 	: "cf_sql_datetime"
			,searchValue: value
			,relationship: "on"
		};
		var quiz = readByDate( accessPoint = accessPoint, searchParams = searchParams );

		return successResponse(
			data= parseQuiz(quiz)
			,successMessage = "Quiz found and parsed successfully."
			,functionName = "QuizServer.getByActivity"
		);
	}

	public function getByModifiedDate(required date value)
	{
		var searchParams = {
			searchTerm  : "recentChangeDate"
			,sqlType 	: "cf_sql_datetime"
			,searchValue: value
			,relationship: "on"
		};
		var quiz = readByDate( accessPoint = accessPoint, searchParams = searchParams );

		return successResponse(
			data= parseQuiz(quiz)
			,successMessage = "Quiz found and parsed successfully."
			,functionName = "QuizServer.getByActivity"
		);
	}


	/**
	 * Gets the data for the given quiz.
	 *
	 * @param required string quizId
	 * @return struct
	 */
	public function parseQuiz ( required struct quiz ) {
		quiz = quiz.contents;
		try {
			quiz.quiz_data = deserializeJSON(quiz.quiz_data).data;
			return quiz;
		} catch (any e) {
			errorResponse(
				error = e
				,functionName = "QuizServer.parseQuiz"
				,customMessages = ["Invalid Quiz Data", "The quiz data for #quiz.id# is invalid." ]
			)
			return quiz;
		}
	}

}
