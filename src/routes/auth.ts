import AppConfig from "@/config";
import { Account, Interest } from "@/database/models";
import express from "express";
import jwt from "jsonwebtoken";
import { faker } from '@faker-js/faker';
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

authRoute.patch('/mock-user', async (req, res) => {
	const secret = req.query.secret;
	if(secret == '515515515'){
		const users = await Account.findAll();
		for(let i = 0; i < users.length; i++){
			const user = users[i];
			const name =  faker.name.findName();
			user.setDataValue('firstname', name.split(' ')[0]);
			user.setDataValue('lastname', name.split(' ')[1]);
			await user.save();
		}
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

	if (user){

		const interest = await Interest.findOne({
			where: {
				account_id: user.id,
			},
		});

		return res.json({
			message: "Login successful",
			token: jwt.sign(
				{ user_id: user.id, username: user.username },
				AppConfig.JWT_SECRET,
				{
					expiresIn: "7d",
				}
			),
			firstTime: interest.getDataValue('isFirstTime'),
			success: true,
		});
	}

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


authRoute.post('/update-interest', async (req, res) => {
	const id = req.user?.user_id;

	console.log(`Checking id ${id}`)

	const interest = await Interest.findOne({
		where: {
			account_id: id || '-1',
		}
	});

	if(interest){
		interest.setDataValue('isFirstTime', false);
		await interest.save();
		return res.json({
		message: "Update interest success!",
		success: true,
	});
	}

	return res.json({
		message: "Update interest failed!",
		success: false,
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

	await Interest.create({
		account_id: +newUser.getDataValue('id'),
		isFirstTime: true,
		interests: "[]",
	})

	delete newUser["password"];

	return res.json({
		message: "A new user has been created!~",
		data: newUser,
		success: true,
	});
});




export default authRoute;
