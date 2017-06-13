var exec = require('cordova/exec');
var esptouch={
	getWifiSSid : function(successCallback, errorCallback) {
	    exec(successCallback, errorCallback, "Esptouch", "getWifiSSid", []);
	},

	startSearch : function(ssid, password,successCallback, errorCallback) {
    exec(successCallback, errorCallback, "Esptouch", "startSearch", [ssid, password])
  },
	stopSearch : function(successCallback, errorCallback) {
	    exec(successCallback, errorCallback, "Esptouch", "stopSearch", []);
  }
};
module.exports = esptouch;