FactoryBot.define do
  factory :link do
    factory :google_link do
      name { 'Google' }
      url { 'https://google.com' }
    end

    factory :gist_link, class: 'Link' do
      name { 'Gist' }
      url { 'https://gist.github.com/FedorMutovin/00719ddb7e67687c023d8352d36d5ce3' }
    end
  end
end
