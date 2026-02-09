// Import the functions you need from the SDKs you need
import { initializeApp } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-app.js";
import { getAuth } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-auth.js";
import { getFirestore } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-firestore.js";
import { getStorage } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-storage.js";

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyCTasoMz8zus6DTRwCvu4_sA7NxX679pyQ",
  authDomain: "globe-app-8da95.firebaseapp.com",
  projectId: "globe-app-8da95",
  storageBucket: "globe-app-8da95.firebasestorage.app",
  messagingSenderId: "583301066696",
  appId: "1:583301066696:web:039faac4f7892ba0291afd"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const db = getFirestore(app);
export const storage = getStorage(app);