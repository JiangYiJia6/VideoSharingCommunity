// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyAT2SNQ9C_3kCG0lnSMkCtCBx-CmkxtjcU",
  authDomain: "videosharingcommunity-7ec61.firebaseapp.com",
  projectId: "videosharingcommunity-7ec61",
  storageBucket: "videosharingcommunity-7ec61.firebasestorage.app",
  messagingSenderId: "695189731867",
  appId: "1:695189731867:web:d4e4cd6842bd1e52fed6be",
  measurementId: "G-781YCPQMP7",
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);
