import consumer from "./consumer"

$(document).on("turbolinks:load", function(e) {
    consumer.subscriptions.create("CommentsChannel", {
        connected: function() {
            return this.perform('follow', {question_id: gon.question_id });
        },
        received(data) {
            if (gon.user_id !== data.user_id) {
                if (data.resource_type === "answer") {
                    $(`.${data.resource_type}-${data.resource_id}-comments`).append(data.comment.body);
                } else {
                    $(`.${data.resource_type}-comments`).append(data.comment.body)
                }
                window.GistEmbed.init()
            }
        }
    });
})

