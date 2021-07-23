/*
    Gamemaker: Studio 1.x/2 Socket.io extension 
    https://github.com/IgnasKavaliauskas/SocketIO-GMS2-Extension
*/

const server = require('http').createServer()
const io = require('socket.io')(server, { cors: { origin: '*' } });

const port = 32452;

// Listen for incoming connections
server.listen(port, (err: object) => {
    if (err) throw err
    console.log(`Listening on port ${port}`);
});

var players = []; // all connected players will be stored here
var clientId = 0; // unique ID for every client

//ok
class Client {
    clientUsername: string;
    clientSocket: object;
    clientID: string;

    clientPlayer: Player;

    constructor(inData: any) {
        this.clientUsername = inData.clientUsername;
        this.clientSocket = inData.clientSocket;
        this.clientID = inData.clientID;
        this.clientPlayer = new Player({playerArmDirection: 0});
    }

    toString() {
        return JSON.stringify(this, this.replacer);
    }

    // Replace Server-Only Fields
    replacer(key: string, value: any) {
        switch (key)    {
            case "clientSocket":
                return undefined;
            default:
                return value;
        }
    }
}

class Player    {
    playerArmDirection: number;
    constructor(inData: any)    {
        this.playerArmDirection = inData.playerArmDirection;
    }
}