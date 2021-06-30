const chars = require("../character/main");
const fUtil = require("../misc/file");
const caché = require("./caché");
const fs = require("fs");
const importFolder = process.env.IMPORT_FOLDER;

function save(id, data, type, ext) {
	const i = id.indexOf("-");
	const prefix = id.substr(0, i);
	const suffix = id.substr(i + 1);
	fs.writeFileSync(fUtil.getFileIndex(type + "-", "." + ext, suffix, 1), data);
	return id;
}

module.exports = {
	load(mId, aId) {
		return caché.load(mId, aId);
	},
	save(buffer, mId, mode, ext) {
		return new Promise((res, rej) => {
			switch (mode) {
				case "prop":
					sMode = "p";
					break;
				case "bg":
					sMode = "b";
					break;
			}
			switch (ext) {
				case "jpg":
				case "jpeg":
				case "jfif":
				case "gif":
					ext = "png";
					break;
			}
			var saveId = `${sMode}-${fUtil.getNextFileIdImport(mode + "-", "." + ext)}`;
			res(save(saveId, buffer, mode, ext));
		})	
	},
	listAll() {
		var ret = [];
		fs.readdir(importFolder, (err, files) => {
			files.forEach((aId) => {
				var dot = aId.indexOf(".");
				var dash = aId.lastIndexOf("-");
				var name = aId.substr(dash + 1, dot);
				var fMode = aId.substr(0, dash);
				console.log(aId, name, fMode);
				ret.push({ id: aId, name: name, mode: fMode });
			});
		});
		return ret;
	},
	listAsset(mode) {
		switch (mode) {
			case "prop":
				sMode = "p";
				ext = "png";
			break;
			case "bg":
				sMode = "b";
				ext = "jpg";
			break;
			case "sound":
				sMode = "s"
				ext = "mp3";
				subtype = "music"; 
			break;
		}
		return new Promise(async (res, rej) => {
			var table = [];
			var ids = fUtil.getValidFileIndiciesImport(`${mode}-`, `.${ext}`);
			for (const i in ids) {
				var id = `${mode}-${fUtil.padZero(ids[i], 7)}`;
				var sId = `${sMode}-${ids[i]}`;
				var fileName = `${mode}-${fUtil.padZero(ids[i], 7)}.${ext}`;
				if (mode == "sound") {
					table.unshift({ subtype: subtype, id: id, duration: duration });
				} else {
					table.unshift({ id: id, sId: sId, fileName: fileName });
				}
			}
			res(table);
		});
	},
	chars(theme) {
		return new Promise(async (res, rej) => {
			switch (theme) {
				case "custom":
					theme = "family";
					break;
				case "action":
				case "animal":
				case "space":
				case "vietnam":
					theme = "cc2";
					break;
			}

			var table = [];
			var ids = fUtil.getValidFileIndicies("char-", ".xml");
			for (const i in ids) {
				var id = `c-${ids[i]}`;
				if (!theme || theme == (await chars.getTheme(id))) {
					table.unshift({ theme: theme, id: id });
				}
			}
			res(table);
		});
	},
};
