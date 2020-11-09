$(document).on('turbolinks:load', function() {
    $('.vote_for, .vote_against').on('ajax:success', function(e) {
        var resource = e.detail[0];
        var resourceId = resource.id;

        $(`.votes_sum-${resourceId}`).html(resource.rating);
    })
        .on('ajax:error', function (e) {
            var errors = e.detail[0];

            $.each(errors, function(index, value) {
                $('.answer-errors').html('<p>' + value + '</p>');
            })
        });
});
