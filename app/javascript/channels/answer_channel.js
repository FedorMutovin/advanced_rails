import consumer from "./consumer"

$(document).on("turbolinks:load", function(e) {

    consumer.subscriptions.create("AnswersChannel", {
        connected: function() {
            return this.perform('follow', {question_id: gon.question_id });
        },
        received(data) {
            if (!(gon.user_id === data.user_id)) {
                const template = require("./handlebars/answer.hbs")(data)
                $(".answers").append(template);
            }
        }
    });
})
