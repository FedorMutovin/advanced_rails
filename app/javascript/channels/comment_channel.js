import consumer from "./consumer"

$(document).on("turbolinks:load", function(e) {
    consumer.subscriptions.create("CommentsChannel", {
        connected: function() {
            return this.perform('follow', {question_id: gon.question_id });
        },
        received(data) {
            if (gon.user_id !== data.user_id) {
                const template = require("./handlebars/comment.hbs")(data)
                if (data.resource_type === "answer") {
                    $(`.${data.resource_type}-${data.resource_id}-comments`).append(template);
                } else {
                    $(`.${data.resource_type}-comments`).append(template)
                }
                window.GistEmbed.init()
            }
        }
    });
})

