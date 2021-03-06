shared_examples_for 'API resource contains' do
  it 'contains comments object' do
    expect(resource_response['comments'].first['id']).to eq(resource.comments.first.id)
  end

  it 'contains links object' do
    expect(resource_response['links'].first['id']).to eq(resource.links.first.id)
  end

  it 'contains files object' do
    expect(resource_response['files'].first['id']).to eq(resource.files.first.id)
  end

  it 'contains files url' do
    expect(resource_response['files'].first['url']).to eq rails_blob_path(resource.files.first, only_path: true)
  end
end
