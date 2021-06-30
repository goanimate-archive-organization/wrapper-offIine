const loadPost = require("../misc/post_body");
const formidable = require("formidable");
const asset = require("./main");
const http = require("http");
const fs = require("fs");
const fUtil = require("../misc/file");

/**
 * @param {http.IncomingMessage} req
 * @param {http.ServerResponse} res
 * @param {import("url").UrlWithParsedQuery} url
 * @returns {boolean}
 */
module.exports = function (req, res, url) {
	if (req.method != "POST") return;
	switch (url.pathname) {
		case "/upload_asset":
			formidable().parse(req, (_, fields, files) => {
				var [mId, mode, ext] = fields.params.split(".");
				switch (mode) {
					case "vo":
						mode = "voiceover";
						ext = "mp3";
						break;
					case "se":
						mode = "soundeffect";
						ext = "mp3";
						break;
					case "mu":
						mode = "music";
						ext = "mp3";
						break;
					case "prop":
						mode = "prop";
						ext = "png";
						break;
					case "bg":
						mode = "bg";
						ext = "jpg";
						break;
				}
				var path = files.import.path;
				var buffer = fs.readFileSync(path);
				asset.save(buffer, mId, mode, ext)
				res.end(`0${mode}-${fUtil.padZero(fUtil.getNextFileId(mode + "-", "." + ext), 7)}.${ext}`);
				fs.unlinkSync(path);
				delete buffer;
			});
			return true;
		case "/goapi/saveSound/":
			loadPost(req, res).then(([data]) => {
				var bytes = Buffer.from(data.bytes, "base64");
				res.end("0" + asset.save(bytes, mId, "voiceover", "ogg"));
			});
			return true;
		case "/goapi/saveTemplate/":
			loadPost(req, res).then(([data, mId]) => {
				var body = Buffer.from(data.body_zip, "base64");
				res.end("0" + asset.save(body, mId, "starter", "xml"));
			});
			return true;
	}
};
