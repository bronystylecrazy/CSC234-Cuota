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
	unlinkSync,
} from "fs";
import multer from "multer";
import { nanoid } from "nanoid";
import path from "path";
import util from "util";

var storage = multer.diskStorage({
	destination: (req, file, callback) => {
		callback(null, `./storage`);
	},
	filename: async (req, file, callback) => {
		const match = ["image/png", "image/jpeg"];
		if (match.indexOf(file.mimetype) === -1) {
			var message = `${file.originalname} is invalid. Only accept png/jpeg.`;
			return callback(message, null);
		}
		var filename = `${Date.now()}-${nanoid()}${path.extname(
			file.originalname
		)}`;
		callback(null, filename);
	},
	onError: function (err, next) {
		next(err);
	},
});

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
		if (!existsSync(`./storage/${req.params.url}`)) {
			const file = createReadStream(`./storage/placeholder_bg.png`);
			res.setHeader("Content-Type", "image/jpg");
			return file.pipe(res);
		}
		const file = createReadStream(`./storage/${req.params.url}`);
		res.setHeader("Content-Type", "image/jpg");
		return file.pipe(res);
	} catch (e) {
		const file = createReadStream(`./storage/placeholder_bg.png`);
		res.setHeader("Content-Type", "image/jpg");
		return file.pipe(res);
	}
});

var uploadFiles = multer({ storage: storage }).array("files", 10);
var uploadFilesMiddleware = util.promisify<any>(uploadFiles);

storageRoute.post("/", uploadFilesMiddleware, (req, res, err) => {
	console.log(req.body);
	return res.json(
		(req as any).files.map((file) => ({
			url: "/storage/" + file.filename,
			name: file.originalname,
			size: file.size,
			type: file.mimetype,
			createdAt: new Date().toISOString(),
		}))
	);
});

storageRoute.delete("/:url", (req, res) => {
	try {
		unlinkSync(`./storage/${req.params.url}`);
		return res.send({
			success: true,
			message: "deleted successfully",
			data: req.params.url,
		});
	} catch (e) {
		return res.json({ success: false, message: e.message, data: null });
	}
});

export default storageRoute;
