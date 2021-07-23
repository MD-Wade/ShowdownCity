"use strict";
/*
    Gamemaker: Studio 1.x/2 Socket.io extension
    https://github.com/IgnasKavaliauskas/SocketIO-GMS2-Extension
*/
var server = require('http').createServer();
var io = require('socket.io')(server, { cors: { origin: '*' } });
var port = 32452;
// Listen for incoming connections
server.listen(port, function (err) {
    if (err)
        throw err;
    console.log("Listening on port " + port);
});
var players = []; // all connected players will be stored here
var clientId = 0; // unique ID for every client
var Client = /** @class */ (function () {
    function Client(inData) {
        this.clientUsername = inData.clientUsername;
        this.clientSocket = inData.clientSocket;
        this.clientID = inData.clientID;
        this.playerArmDirection = inData.playerArmDirection;
    }
    Client.prototype.toString = function () {
        return JSON.stringify(this, this.replacer);
    };
    // Replace Server-Only Fields
    Client.prototype.replacer = function (key, value) {
        switch (key) {
            case "clientSocket":
                return undefined;
            default:
                return value;
        }
    };
    return Client;
}());
