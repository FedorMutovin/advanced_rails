import consumer from "./consumer"

$(document).on("turbolinks:load", function(e) {
    const question_id = $("#question-channel-provider").data("id");

    if (question_id) {
        consumer.subscriptions.create({ channel: "CommentsChannel", id: question_id }, {
            received(data) {
                if (gon.user_id !== data.author_id) {
                    $(`.question-comments`).append(data.body);
                    window.GistEmbed.init()
                }
            }
        });
    }

    const answer_ids = $(".answer-channel-provider").toArray().map(elem => $(elem).data("channel-id"))
    answer_ids.forEach((id) => {
        subscribeToAnswerChannel(id)
    })
})

window.subscribeToAnswerChannel =  function subscribeToAnswerChannel(id) {
    consumer.subscriptions.create({ channel: "CommentsChannel", id: id }, {
        received(data) {
            if (gon.user_id !== data.author_id) {
                $(`.answer-comments`).append(data.body);
                window.GistEmbed.init()
            }
        }
    });
}
