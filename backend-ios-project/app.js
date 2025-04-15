const express = require("express");
const multer = require("multer");
const { v4: uuidv4 } = require("uuid");
const admin = require("firebase-admin");
const cloudinary = require("cloudinary").v2;
require("dotenv").config();

const app = express();
const port = 3000;

// Firebase setup
const serviceAccount = require("./serviceAccountKey.json");
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});
const db = admin.firestore();
const collection = db.collection("items");

// Cloudinary setup
cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET,
});

// Multer setup for handling file uploads
const storage = multer.memoryStorage();
const upload = multer({ storage });

app.use(express.json());

app.get("/test", (req, res) => {
  return res.json({ mesage: "IOS testing" });
});

// Create (Upload video to Cloudinary and save data to Firestore)
app.post("/items", upload.single("video"), async (req, res) => {
  try {
    const file = req.file;
    const { name, tag, comments, userId } = req.body;

    if (!file) return res.status(400).json({ error: "No file uploaded" });

    cloudinary.uploader
      .upload_stream(
        { resource_type: "video" },
        async (error, cloudinaryResult) => {
          if (error) return res.status(500).json({ error: error.message });

          const id = uuidv4();
          await collection.doc(id).set({
            id,
            userId: userId || "defaultUser", // Handle missing userId
            name,
            tag,
            comments: comments ? JSON.parse(comments) : [],
            videoUrl: cloudinaryResult.secure_url,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
          });

          res.json({
            message: "Item created",
            id,
            videoUrl: cloudinaryResult.secure_url,
          });
        }
      )
      .end(file.buffer);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Read (Get all items)
app.get("/items", async (req, res) => {
  try {
    const snapshot = await collection.get();
    const items = snapshot.docs.map((doc) => doc.data());
    res.json(items);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Read (Get a single item by ID)
app.get("/items/:id", async (req, res) => {
  try {
    const doc = await collection.doc(req.params.id).get();
    if (!doc.exists) return res.status(404).json({ error: "Item not found" });
    res.json(doc.data());
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Update (Modify an existing item)
app.put("/items/:id", async (req, res) => {
  try {
    const { name, comments } = req.body;
    await collection
      .doc(req.params.id)
      .update({ name, comments: comments ? JSON.parse(comments) : [] });
    res.json({ message: "Item updated" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Delete (Remove an item)
app.delete("/items/:id", async (req, res) => {
  try {
    await collection.doc(req.params.id).delete();
    res.json({ message: "Item deleted" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});

// Add a comment to an existing item
app.post("/items/:id/comments", async (req, res) => {
  try {
    const { comment } = req.body;
    const itemId = req.params.id;

    if (!comment) return res.status(400).json({ error: "Comment is required" });

    const itemDoc = await collection.doc(itemId).get();
    if (!itemDoc.exists) {
      return res.status(404).json({ error: "Item not found" });
    }

    const itemData = itemDoc.data();
    const updatedComments = itemData.comments || [];

    updatedComments.push(comment);

    await collection.doc(itemId).update({ comments: updatedComments });

    res.json({
      message: "Comment added successfully",
      comments: updatedComments,
    });
  } catch (err) {
    console.error("Error in POST /items/:id/comments:", err);
    res.status(500).json({ error: err.message });
  }
});
