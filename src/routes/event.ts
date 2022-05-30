import { Account, Event, EventJoin, Type } from "@/database/models";
import deepsearch from "@/services/deepsearch";
import { isLogin } from "@/services/Utils";
import express, { Request } from "express";
import moment from "moment";
// eslint-disable-next-line new-cap
const eventRoute = express.Router();

// POST: /event/ to create event.
/**
 * @api {post} /event/ Create Event
{
	"title": "Toga part dance!",
	"detail": "Let's meet some new friends",
	"location": "at KMUTT LX building",
	"gender": "female",
	"subType_id": 3,
	"minAge": 20,
	"maxAge": 30,
	"maxJoin": 100,
	"eventDate": new Date() // อันนี้ก็แล้วแต่บน flutter อ่ะ มันเป็นวันที่
}
 */
eventRoute.post("/", async (req, res) => {
	try {
		// Logged In Check!
		if (!isLogin(req)) {
			return res.status(401).json({
				message: "Unauthorized, you have to login first!",
				success: false,
			});
		}

		const host_id = req.user.user_id;
		const body = req.body;
		console.log(body);
		const newEvent = await Event.create({
			host_id,
			title: body.title || "",
			detail: body.detail || "",
			location: body.location || "",
			gender: body.gender.toLowerCase() || "male",
			eventDate:
				new Date(moment(body.eventDate).toString()) || new Date(),
			subType_id: body.subType_id || 0,
			minAge: body.minAge || 18,
			maxAge: body.maxAge || 65,
			maxJoin: body.maxJoin || 20,
			awesome: 0,
		});

		return res.json({
			message: "Create event successful",
			success: true,
			data: newEvent,
		});
	} catch (e) {
		return res.json({
			success: false,
			message: e.message,
			data: {},
		});
	}
});

async function getEvents(req: Request) {
	const query: string = req.query.search as string;

	const [events, accounts, eventJoins, categories]: [
		any[],
		any[],
		any[],
		any[]
	] = await Promise.all([
		Event.findAll({}),
		Account.findAll({}),
		EventJoin.findAll({}),
		Type.findAll({}),
	]);

	let results: any[] = query
		? events.filter((event) => deepsearch(event, query))
		: events;

	results = results.map((result) => ({
		...result.dataValues,
		host:
			accounts.find((account) => account.id === result.host_id)
				?.firstname +
			" " +
			accounts.find((account) => account.id === result.host_id)?.lastname,
		hostAvatarUrl:
			accounts.find((account) => account.id === result.host_id)
				?.avatarUrl || "/storage/placeholder.jpg",
		eventImageUrl: result.eventImageUrl || "/storage/placeholder_bg.png",
		joined: eventJoins.filter(
			(eventJoin) => eventJoin.event_id === result.id && eventJoin.accept
		).length,
		subType_name:
			categories.find((c) => c.id === result.subType_id)?.mainType || "",
	}));
	return { results, events, accounts, eventJoins, categories };
}

// GET /event to get all events.  EXPLORE
eventRoute.get("/", async (req, res) => {
	try {
		const { results } = await getEvents(req);
		return res.json({
			message:
				results.length > 0
					? "Get all events successful"
					: "There are no events now, create one!",
			success: true,
			data: results,
		});
	} catch (e) {
		return res.json({
			success: false,
			message: e.message,
			data: {},
		});
	}
});

// GET /event to get all events.  EXPLORE
eventRoute.get("/explore", async (req, res) => {
	try {
		const { results, categories: subcategories } = await getEvents(req);
		const categories = {};
		for (const category of subcategories) {
			if (!categories[category.mainType]) {
				categories[category.mainType] = {};
			}

			if (!categories[category.mainType][category.subType]) {
				categories[category.mainType][category.subType] = [];
			}

			categories[category.mainType][category.subType] = results.filter(
				(event) => event.subType_id === category.id
			);
		}
		// results.forEach((result) => {});

		return res.json({
			message:
				results.length > 0
					? "Get all events successful"
					: "There are no events now, create one!",
			success: true,
			data: categories,
		});
	} catch (e) {
		return res.json({
			success: false,
			message: e.message,
			data: {},
		});
	}
});

// GET /event to get all events.  EXPLORE
eventRoute.get("/explore/random", async (req, res) => {
	try {
		const { results, categories: subcategories } = await getEvents(req);
		const categories = {};
		for (const category of subcategories) {
			if (!categories[category.mainType]) {
				categories[category.mainType] = {};
			}

			if (!categories[category.mainType][category.subType]) {
				categories[category.mainType][category.subType] = [];
			}

			categories[category.mainType][category.subType] = results.filter(
				(event) => event.subType_id === category.id
			);
			categories[category.mainType] =
				categories[category.mainType][category.subType][
				Math.floor(
					Math.random() *
					categories[category.mainType][category.subType]
						.length
				)
				] || null;
		}
		// results.forEach((result) => {});

		return res.json({
			message:
				results.length > 0
					? "Get all events successful"
					: "There are no events now, create one!",
			success: true,
			data: categories,
		});
	} catch (e) {
		return res.json({
			success: false,
			message: e.message,
			data: {},
		});
	}
});

eventRoute.get("/category", async (req, res) => {
	try {
		const [subcategories]: [any[]] = await Promise.all([Type.findAll({})]);
		const categoryMap = {};
		for (const category of subcategories) {
			if (!categoryMap[category.mainType]) {
				categoryMap[category.mainType] = [];
			}
			categoryMap[category.mainType].push({
				id: category.id,
				subType: category.subType,
			});
		}

		return res.json({
			message: "Get all categories successful!",
			success: true,
			data: categoryMap,
		});
	} catch (e) {
		return res.json({
			success: false,
			message: e.message,
			data: {},
		});
	}
});

// GET /event/:id to get by category.  EXPLORE
eventRoute.get("/:subType_id", async (req, res) => {
	try {
		const subType_id = parseInt(req.params.subType_id);

		if (!isLogin(req)) {
			return res.json({
				message: "Unauthorized, you have to login first!",
				success: false,
			});
		}

		const events = await Event.findAll({
			where: {
				subType_id,
			},
		});
		return res.json({
			message:
				events.length > 0
					? "Get all events successful!"
					: "There're no events in this category!",
			success: true,
			data: events,
		});
	} catch (e) {
		return res.json({
			success: false,
			message: e.message,
			data: {},
		});
	}
});

export default eventRoute;
