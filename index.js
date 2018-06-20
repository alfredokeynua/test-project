'use strict';

// const awsServerlessExpress = require('aws-serverless-express');
// const app = require('./app');
// const server = awsServerlessExpress.createServer(app);
//
// exports.handler = (event, context) => awsServerlessExpress.proxy(server, event, context);

const time = require('time');
exports.handler = (event, context, callback) => {
	const currentTime = new time.Date();
	currentTime.setTimezone("America/Los_Angeles");
	callback(null, {
		statusCode: '200',
		headers: {
			'ContentType': 'application/json'
		},
		body: {
			message: 'The time in Los Angeles is: ' + currentTime.toString(),
			time: currentTime
		},
	});
};