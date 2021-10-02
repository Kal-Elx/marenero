const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");
const querystring = require("querystring");
admin.initializeApp();

/**
 * Generates a random code.
 * @return {string}
 */
function generateCode() {
  const chars = "0123456789";
  const codeLength = 5;
  let res = "";
  for (let i = 0; i < codeLength; i++) {
    const rnum = Math.floor(Math.random() * chars.length);
    res += chars.substring(rnum, rnum + 1);
  }
  return res;
}

/**
 * Checks if a given party code exists.
 * @param {string} code - Party code.
 * @return {Promise<bool>}
 */
function codeExists(code) {
  return admin.firestore().collection("parties").where("code", "==", code)
      .limit(1).get().then((snap) => {
        if (!snap.empty) {
          console.log("Code duplicate: " + code);
          return true;
        } else {
          return false;
        }
      });
}

/**
 * Generates a unique party code.
 * @return {Promise<string>}
 */
function generateUniquePartyCode() {
  const code = generateCode();
  return codeExists(code).then((exists) => {
    if (exists) {
      return generateUniquePartyCode();
    } else {
      return code;
    }
  });
}

exports.setPartyID = functions.firestore.document("parties/{documentId}")
    .onCreate((snap, _) => {
      const tracks = [];
      return generateUniquePartyCode().then(
          (code) => snap.ref.set({code, tracks}, {merge: true}));
    });

/**
 * Returns the encoded string needed to get the access token.
 * @return {Promise<String>}
 */
function getEncodedString() {
  return admin.firestore().collection("secret_app_info").doc("secrets").get()
      .then((snap) => {
        const clientId = snap.get("client_id");
        const clientSecret = snap.get("client_secret");
        return Buffer.from(
            clientId + ":" + clientSecret
        ).toString("base64");
      });
}

exports.setAccessToken = functions.firestore.document("parties/{documentId}")
    .onCreate((snap, _) => {
      const apiURL = "https://accounts.spotify.com/api/token";
      const apiData = {
        grant_type: "client_credentials",
      };

      return getEncodedString().then((encodedStr) => {
        console.log("Encoded string: " + encodedStr);
        const config = {
          headers: {
            Authorization: "Basic " + encodedStr,
          },
        };
        return axios.post(apiURL,
            querystring.stringify(apiData),
            config
        )
            .then((response) => {
              console.log("Request success: " + response.data.toString());
              const token = response.data["access_token"];
              return snap.ref.set({token}, {merge: true});
            }, (error) => {
              console.log(error);
            });
      });
    });

exports.addCreationDate = functions.firestore.document("parties/{documentId}")
    .onCreate((snap, _) => {
      const created = admin.firestore.FieldValue.serverTimestamp();
      return snap.ref.set({created}, {merge: true});
    });

exports.cleanup = functions.pubsub.schedule("every 24 hours")
    .onRun((_) => {
      const yesterday = new Date();
      yesterday.setDate(yesterday.getDate() - 1);

      return admin.firestore().collection("parties").where(
          "created", "<", admin.firestore.Timestamp.fromDate(yesterday)).get()
          .then((querySnapshot) => {
            querySnapshot.forEach((doc) => {
              const batch = admin.firestore().batch();

              querySnapshot.forEach(function(doc) {
                batch.delete(doc.ref);
              });

              return batch.commit();
            });
          });
    });
