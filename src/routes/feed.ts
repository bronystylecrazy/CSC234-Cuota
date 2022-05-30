import { Account, Event, EventJoin, Type } from "@/database/models";
import express, { Request } from "express";
import moment from "moment";
// eslint-disable-next-line new-cap
const feedRoute = express.Router();


feedRoute.get('/joiners/:id', async (req, res) => {
    const id = req.params.id;
    const account_id = req.user.user_id;

    const [event, eventJoins, accounts]: [any, any[], any[]] = await Promise.all([
        Event.findOne({
            where: { id }
        }),
        EventJoin.findAll({}),
        Account.findAll({})
    ]);

    if (event) {
        // let eventResult = {
        //     ...event.dataValues,
        //     host:
        //         accounts.find((account) => account.id === event.host_id)
        //             ?.firstname +
        //         " " +
        //         accounts.find((account) => account.id === event.host_id)?.lastname,
        //     hostAvatarUrl:
        //         accounts.find((account) => account.id === event.host_id)
        //             ?.avatarUrl || "/storage/placeholder.jpg",
        //     eventImageUrl: event.eventImageUrl || "/storage/placeholder_bg.png",
        //     joined: eventJoins.filter(
        //         (eventJoin) => eventJoin.event_id === event.id && eventJoin.accept
        //     ),
        //     subType_name:
        //         categories.find((c) => c.id === event.subType_id)?.mainType || "",
        // }
        return res.json({
            message: "Get event successful",
            success: true,
            data: eventJoins.filter(
                (eventJoin) => eventJoin.event_id === event.id && eventJoin.accept
            ).map((eventJoin) => ({
                ...eventJoin.dataValues, avatarUrl:
                    accounts.find((account) => account.id === event.host_id)
                        ?.avatarUrl || "/storage/placeholder.jpg", account: accounts.find((account) => account.id === eventJoin.account_id)
            })),
            joined: eventJoins.filter((eventJoin) => eventJoin.event_id === event.id && eventJoin.accept && eventJoin.account_id === account_id).length > 0,
        });
    }

    return res.json({
        message: "Event not found",
        success: false,
        data: {}
    });
});

feedRoute.post('/join/:id', async (req, res) => {
    const id = req.params.id;
    const account_id = req.user.user_id;

    const [event, eventJoin, accounts]: [any, any, any[]] = await Promise.all([
        Event.findOne({
            where: { id }
        }),
        EventJoin.findOne({
            where: {
                event_id: id,
                account_id
            }
        }),
        Account.findAll({})
    ]);

    if (event) {
        if (eventJoin) {
            return res.json({
                message: "You have already joined this event!",
                success: false,
                data: {}
            });
        }

        if (event.host_id === account_id) {
            return res.json({
                message: "Your cannot join your own event again!",
                success: false,
                data: {}
            });
        }

        if (event.gender.toLowerCase() !== accounts.find(account => account.id === account_id).gender.toLowerCase()) {
            return res.json({
                message: "Your gender isn't allowed for this event!",
                success: false,
                data: {}
            });
        }

        const newEventJoin = await EventJoin.create({
            event_id: event.id,
            account_id,
            accept: true
        });

        return res.json({
            message: "Join event successful",
            success: true,
            data: newEventJoin
        });
    }

    return res.json({
        message: "Event not found",
        success: false,
        data: {}
    });
});

feedRoute.get('/:id', async (req, res) => {
    const id = req.params.id;

    const [accounts, event, eventJoins, categories]: [any[], any, any[], any[]] = await Promise.all([
        Account.findAll({}),
        Event.findOne({
            where: { id }
        }),
        EventJoin.findAll({}),
        Type.findAll({})
    ]);

    if (event) {
        let eventResult = {
            ...event.dataValues,
            host:
                accounts.find((account) => account.id === event.host_id)
                    ?.firstname +
                " " +
                accounts.find((account) => account.id === event.host_id)?.lastname,
            hostAvatarUrl:
                accounts.find((account) => account.id === event.host_id)
                    ?.avatarUrl || "/storage/placeholder.jpg",
            eventImageUrl: event.eventImageUrl || "/storage/placeholder_bg.png",
            joined: eventJoins.filter(
                (eventJoin) => eventJoin.event_id === event.id && eventJoin.accept
            ).length,
            subType_name:
                categories.find((c) => c.id === event.subType_id)?.mainType || "",
        }
        return res.json({
            message: "Get event successful",
            success: true,
            data: eventResult
        });
    }

    return res.json({
        message: "Event not found",
        success: false,
        data: {}
    });
});





export default feedRoute;