const handler = require("./handler");

const http = require("http");
const port = 3000;

const processResponse = (res) => async (lambdaResponse) => {
	if (lambdaResponse.headers) {
		Object.entries(lambdaResponse.headers).forEach(([k, v]) => res.setHeader(k, v));
	}
	res.statusCode = lambdaResponse.statusCode;
	res.end(lambdaResponse.body);
};

const server = http.createServer((req, res) => handler.handleGET(req.url).then(processResponse(res)));

server.listen(port, (err) => {
	if (err) {
		return console.log(err);
	}

	console.log(`server is listening on ${port}`);
});

