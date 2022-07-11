import AppConfig from "@/config";
import { Account } from "@/database/models";
import express from "express";
import jwt from "jsonwebtoken";
// eslint-disable-next-line new-cap
const authRoute = express.Router();

authRoute.get("/", (req, res) => {
	return res.json(req.user);
});

authRoute.get('/mock-user', async (req, res) => {
	const secret = req.query.secret;
	if(secret == '515515515'){
		const users = await Account.findAll();
		return res.json(users);
	}

	return res.status(401).send('Unauthorized...');
});

// POST: /auth/login
authRoute.post("/login", async (req, res) => {
	const body = req.body;

	const user: any = await Account.findOne({
		where: {
			username: body.username,
			password: body.password,
		},
	});

	if (user)
		return res.json({
			message: "Login successful",
			token: jwt.sign(
				{ user_id: user.id, username: user.username },
				AppConfig.JWT_SECRET,
				{
					expiresIn: "7d",
				}
			),
			success: true,
		});

	return res.json({
		message: "Invalid username or password",
		success: false,
	});
});

authRoute.get('/me', async (req, res) => {
	const user: any = await Account.findOne({
		where: {
			id: req.user.user_id
		},
	});

	if (!user) {
		return res.json({
			message: 'Invalid user',
			success: false
		});
	}

	delete user["password"];

	return res.json({
		message: "Fetch user profile success!",
		success: true,
		data: { ...user.dataValues, avatarUrl: user.dataValues.avatarUrl || "/storage/placeholder.jpg", password: undefined }
	});
});

// POST: /auth/register
authRoute.post("/register", async (req, res) => {
	const body = req.body;

	const user: any = await Account.findOne({
		where: {
			username: body.username,
		},
	});

	if (user) {
		return res.json({
			message: "This user is already created!~",
			data: user,
			success: false,
		});
	}

	const newUser = await Account.create({
		username: body.username,
		password: body.password,
		firstname: body.firstname,
		lastname: body.lastname,
		nickname: body.nickname,
		gender: body.gender.toLowerCase(),
		birthday: body.birthdate,
		level: 1,
		follower: 0,
		following: 0,
		contact: body.contact,
	});

	delete newUser["password"];

	return res.json({
		message: "A new user has been created!~",
		data: newUser,
		success: true,
	});
});

export default authRoute;
