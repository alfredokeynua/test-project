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
			'Content-Type': 'application/json'
		},
		body: JSON.stringify({
			message: 'The time in Los Angeles is: ' + currentTime.toString(),
			time: currentTime,
			env: process.env ? process.env.THE_ENV_NAME : 'NO ENV',
			sample: {
				go: 'one11',
				two: 'test',
				thre: 'hello',
				other: 'world',
				go1: 'one',
				two1: 'test',
				thre1: 'hello',
				other1: 'world',
				go2: 'one',
				two2: 'test',
				thre2: 'hello',
				other2: 'world'
			}
		}),
	});
};
