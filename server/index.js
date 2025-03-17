// Importing  modules 

const express = require("express");
const http = require("http");
const mongoose = require("mongoose");
//

const app = express();
const port = process.env.port || 3000;
var server = http.createServer(app);
const Room = require('./models/room.js');
var io = require('socket.io')(server);


// Client -> middleware -> server
// middleware 
app.use(express.json());

const DB = "mongodb+srv://intezar:test1234@cluster0.dy6zb.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";

// setting up socket io
io.on("connection", (socket) => {
    console.log("connected");
    socket.on('createRoom', async ({ username }) => {
        console.log(username);

        try {
            // room is created 
            let room = new Room();
            let player = {
                socketID: socket.id,
                username,
                playerType: "X",

            };
            room.players.push(player);
            // player is stored in the room 
            room.turn = player;
            room = await room.save();
            console.log(room);
            const roomId = room._id.toString();
            socket.join(roomId);

            // io => send data to everyone 
            // socket => sending data to yourself 
            io.to(roomId).emit('createRoomSuccess', room);

        } catch (e) {
            console.log(e);
        }
        // player is taken to the next screen
    });
});

mongoose.connect(DB).then(() => {
    console.log('Connection successfull');
}).catch((e) => {
    console.log(e);
});


server.listen(port, '0.0.0.0', () => {
    console.log(`Server started and running on port ${port} `);
});



/*
Quick Analogy
socket.io is like a telephone network 📞 – it establishes the connection.
socket.on is like answering a call 📲 – it listens for messages. 
*/