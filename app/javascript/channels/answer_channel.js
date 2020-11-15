import consumer from "./consumer"

$(document).on("turbolinks:load", function(e) {
    const question_id = $("#question-channel-provider").data("id");

    if (question_id) {
        consumer.subscriptions.create({ channel: "AnswersChannel", id: question_id }, {
            received(data) {
                console.log(data)

                if (gon.user_id !== data.author_id) {
                    $("body").find(".answers").append(data.body);
                    window.GistEmbed.init()
                }
            }
        });
    }
})
