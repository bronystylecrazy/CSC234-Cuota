import { DataTypes, Sequelize } from "sequelize";
import AppConfig from "@/config";
import { logger } from "@/utils/serviceLog";
const sequelize = new Sequelize(AppConfig.MYSQL_SERVER);

const Account = sequelize.define("Account", {
	id: {
		type: DataTypes.INTEGER,
		primaryKey: true,
		autoIncrement: true,
	},
	username: {
		type: DataTypes.STRING,
		allowNull: false,
		unique: true,
	},
	password: {
		type: DataTypes.STRING,
		allowNull: false,
	},
	firstname: { type: DataTypes.STRING, allowNull: false },
	lastname: { type: DataTypes.STRING, allowNull: false },
	nickname: { type: DataTypes.STRING, allowNull: false },
	gender: {
		type: DataTypes.ENUM,
		defaultValue: "male",
		values: ["male", "female"],
	},
	birthday: {
		type: DataTypes.DATE,
	},
	level: {
		type: DataTypes.INTEGER,
	},
	following: {
		type: DataTypes.INTEGER,
	},
	follower: {
		type: DataTypes.INTEGER,
	},
	contact: {
		type: DataTypes.TEXT,
	},
});

const EventJoin = sequelize.define("EventJoin", {
	id: {
		type: DataTypes.INTEGER,
		primaryKey: true,
		autoIncrement: true,
	},
	account_id: {
		type: DataTypes.INTEGER,
		allowNull: false,
	},
	event_id: {
		type: DataTypes.INTEGER,
		allowNull: false,
	},
	accept: {
		type: DataTypes.BOOLEAN,
		allowNull: false,
		defaultValue: false,
	},
});

const Event = sequelize.define("Event", {
	id: {
		type: DataTypes.INTEGER,
		primaryKey: true,
		autoIncrement: true,
	},
	host_id: {
		type: DataTypes.INTEGER,
		allowNull: false,
	},
	title: {
		type: DataTypes.STRING,
		allowNull: false,
	},
	location: {
		type: DataTypes.STRING,
		allowNull: false,
	},
	detail: {
		type: DataTypes.TEXT,
		allowNull: false,
	},
	gender: {
		type: DataTypes.ENUM,
		values: ["male", "female"],
		defaultValue: "male",
	},
	eventDate: {
		type: DataTypes.DATE,
		allowNull: false,
	},
	subType_id: {
		type: DataTypes.INTEGER,
		allowNull: false,
	},
	minAge: {
		type: DataTypes.INTEGER,
		allowNull: false,
	},
	maxAge: {
		type: DataTypes.INTEGER,
		allowNull: false,
	},
	maxJoin: {
		type: DataTypes.INTEGER,
		allowNull: false,
	},
	awesome: {
		type: DataTypes.INTEGER,
		allowNull: false,
	},
});

const Type = sequelize.define("Type", {
	id: {
		type: DataTypes.INTEGER,
		allowNull: false,
		primaryKey: true,
		autoIncrement: true,
	},
	mainType: {
		type: DataTypes.STRING,
	},
	subType: {
		type: DataTypes.STRING,
	},
});

const Interest = sequelize.define("Interest", {
	id: {
		type: DataTypes.INTEGER,
		allowNull: false,
		primaryKey: true,
		autoIncrement: true,
	},
	subType_id: {
		type: DataTypes.INTEGER,
	},
	account_id: {
		type: DataTypes.INTEGER,
	},
});

// eslint-disable-next-line require-jsdoc
export async function initTables() {
	await Promise.all([
		Account.sync(),
		Interest.sync(),
		Type.sync(),
		Event.sync(),
		EventJoin.sync(),
	]);
	logger("Database", "ready", "✨", "😃");
}

export { Account, Event, EventJoin, Interest, Type };
