shared_examples_for 'API Listable' do
  let(:resource_response) { json[resource_name] }

  before { do_request(method_name, api_path, params: {access_token: access_token.token}, headers: headers) }

  it 'return 200 status' do
    expect(response).to be_successful
  end

  it 'return resource' do
    expect([resource_name].size).to eq 1
  end

  it 'returns public fields' do
    public_fields.each do |attr|
      expect(resource_response[attr]).to eq resource.send(attr).as_json
    end
  end

  it 'contains user object' do
    expect(resource_response['user']).to have_key('id')
  end

  it 'contains list of all content_type' do
    content_types.each do |type|
      expect(resource_response[type].size).to eq resource.send(type).count
      expect(resource_response[type].first['id']).to eq resource.send(type).first.id
    end
  end
end
