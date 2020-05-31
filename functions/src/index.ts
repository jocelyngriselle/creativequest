import * as functions from 'firebase-functions';

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript
//
export const generateIdeas = functions.https.onRequest((request, response) => {

  const firebase = require("firebase");
  const ideas = require('./ideas.json');
  // Required for side-effects
  require("firebase/firestore");

  const firebaseConfig = {
    apiKey: "AIzaSyBcj1yRkE7TGhbt6a9qOEh5RcIyuPjYlt4",
    authDomain: "creativequest-9e995.firebaseapp.com",
    databaseURL: "https://creativequest-9e995.firebaseio.com",
    projectId: "creativequest-9e995",
    storageBucket: "creativequest-9e995.appspot.com",
    messagingSenderId: "180800972641",
    appId: "1:180800972641:web:8d2f567157353c61890720",
    measurementId: "G-B9F6W8K3W2"
  };

  // Initialize Cloud Firestore through Firebase
  firebase.initializeApp(firebaseConfig);

  var db = firebase.firestore();

  const images = ["laptop", "compressor", "mixer", "speakers", "tape-recorder"];

  ideas.forEach(function(idea) {
      db.collection("ideas").add({
        "description" : idea.description,
        "imageSlug" : images[Math.floor(Math.random() * images.length)],
        "action" : db.doc("actions/" + idea.action),
        "isValidated": true
      }).then(function(docRef) {
          console.log("Document written with ID: ", docRef.id);
      })
      .catch(function(error) {
          console.error("Error adding document: ", error);
      });

  });
  response.send("Hello from Firebase i'm generating ideas!");
 });
