const functions = require("firebase-functions");
const admin = require("firebase-admin");
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
      const started = false;
      return generateUniquePartyCode().then(
          (code) => snap.ref.set({code, started}, {merge: true}));
    });
