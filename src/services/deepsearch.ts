export default (event, query) => {
	const keywords = query.split(" ");
	let isMatch = false;
	keywords.forEach((keyword) => {
		let score = "";
		let rightKeyword = "";
		let hidden = 0;
		for (let k = 0; k < keyword.length; k++) {
			score += keyword[k];
			if (
				event.title.toLowerCase().includes(score.toLowerCase()) ||
				event.detail.toLowerCase().includes(score.toLowerCase())
			) {
				console.log("score", score, event.title, event.detail);
				rightKeyword = score;
			} else {
				hidden--;
			}
		}

		if (
			event.title.toLowerCase().includes(rightKeyword) ||
			event.detail.toLowerCase().includes(rightKeyword)
		) {
			isMatch = true;
		}

		if (hidden <= -2) {
			isMatch = false;
		}
	});
	return isMatch;
};
