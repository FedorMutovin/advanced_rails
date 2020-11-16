$(document).on('turbolinks:load', function() {
    $('.vote_for, .vote_against, .delete_vote').on('ajax:success', function(e) {
        var resource = e.detail[0];
        var resourceId = resource.id;

        $(`.votes_sum-${resourceId}`).html(resource.votes_sum);
        location.reload()
    })
        .on('ajax:error', function (e) {
            var errors = e.detail[0];

            $.each(errors, function(index, value) {
                $('.errors').html('<p>' + value + '</p>');
            })
        });
});
