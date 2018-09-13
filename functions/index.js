const functions = require('firebase-functions');
const admin = require('firebase-admin');
const nodemailer = require('nodemailer');

admin.initializeApp();
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions

exports.observeRides = functions.database.ref('/rides/{rideid}').onCreate((snapshot, context) => {
   var rideid = snapshot.val()
   console.log(rideid)

    createEmail(rideid)
    return 0
})

function createEmail(rideId) {
    // create reusable transport method (opens pool of SMTP connections)
    let smtpTransport = nodemailer.createTransport({
        service: 'gmail',
        secure: false,
        port: 25,
        auth: {
          user: 'dummmy1396@gmail.com',
          pass: 'harami1947'
        },
        tls: {
          rejectUnauthorized: false
        }
      });
 
    // setup e-mail data with unicode symbols
    var mailOptions = {
        from: "Global Crew Services <dummmy1396@gmail.com>", // sender address
        to: "praguns100@gmail.com", // list of receivers
        subject: "New ride confirmed from mobile app", // Subject line
        text: "From Location: " + rideId.From_Port + "/n" + "To Location: " + rideId.To_Port + "/n" +
        "Vessel Name: " + rideId.Vessel_Name + "/n" + "Confirmation Code: " + rideId.confirmationCode // plaintext body
    }
 
    // send mail with defined transport object
    smtpTransport.sendMail(mailOptions, function(error, response){
        if(error){
            console.log(error);
        }else{
            console.log("Message sent: " + response);
        }

        smtpTransport.close(); // shut down the connection pool, no more messages
    });
}