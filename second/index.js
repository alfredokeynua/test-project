'use strict';

const md5 = require('md5-hash');

exports.handler = (event, context, callback) => {
	callback(null, {
		statusCode: '200',
		headers: {
			'Content-Type': 'application/json'
		},
		body: JSON.stringify({
			message: 'Hola',
			md5: md5.default('Hola')
		}),
	});
};