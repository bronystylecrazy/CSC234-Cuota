import * as chalk from "chalk";

/** Internal Modules */
import express from "express";
import cors from "cors";
import jwt from "express-jwt";
import cookieParser from "cookie-parser";

/** Routes */
import authRoute from "@/routes/auth";

/** Misc */
import config from "./config";

/** logger */
import morgan from "morgan";
import { logger } from "@/utils/serviceLog";
import path from "path";
import fs from "fs";
import { initTables } from "./database/models";
import eventRoute from "./routes/event";
import cron from "node-cron";
import storageRoute from "./routes/storage";
import feedRoute from "./routes/feed";

/** Instantiate Application */
const app = express();

const accessLogStream = fs.createWriteStream(
	path.join(__dirname, "access.log"),
	{
		flags: "a",
	}
);
/** Express configurations */
app.use(express.json());
// app.use(
// 	config.isDev
// 		? morgan("combined")
// 		: morgan("combined", { stream: accessLogStream })
// );
app.use(express.urlencoded({ extended: true }));

/** Plugins */
app.use(
	cors({
		origin: "http://localhost:3000",
		credentials: true,
	})
);
app.use(cookieParser());

/** Json Web Token */
app.use(
	jwt({
		secret: config.JWT_SECRET,
		algorithms: ["HS256"],
		credentialsRequired: false,
		getToken: function fromHeaderOrQuerystring(req) {
			if (
				req.headers.authorization &&
				req.headers.authorization.split(" ")[0] === "Bearer"
			) {
				return req.headers.authorization.split(" ")[1];
			} else if (req.query && req.query.token) {
				return req.query.token;
			} else if (req.cookies.token) {
				return req.cookies.token;
			}
			return null;
		},
	})
);

/** Routes */
app.use("/auth", authRoute);
app.use("/storage", storageRoute);
/** protected Routes */
app.use("/event", eventRoute);
app.use("/feed", feedRoute);

// for testing only
app.get("/", async (req, res) => {
	return res.send("It works! 😃 Thanks gods!");
});

/** Start a server */
(async () => {
	await initTables().catch((err) =>
		logger("Server", err, "🚨", "😭", "error")
	);
	app.listen(config.PORT, "0.0.0.0", () => {
		logger(
			"Server",
			`running on port ${chalk.bold(":" + config.PORT)}`,
			"🚀",
			"😃"
		);
	});
	cron.schedule("*/2 * * * *", async function () {
		logger("Server", "Syncing database", "🚀", "😃");
		await initTables().catch((err) =>
			logger("Server", err, "🚨", "😭", "error")
		);
	});
})();
