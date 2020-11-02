"use strict";

//const getMyJwtToken = "eyJhbGciOiJSUzI1NiIsImtpZCI6ImQxOTI5ZmY0NWM2MDllYzRjNDhlYmVmMGZiMTM5MmMzOTEzMmQ5YTEiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vc2lnbmFsci10ZXN0LWU0NDcxIiwiYXVkIjoic2lnbmFsci10ZXN0LWU0NDcxIiwiYXV0aF90aW1lIjoxNjA0MjkwMzMwLCJ1c2VyX2lkIjoiRnU2OGRQcUxDbFZsWmhKSG9FZ1hKOVM5cVdZMiIsInN1YiI6IkZ1NjhkUHFMQ2xWbFpoSkhvRWdYSjlTOXFXWTIiLCJpYXQiOjE2MDQyOTAzMzAsImV4cCI6MTYwNDI5MzkzMCwiZW1haWwiOiJteWVtYWlsQGFkZHJlc3MuY2hhbmdlbWUiLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsImZpcmViYXNlIjp7ImlkZW50aXRpZXMiOnsiZW1haWwiOlsibXllbWFpbEBhZGRyZXNzLmNoYW5nZW1lIl19LCJzaWduX2luX3Byb3ZpZGVyIjoicGFzc3dvcmQifX0.g8ABWZqsE4rttV6Ze9CDRliEp4VFRVuggCAteIaXwGObb3cXkLv5IM3nb39H8NB45eyeMBGKx47YOtNITYIB0PECCdSBDGNegKmCLQw_ue2Fb8Mbu_hbOyBEAT3oR6irWxLTcAvhGPplcd5vgKv4AozygP0eG-UPV_wyXdV8UMuY6ipT-z__mOaQqLul5R0ULYMBIqj1XyWvLO_tpKs1FwPuphdZVO3MPngn_ZppevkIsJ_44vFDl011YPBhSoggt7DokQUR9YRXgWJHpnawVLVD_fNh060CSxfKFW8FpwH7LcnrR_ot9wcTmfOkTzlNViNJEzBxzYZL09TrPE4keQ";
var connection;

//Disable send button until connection is established
document.getElementById("sendButton").disabled = true;

document.getElementById("tokenButton").addEventListener("click", function (event) {
    var token = document.getElementById("tokenInput").value;
    connection = new signalR.HubConnectionBuilder().withUrl("/chatHub", {
        accessTokenFactory: () => token
    }).build();

    connection.on("ReceiveMessage", function (user, message) {
        var msg = message.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
        var encodedMsg = user + " says " + msg;
        var li = document.createElement("li");
        li.textContent = encodedMsg;
        document.getElementById("messagesList").appendChild(li);
    });

    connection.start().then(function () {
        document.getElementById("sendButton").disabled = false;
    }).catch(function (err) {
        return console.error(err.toString());
    });
});


document.getElementById("sendButton").addEventListener("click", function (event) {
    var user = document.getElementById("userInput").value;
    var message = document.getElementById("messageInput").value;
    connection.invoke("SendMessage", user, message).catch(function (err) {
        return console.error(err.toString());
    });
    event.preventDefault();
});