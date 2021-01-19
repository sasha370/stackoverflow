shared_examples_for 'API Updatable' do


  context 'with correct data' do
    before { do_request(method_name, api_path, params: {resource => resource_attr, access_token: access_token.token}, headers: headers) }

    it 'return 200 status' do
      expect(response).to be_successful
    end

    it 'return only resource' do
      expect([resource].size).to eq 1
    end

    it 'return resource with correct user' do
      expect(resource_response['user']['id']).to eq user.id
    end

    it 'returns correct fields' do
      attributes.each do |attr|
        expect(resource_response[attr]).to eq resource_attr[attr.to_sym]
      end
    end
  end

  context 'with incorrect data' do
    before { do_request(method_name, api_path, params: {resource.to_sym => resource_attr_incorrect, access_token: access_token.token}, headers: headers )}

    it 'don`t save resource in DB' do
      expect { do_request(method_name, api_path, params: {resource.to_sym => resource_attr_incorrect, access_token: access_token.token}, headers: headers )}.to_not change(model, :count)
    end

    it 'return 422 status' do
      expect(response).to have_http_status(422)
    end
  end
end
