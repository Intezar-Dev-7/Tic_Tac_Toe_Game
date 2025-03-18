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

    });

    // 
    socket.on('joinRoom', async ({ username, roomId }) => {
        console.log(username, roomId);
        try {
            if (!roomId.match(/^[0-9a-fA-F]{24}$/)) {
                socket.emit('errorOccurred, Please enter a valid room id');
                return;
            }
            let room = await Room.findById(roomId);
            if (room.isJoin) {
                let player = {
                    username,
                    socketID: socket.id,
                    playerType: 'O'
                }
                socket.join(roomId);
                room.players.push(player);
                room.isJoin = false;

                room = await room.save();
                io.to(roomId).emit('joinRoomSuccess', room);
                io.to(roomId).emit('updatePlayers', room.players);
                // update the room 
                io.to(roomId).emit('updateRoom', room);


            } else {
                socket.emit('errorOccurred, Game in progress , try agan later');
            }
        } catch (e) {
            console.log(e);
        }
    });


    socket.on("tap", async ({ index, roomId }) => {
        try {
            let room = await Room.findById(roomId);

            let choice = room.turn.playerType; // x or o
            if (room.turnIndex == 0) {
                room.turn = room.players[1];
                room.turnIndex = 1;

            }
            else {
                room.turn = room.players[0];
                room.turnIndex = 0;

            }
            room = await room.save();
            io.to(roomId).emit("tapped", {
                index, choice, room,
            });
        } catch (e) {
            console.log(e);
        }
    });

    socket.on('winner', async ({ winnerSocketId, roomId }) => {
        try {
            let room = await Room.findById(roomId);
            let player = room.players.find((player) => player.socketID == winnerSocketId);
            player.points += 1;
            room = await room.save();

            if (player.points >= room.maxRounds) {
                io.to(roomId).emit("endGame", player);
            } else {
                io.to(roomId).emit("pointIncrease", player);
            }
        } catch (e) {
            console.log(e);
        }
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