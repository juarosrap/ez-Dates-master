"use strict";

import { BASE_URL, requestOptions } from './common.js';

const usersAPI = {

    /**
    * Gets all Users
    */
    getAll: async function() {
        let response = await axios.get(`${BASE_URL}/users`, requestOptions);
        return response.data;
    },

};

export { usersAPI };