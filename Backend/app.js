const { MongoClient, ServerApiVersion } = require('mongodb');
const uri = "";
const express= require('express');
const cors=require('cors');
const bodyParser = require('body-parser');

const app = express();
app.use(cors());
app.use(bodyParser.json());


const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  username: {
    type: String,
    required: true,
    unique: true,
  },
  email: {
    type: String,
    required: true,
    unique: true,
  },
  password: {
    type: String,
    required: true,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

const User = mongoose.model('User', userSchema);

mongoose.connect('', { useNewUrlParser: true, useUnifiedTopology: true });


app.post('/CreateUser', async (req, res) => {
  const userData = req.body.user;
  const emailData = req.body.email;
  const passwordData = req.body.password;

  try {
    const newUser = new User({
      username: userData,
      email: emailData,
      password: passwordData,
    });

    const savedUser = await newUser.save();
    console.log('User created:', savedUser);

    res.status(200).json({ message: 'User created successfully' });
  } catch (error) {
    console.error('Error creating user:', error.message);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


app.post('/FindUser', async (req, res) => {
  const requestData = req.body;

  console.log('Received data:', requestData);

  const userData = req.body.email;
  const passwordData = req.body.password;

  try {
    const user = await User.findOne({ email: userData });
    if (user) {
      console.log('User found:', user);
      res.status(200).json({ message: 'User found successfully', user });
    } else {
      console.log('User not found');
      res.status(404).json({ message: 'User not found' });
    }
  } catch (error) {
    console.error('Error finding user:', error.message);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


app.listen(3001, () => {
  console.log(`Server is running on port 3000`);
});