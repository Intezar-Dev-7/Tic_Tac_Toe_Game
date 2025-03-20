

// Importing required modules
const express = require("express"); // Express framework for handling HTTP requests
const http = require("http"); // HTTP module for creating a server
const mongoose = require("mongoose"); // Mongoose for database management

// Creating an Express application
const app = express();
const port = process.env.port || 3000; // Defining port number
var server = http.createServer(app); // Creating HTTP server instance

const Room = require('./models/room.js'); // Importing Room model
var io = require('socket.io')(server); // Setting up socket.io for real-time communication

// Middleware to parse JSON data from client requests
app.use(express.json());

// MongoDB connection string
const DB = "mongodb+srv://name:password@cluster0.dy6zb.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";

// Setting up socket.io connection event
io.on("connection", (socket) => {
    console.log("A user connected");

    // Handling room creation
    socket.on('createRoom', async ({ username }) => {
        console.log(`Creating room for ${username}`);

        try {
            let room = new Room(); // Creating a new room instance
            let player = {
                socketID: socket.id,
                username,
                playerType: "X", // First player is assigned "X"
            };
            room.players.push(player); // Adding player to the room
            room.turn = player; // Setting turn to the first player
            room = await room.save(); // Saving room to the database

            console.log("Room created: ", room);
            const roomId = room._id.toString();
            socket.join(roomId); // Joining the socket room

            // Notify client that the room was successfully created
            io.to(roomId).emit('createRoomSuccess', room);
        } catch (e) {
            console.log("Error creating room:", e);
        }
    });

    // Handling player joining a room
    socket.on('joinRoom', async ({ username, roomId }) => {
        console.log(`${username} attempting to join room ${roomId}`);
        try {
            // Validate room ID format
            if (!roomId.match(/^[0-9a-fA-F]{24}$/)) {
                socket.emit('errorOccurred', 'Please enter a valid room ID');
                return;
            }

            let room = await Room.findById(roomId);
            if (room.isJoin) {
                let player = {
                    username,
                    socketID: socket.id,
                    playerType: 'O', // Second player gets "O"
                };
                socket.join(roomId); // Joining the socket room
                room.players.push(player); // Adding player to the room
                room.isJoin = false; // Mark room as full
                room = await room.save(); // Saving room state

                // Notify all clients in the room about the new player
                io.to(roomId).emit('joinRoomSuccess', room);
                io.to(roomId).emit('updatePlayers', room.players);
                io.to(roomId).emit('updateRoom', room);
            } else {
                socket.emit('errorOccurred', 'Game in progress, try again later');
            }
        } catch (e) {
            console.log("Error joining room:", e);
        }
    });

    // Handling player move (tap event)
    socket.on("tap", async ({ index, roomId }) => {
        try {
            let room = await Room.findById(roomId);
            let choice = room.turn.playerType; // Get current player's type (X or O)

            // Switching turn between players
            if (room.turnIndex == 0) {
                room.turn = room.players[1];
                room.turnIndex = 1;
            } else {
                room.turn = room.players[0];
                room.turnIndex = 0;
            }

            room = await room.save(); // Save updated turn data

            // Notify all players about the move
            io.to(roomId).emit("tapped", { index, choice, room });
        } catch (e) {
            console.log("Error processing move:", e);
        }
    });

    // Handling game winner logic
    socket.on('winner', async ({ winnerSocketId, roomId }) => {
        try {
            let room = await Room.findById(roomId);
            let player = room.players.find((player) => player.socketID == winnerSocketId);
            player.points += 1; // Increment player's points
            room = await room.save(); // Save updated points

            if (player.points >= room.maxRounds) {
                io.to(roomId).emit("endGame", player); // End game if max rounds reached
            } else {
                io.to(roomId).emit("pointIncrease", player); // Notify about point increase
            }
        } catch (e) {
            console.log("Error handling winner:", e);
        }
    });
});

// Connecting to MongoDB database
mongoose.connect(DB).then(() => {
    console.log('Database connection successful');
}).catch((e) => {
    console.log('Database connection error:', e);
});

// Starting the server
server.listen(port, '0.0.0.0', () => {
    console.log(`Server started and running on port ${port}`);
});

/*
Quick Analogy:
- socket.io is like a telephone network 📞 – it establishes the connection.
- socket.on is like answering a call 📲 – it listens for messages. 
*/


