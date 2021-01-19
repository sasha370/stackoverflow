shared_examples_for 'API Destroyable' do

  context 'with correct data' do
    it 'return 200 status' do
      do_request(method_name, api_path, params: {access_token: access_token.token}, headers: headers)
      expect(response).to be_successful
    end

    it 'delete question in DB' do
      expect { delete api_path, params: {access_token: access_token.token}, headers: headers }.to change(model, :count).by(-1)
    end
  end

  context "can`t delete another_user resource" do
    it 'return 403 status' do
      do_request(method_name, another_api_path, params: {access_token: access_token.token}, headers: headers)
      expect(response.status).to eq 403
    end

    it 'delete question in DB' do
      expect { do_request(method_name, another_api_path, params: {access_token: access_token.token}, headers: headers) }.to_not change(model, :count)
    end
  end
end
