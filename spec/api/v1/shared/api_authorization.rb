shared_examples_for 'API Authorizer' do

  context 'unauthorized' do
    it 'returns 401 status if there id no access_token' do
      do_request(method_name, api_path, headers: headers)
      puts response.status
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      do_request(method_name, api_path, params: {access_token: '1234'}, headers: headers)
      expect(response.status).to eq 401
    end
  end
end
