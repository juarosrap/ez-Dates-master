"use strict";

import { parseHTML } from "/js/utils/parseHTML.js";

const usersRenderer = {
    asCard: function (user) {
        let html = `<div class="card mb-3 shadow-sm">
                        <img src="images/avatar.webp" class="img-fluid card-image embed-responsive-item">
                        
                        <div class="card-body">
                            <h5 class="card-title text-center">${user.fullName}</h5>
                            <p class="card-text">@${user.username}</p>
                        </div>
                    </div>`;
        let card = parseHTML(html);
        return card;
    },

    asCardGallery: function (users) {
        let gallery = parseHTML(`<div class="row text-center"></div>`);

        for (let user of users) {
            let col = parseHTML(`<div class="col-md-4"></div>`);
            let card = this.asCard(user);

            col.append(card);
            gallery.append(col);
        }

        return gallery;
    }
};

export { usersRenderer };