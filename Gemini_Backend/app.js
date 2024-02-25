import { GoogleGenerativeAI } from "@google/generative-ai";
import dotenv from 'dotenv';
import express from 'express';
import { promises as fs } from 'fs';
import multer from 'multer';
import path from 'path';
import cors from 'cors';

const app = express();
app.use(cors());
app.use(express.json());

dotenv.config();


app.use(express.json({ limit: '100mb' }));


app.route("/Gemini_pro")
  .get(async (req, res) => {
    const api_key = process.env.GEMINI_API_KEY;
    const genAI = new GoogleGenerativeAI(api_key);
    const generationConfig = { temperature: 0.9, topP: 1, topK: 1, maxOutputTokens: 4096 };
    const model = genAI.getGenerativeModel({ model: "gemini-pro", generationConfig });

    const prompt = req.query.prompt || "Hello";

    try {
      const result = await model.generateContent(prompt);
      const response = await result.response;
      console.log(response.text());
      res.send(response.text());
    } catch (error) {
      console.error('Error generating content:', error);
      res.status(500).send('Error generating content');
    }
  })
  .post(async (req, res) => {
    const api_key = process.env.GEMINI_API_KEY;
    const genAI = new GoogleGenerativeAI(api_key);
    const generationConfig = { temperature: 0.9, topP: 1, topK: 1, maxOutputTokens: 4096 };
    const model = genAI.getGenerativeModel({ model: "gemini-pro", generationConfig });

    const requestData = req.body.data;

    try {
      const result = await model.generateContent(requestData);
      const response = await result.response;
      console.log(response.text());
      res.send(response.text());
    } catch (error) {
      console.error('Error generating content:', error);
      res.status(500).send('Error generating content');
    }
  });

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/');
  },
  filename: (req, file, cb) => {
    cb(null, file.fieldname + path.extname(file.originalname));
  },
});

const upload = multer({ storage: storage });

app.post('/upload', upload.single('image'), (req, res) => {
  try {
    console.log('Image uploaded successfully.');
    res.status(200).send('Image uploaded successfully.');
  } catch (error) {
    console.error('Error uploading image:', error);
    res.status(500).send('Error uploading image.');
  }
});

app.route("/Gemini_pro_vision")
  .get(async (req, res) => {
    const api_key = process.env.GEMINI_API_KEY;
    const genAI = new GoogleGenerativeAI(api_key);
    const generationConfig = { temperature: 0.4, topP: 1, topK: 32, maxOutputTokens: 4096 };

    const model = genAI.getGenerativeModel({ model: "gemini-pro-vision", generationConfig });

    try {
      const imagePath = 'image.jpg';
      const imageData = await fs.readFile("uploads/image.jpg");
      const imageBase64 = imageData.toString('base64');

      const parts = [
        { text: "Give me in detail information about its uses and info in detail if it is related to health or else say its not related to heath\n" },
        {
          inlineData: {
            mimeType: "image/jpeg",
            data: imageBase64
          }
        },
      ];

      const result = await model.generateContent({ contents: [{ role: "user", parts }] });
      const response = await result.response;
      console.log(response.text());
      res.send(response.text());
    } catch (error) {
      console.error('Error generating content:', error);
      res.status(500).send('Error generating content');
    }
  })
  .post(upload.single('image'), async (req, res) => {
    const api_key = process.env.GEMINI_API_KEY;
    const genAI = new GoogleGenerativeAI(api_key);
    const generationConfig = { temperature: 0.4, topP: 1, topK: 32, maxOutputTokens: 4096 };

    const model = genAI.getGenerativeModel({ model: "gemini-pro-vision", generationConfig });

    try {
      const imagePath = req.file.path;
      const imageData = await fs.readFile(imagePath);
      const imageBase64 = imageData.toString('base64');

      const parts = [
        { text: "Give me in detail information about its uses and info in detail if it is related to health or else send the response that its not related to heath\n" },
        {
          inlineData: {
            mimeType: "image/jpeg",
            data: imageBase64
          }
        },
      ];

      const result = await model.generateContent({ contents: [{ role: "user", parts }] });
      const response = await result.response;
      console.log(response.text());
      res.send(response.text());
    } catch (error) {
      console.error('Error generating content:', error);
      res.status(500).send('Error generating content');
    }
  });

app.listen(3000, function () {
  console.log("server started");
});
