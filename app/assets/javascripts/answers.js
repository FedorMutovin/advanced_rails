$(document).on('turbolinks:load', function(){
   $('.answers').on('click', '.edit-answer-link', function(e) {
        e.preventDefault();
        $(this).hide();
        var answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).removeClass('hidden');
   })

    $('form.new_answer').on('ajax:success', function(event) {
        var answer = event.detail[0];

        $('.answers').append('<p>' + answer.body + '</p>');
    })
        .on('ajax:error', function (event) {
            var errors = event.detail[0];

            $.each(errors, function(index, value) {
                $('.answer-errors').append('<p>' + value + '</p>')
            })
        })
});
