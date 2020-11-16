import consumer from "channels/consumer"

consumer.subscriptions.create('QuestionsChannel', {
    connected: function() {
        return this.perform('follow');
    },
    received: function(data) {
        return $('.questions').append(data);
    }
});
