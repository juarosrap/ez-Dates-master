"use strict";

import { usersAPI } from "/js/api/users.js";
import { usersRenderer } from "/js/renderers/users.js";

// DOM elements that we will use
const usersDiv = document.getElementById("userCards");

// Main function that will run when the page is ready
async function main() {
    let users = await usersAPI.getAll();
    let userCards = usersRenderer.asCardGallery(users);
    usersDiv.append(userCards);
}

document.addEventListener("DOMContentLoaded", main);