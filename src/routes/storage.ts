/* eslint-disable require-jsdoc */
/* eslint-disable @typescript-eslint/no-unused-vars */
import express from "express";
import {
	createReadStream,
	existsSync,
	fstat,
	mkdir,
	mkdirSync,
	ReadStream,
} from "fs";
// eslint-disable-next-line new-cap
const storageRoute = express.Router();

function checkStorageDir() {
	if (!existsSync("./storage")) {
		mkdirSync("./storage");
	}
}

checkStorageDir();

storageRoute.get("/:url", (req, res) => {
	try {
		const file = createReadStream(`./storage/${req.params.url}`);
		res.setHeader("Content-Type", "image/jpg");
		return file.pipe(res);
	} catch (e) {
		return res.status(404).send(e.message);
	}
});

export default storageRoute;
