const handler = require("./handler");

module.exports.handler = async (event) => {
	return handler.handleGET(event.path);
};
