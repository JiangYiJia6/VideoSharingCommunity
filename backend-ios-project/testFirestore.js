const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

async function testFirestore() {
  try {
    const docRef = db.collection("test").doc("sampleDoc");
    await docRef.set({ testField: "Hello Firestore!" });

    const doc = await docRef.get();
    console.log("Document data:", doc.data());
  } catch (error) {
    console.error("Firestore error:", error);
  }
}

testFirestore();
