"use strict";

import { authAPI } from "/js/api/auth.js";
import { sessionManager } from "/js/utils/session.js";
import { messageRenderer } from "/js/renderers/messages.js";

// DOM elements that we will use
const loginForm = document.getElementById("login-form");
const errorsDiv = document.getElementById("errors");

// Main function that will run when the page is ready
function main() {
    // Handle the form's submit event
    loginForm.onsubmit = handleSubmitLogin;
}

///////////////////////////////////////////////////////////////////////////////

function handleSubmitLogin(event) {
    // Prevent the browser from sending the form,
    // because we'll do it using AJAX
    event.preventDefault();
    errorsDiv.innerHTML = "";

    let formData = new FormData(loginForm);
    sendLogin(formData);
}

async function sendLogin(formData) {

    try {
        let loginData = await authAPI.login(formData);

        // If the login is successful, store the session token and
        // the logged user data, and navigate to the main page.
        let sessionToken = loginData.sessionToken;
        let loggedUser = loginData.user;
        sessionManager.login(sessionToken, loggedUser);

        window.location.href = "index.html";
    } catch (error) {
        // If there is an error, access the mesage in the response and
        // show it to the user
        let message = error.response.data.message;
        messageRenderer.showErrorMessage(message);
    }
    
}

////////////////////////////////////////////////////////////////////////////////

document.addEventListener("DOMContentLoaded", main);