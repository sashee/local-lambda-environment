const AWS = require("aws-sdk");
const s3 = new AWS.S3();

module.exports.handleGET = async (path) => {
	const bucketContents = (await s3.getObject({
		Bucket: process.env.BUCKET,
		Key: process.env.KEY,
	}).promise()).Body.toString("utf8");

	return {
		statusCode: 200,
		headers: {
			"Content-Type": "text/html",
		},
		body: `The content of the bucket: ${bucketContents}<br/>The current path is: ${path}<br/><a href="path1">go to path1</a><br/><a href="path2">go to path2</a>`,
	};
};

