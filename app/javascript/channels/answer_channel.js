import consumer from "./consumer"

$(document).on("turbolinks:load", function(e) {

    consumer.subscriptions.create("AnswersChannel", {
        connected: function() {
            return this.perform('follow', {question_id: gon.question_id });
        },
        received(data) {
            if (gon.user_id !== data.user_id) {
                $(".answers").append(data.answer.body);
                window.GistEmbed.init()
            }
        }
    });
})
