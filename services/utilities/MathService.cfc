component name = "MathService" {

	/**
	 *
	 * @param {Number} a
	 * @param {Number} b
	 * @param {string} operation
	 *
	 * @return {Number}
	 */
	public numeric function calculate (
		 a
		,b
		,operation
	) {
		switch ( operation ) {
			case 'add':
				return a + b;
			case 'subtract':
				return a - b;
			case 'multiply':
				return a * b;
			case 'divide':
				return a / b;
			default:
				throw new Error( 'Operation ' + operation + ' is not supported' );
		}
	}

}
